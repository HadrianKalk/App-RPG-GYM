import 'package:app/core/audio/wav_synth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WavSynth generates valid RIFF/WAVE PCM headers for every GameSfx', () {
    for (final sfx in GameSfx.values) {
      final bytes = WavSynth.generate(sfx);
      expect(bytes.length, greaterThan(44));
      // RIFF....WAVE
      expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIFF');
      expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WAVE');
      expect(String.fromCharCodes(bytes.sublist(12, 16)), 'fmt ');
      expect(String.fromCharCodes(bytes.sublist(36, 40)), 'data');
    }
  });
}
