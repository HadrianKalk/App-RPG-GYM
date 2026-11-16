import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';

typedef _PlaySoundNative = Int32 Function(
  Pointer<Uint8> pszSound,
  IntPtr hmod,
  Uint32 fdwSound,
);
typedef _PlaySoundDart = int Function(
  Pointer<Uint8> pszSound,
  int hmod,
  int fdwSound,
);

/// Plays synthesized PCM WAV bytes on Windows via `winmm.dll!PlaySoundA`
/// (with `SND_MEMORY | SND_ASYNC | SND_NODEFAULT`) without requiring extra
/// native plugins, falling back to [SystemSound] on other platforms.
Future<void> playWavBytes(Uint8List wavBytes) async {
  if (Platform.isWindows) {
    final played = _WinMmAudio.playMemory(wavBytes);
    if (played) return;
  }
  try {
    await SystemSound.play(SystemSoundType.click);
  } catch (_) {
    // Ignore in headless/test environments.
  }
}

abstract final class _WinMmAudio {
  static const int _sndMemory = 0x0004;
  static const int _sndAsync = 0x0001;
  static const int _sndNoDefault = 0x0002;

  static _PlaySoundDart? _playSound;
  static bool _initAttempted = false;
  static Pointer<Uint8>? _activeBuffer;

  static bool playMemory(Uint8List wavBytes) {
    try {
      if (!_initAttempted) {
        _initAttempted = true;
        final winmm = DynamicLibrary.open('winmm.dll');
        _playSound = winmm.lookupFunction<_PlaySoundNative, _PlaySoundDart>(
          'PlaySoundA',
        );
      }
      final fn = _playSound;
      if (fn == null) return false;

      // Keep a single reusable native buffer for the currently playing sound.
      final ptr = _allocNative(wavBytes);
      if (ptr == null) return false;
      final ok = fn(ptr, 0, _sndMemory | _sndAsync | _sndNoDefault);
      return ok != 0;
    } catch (_) {
      return false;
    }
  }

  static Pointer<Uint8>? _allocNative(Uint8List bytes) {
    try {
      final kernel32 = DynamicLibrary.open('kernel32.dll');
      final heapAlloc = kernel32.lookupFunction<
          Pointer<Uint8> Function(IntPtr, Uint32, IntPtr),
          Pointer<Uint8> Function(int, int, int)>('HeapAlloc');
      final heapFree = kernel32.lookupFunction<
          Int32 Function(IntPtr, Uint32, Pointer<Uint8>),
          int Function(int, int, Pointer<Uint8>)>('HeapFree');
      final getProcessHeap = kernel32.lookupFunction<
          IntPtr Function(),
          int Function()>('GetProcessHeap');

      final heap = getProcessHeap();
      final prev = _activeBuffer;
      final ptr = heapAlloc(heap, 0, bytes.length);
      if (ptr == nullptr) return null;
      ptr.asTypedList(bytes.length).setAll(0, bytes);
      _activeBuffer = ptr;
      if (prev != null && prev != nullptr) {
        heapFree(heap, 0, prev);
      }
      return ptr;
    } catch (_) {
      return null;
    }
  }
}
