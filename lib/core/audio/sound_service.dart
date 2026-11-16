import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/settings_providers.dart';
import '../game/hero_appearance.dart';
import 'sound_backend_stub.dart'
    if (dart.library.io) 'sound_backend_io.dart' as backend;
import 'wav_synth.dart';

export 'wav_synth.dart' show GameSfx;

/// Offline Dark-Fantasy Retro sound effect player backed by [WavSynth].
///
/// Honors `settingsProvider.soundEnabled` and caches generated WAV buffers
/// in memory so repeated combat/UI sounds play with zero allocation lag.
class SoundService {
  SoundService({required this.enabled});

  final bool enabled;
  static final Map<GameSfx, Uint8List> _cache = {};

  /// Plays [sfx] if sound effects are enabled (safe no-op in widget tests).
  Future<void> play(GameSfx sfx) async {
    if (!enabled) return;
    final bytes = _cache.putIfAbsent(sfx, () => WavSynth.generate(sfx));
    await backend.playWavBytes(bytes);
  }

  /// Plays the sound effect matching a specific weapon/class [AttackAnimationKind].
  Future<void> playForAttack(AttackAnimationKind kind) {
    final sfx = switch (kind) {
      AttackAnimationKind.greatswordCleave ||
      AttackAnimationKind.eldritchRunicSlash =>
        GameSfx.swordSlash,
      AttackAnimationKind.staffArcaneCast ||
      AttackAnimationKind.primalSongWave =>
        GameSfx.staffCast,
      AttackAnimationKind.daggerShadowFlurry => GameSfx.daggerFlurry,
      AttackAnimationKind.bowPiercingShot => GameSfx.bowShot,
      AttackAnimationKind.martialKiStrike => GameSfx.hitImpact,
      AttackAnimationKind.holyRadiantSmite => GameSfx.holySmite,
      AttackAnimationKind.defensiveGuard => GameSfx.shieldGuard,
    };
    return play(sfx);
  }
}

/// Provides a [SoundService] synchronized with the user's audio setting.
final soundServiceProvider = Provider<SoundService>((ref) {
  try {
    final enabled = ref.watch(settingsProvider.select((s) => s.soundEnabled));
    return SoundService(enabled: enabled);
  } catch (_) {
    // Allow isolated widget tests that omit sharedPreferencesProvider override.
    return SoundService(enabled: false);
  }
});
