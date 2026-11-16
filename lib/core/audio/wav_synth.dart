import 'dart:math' as math;
import 'dart:typed_data';

/// Game sound effect identifiers.
enum GameSfx {
  diceRoll,
  diceReveal,
  criticalHit,
  criticalFumble,
  swordSlash,
  staffCast,
  bowShot,
  daggerFlurry,
  holySmite,
  shieldGuard,
  hitImpact,
  levelUp,
  setComplete,
}

/// Pure-Dart procedural 16-bit PCM WAV synthesizer for offline retro /
/// dark-fantasy sound effects without requiring external audio assets.
abstract final class WavSynth {
  static const int sampleRate = 22050;

  /// Synthesizes a complete WAV file (RIFF header + PCM samples) for [sfx].
  static Uint8List generate(GameSfx sfx) {
    final samples = switch (sfx) {
      GameSfx.diceRoll => _diceRoll(),
      GameSfx.diceReveal => _toneBurst(
          freqStart: 520,
          freqEnd: 780,
          durationMs: 110,
          wave: _Wave.triangle,
          volume: 0.45,
        ),
      GameSfx.criticalHit => _fanfare(
          freqs: [523.25, 659.25, 783.99, 1046.5],
          stepMs: 70,
          wave: _Wave.square,
          volume: 0.42,
        ),
      GameSfx.criticalFumble => _fanfare(
          freqs: [240, 195, 145],
          stepMs: 95,
          wave: _Wave.sawtooth,
          volume: 0.45,
        ),
      GameSfx.swordSlash => _noiseSweep(
          freqStart: 950,
          freqEnd: 180,
          durationMs: 170,
          noiseMix: 0.65,
          volume: 0.48,
        ),
      GameSfx.staffCast => _toneBurst(
          freqStart: 320,
          freqEnd: 980,
          durationMs: 240,
          wave: _Wave.sine,
          volume: 0.45,
        ),
      GameSfx.bowShot => _noiseSweep(
          freqStart: 1400,
          freqEnd: 420,
          durationMs: 130,
          noiseMix: 0.50,
          volume: 0.44,
        ),
      GameSfx.daggerFlurry => _doubleSlash(),
      GameSfx.holySmite => _fanfare(
          freqs: [440, 554.37, 659.25, 880],
          stepMs: 65,
          wave: _Wave.triangle,
          volume: 0.48,
        ),
      GameSfx.shieldGuard => _toneBurst(
          freqStart: 220,
          freqEnd: 310,
          durationMs: 150,
          wave: _Wave.square,
          volume: 0.36,
        ),
      GameSfx.hitImpact => _noiseSweep(
          freqStart: 190,
          freqEnd: 65,
          durationMs: 140,
          noiseMix: 0.55,
          volume: 0.52,
        ),
      GameSfx.levelUp => _fanfare(
          freqs: [392.0, 493.88, 587.33, 783.99],
          stepMs: 90,
          wave: _Wave.triangle,
          volume: 0.48,
        ),
      GameSfx.setComplete => _toneBurst(
          freqStart: 587.33,
          freqEnd: 880.0,
          durationMs: 130,
          wave: _Wave.triangle,
          volume: 0.38,
        ),
    };
    return _encodeWav(samples);
  }

  static Int16List _diceRoll() {
    // 4 quick wooden/stone clack impulses simulating a d20 bouncing on stone
    final totalSamples = (sampleRate * 0.42).round();
    final out = Int16List(totalSamples);
    final rng = math.Random(42);
    const bounceOffsets = [0.0, 0.11, 0.21, 0.30];
    for (final offsetSec in bounceOffsets) {
      final startIdx = (offsetSec * sampleRate).round();
      final burstLen = (0.045 * sampleRate).round();
      for (var i = 0; i < burstLen && startIdx + i < totalSamples; i++) {
        final t = i / burstLen;
        final env = (1.0 - t) * (1.0 - t);
        final tone = math.sin(2 * math.pi * (280 + t * 140) * (i / sampleRate));
        final click = (rng.nextDouble() * 2 - 1) * 0.55;
        final sample = ((tone * 0.45 + click) * env * 0.45 * 32767).round();
        out[startIdx + i] = (out[startIdx + i] + sample).clamp(-32767, 32767);
      }
    }
    return out;
  }

  static Int16List _doubleSlash() {
    final totalSamples = (sampleRate * 0.24).round();
    final out = Int16List(totalSamples);
    final first = _noiseSweep(
      freqStart: 1100,
      freqEnd: 260,
      durationMs: 95,
      noiseMix: 0.6,
      volume: 0.42,
    );
    final secondStart = (sampleRate * 0.11).round();
    for (var i = 0; i < first.length && i < totalSamples; i++) {
      out[i] = first[i];
    }
    for (var i = 0; i < first.length && secondStart + i < totalSamples; i++) {
      out[secondStart + i] =
          (out[secondStart + i] + first[i]).clamp(-32767, 32767);
    }
    return out;
  }

