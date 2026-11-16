import 'package:flutter/services.dart';

/// Fallback audio playback for Web/non-IO platforms.
Future<void> playWavBytes(Uint8List wavBytes) async {
  try {
    await SystemSound.play(SystemSoundType.click);
  } catch (_) {
    // Ignore in headless/test environments without platform channels.
  }
}