  static Int16List _toneBurst({
    required double freqStart,
    required double freqEnd,
    required int durationMs,
    required _Wave wave,
    required double volume,
  }) {
    final len = (sampleRate * durationMs / 1000).round();
    final out = Int16List(len);
    var phase = 0.0;
    for (var i = 0; i < len; i++) {
      final progress = i / len;
      final env = math.sin(progress * math.pi).clamp(0.0, 1.0);
      final freq = freqStart + (freqEnd - freqStart) * progress;
      phase += 2 * math.pi * freq / sampleRate;
      final raw = _sampleWave(phase, wave);
      out[i] = (raw * env * volume * 32767).round().clamp(-32767, 32767);
    }
    return out;
  }

  static Int16List _noiseSweep({
    required double freqStart,
    required double freqEnd,
    required int durationMs,
    required double noiseMix,
    required double volume,
  }) {
    final len = (sampleRate * durationMs / 1000).round();
    final out = Int16List(len);
    final rng = math.Random(1337);
    var phase = 0.0;
    for (var i = 0; i < len; i++) {
      final progress = i / len;
      final env = (1.0 - progress) * (1.0 - progress * 0.35);
      final freq = freqStart + (freqEnd - freqStart) * progress;
      phase += 2 * math.pi * freq / sampleRate;
      final tone = math.sin(phase);
      final noise = rng.nextDouble() * 2 - 1;
      final mixed = tone * (1.0 - noiseMix) + noise * noiseMix;
      out[i] = (mixed * env * volume * 32767).round().clamp(-32767, 32767);
    }
    return out;
  }

  static Int16List _fanfare({
    required List<double> freqs,
    required int stepMs,
    required _Wave wave,
    required double volume,
  }) {
    final stepLen = (sampleRate * stepMs / 1000).round();
    final totalLen = stepLen * freqs.length;
    final out = Int16List(totalLen);
    for (var n = 0; n < freqs.length; n++) {
      final freq = freqs[n];
      var phase = 0.0;
      for (var i = 0; i < stepLen; i++) {
        final progress = i / stepLen;
        final env = (1.0 - progress * 0.65);
        phase += 2 * math.pi * freq / sampleRate;
        final raw = _sampleWave(phase, wave);
        out[n * stepLen + i] =
            (raw * env * volume * 32767).round().clamp(-32767, 32767);
      }
    }
    return out;
  }

  static double _sampleWave(double phase, _Wave wave) {
    final norm = (phase % (2 * math.pi)) / (2 * math.pi);
    return switch (wave) {
      _Wave.sine => math.sin(phase),
      _Wave.square => norm < 0.5 ? 0.7 : -0.7,
      _Wave.triangle => 1.0 - 4.0 * (norm - 0.5).abs(),
      _Wave.sawtooth => 2.0 * norm - 1.0,
    };
  }

  static Uint8List _encodeWav(Int16List samples) {
    final dataSize = samples.length * 2;
    final byteData = ByteData(44 + dataSize);

    // RIFF header
    byteData.setUint8(0, 0x52); // R
    byteData.setUint8(1, 0x49); // I
    byteData.setUint8(2, 0x46); // F
    byteData.setUint8(3, 0x46); // F
    byteData.setUint32(4, 36 + dataSize, Endian.little);
    byteData.setUint8(8, 0x57); // W
    byteData.setUint8(9, 0x41); // A
    byteData.setUint8(10, 0x56); // V
    byteData.setUint8(11, 0x45); // E

    // fmt subchunk
    byteData.setUint8(12, 0x66); // f
    byteData.setUint8(13, 0x6D); // m
    byteData.setUint8(14, 0x74); // t
    byteData.setUint8(15, 0x20); // ' '
    byteData.setUint32(16, 16, Endian.little); // PCM
    byteData.setUint16(20, 1, Endian.little); // Linear PCM
    byteData.setUint16(22, 1, Endian.little); // Mono
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, sampleRate * 2, Endian.little); // Byte rate
    byteData.setUint16(32, 2, Endian.little); // Block align
    byteData.setUint16(34, 16, Endian.little); // Bits per sample

    // data subchunk
    byteData.setUint8(36, 0x64); // d
    byteData.setUint8(37, 0x61); // a
    byteData.setUint8(38, 0x74); // t
    byteData.setUint8(39, 0x61); // a
    byteData.setUint32(40, dataSize, Endian.little);

    for (var i = 0; i < samples.length; i++) {
      byteData.setInt16(44 + i * 2, samples[i], Endian.little);
    }
    return byteData.buffer.asUint8List();
  }
}

enum _Wave { sine, square, triangle, sawtooth }
