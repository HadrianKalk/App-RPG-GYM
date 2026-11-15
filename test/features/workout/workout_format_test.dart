import 'package:app/features/workout/presentation/workout_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('duration formatting', () {
    expect(WorkoutFormat.duration(45), '0:45');
    expect(WorkoutFormat.duration(600), '10:00');
    expect(WorkoutFormat.duration(3725), '1:02:05');
  });

  test('duration parsing: m:ss or plain minutes', () {
    expect(WorkoutFormat.parseDuration('1:30'), 90);
    expect(WorkoutFormat.parseDuration('0:45'), 45);
    expect(WorkoutFormat.parseDuration('25'), 1500);
    expect(WorkoutFormat.parseDuration('0,5'), 30);
    expect(WorkoutFormat.parseDuration('abc'), isNull);
    expect(WorkoutFormat.parseDuration(''), isNull);
  });

  test('weight without useless decimals', () {
    expect(WorkoutFormat.weight(60), '60');
    expect(WorkoutFormat.weight(62.5), '62.5');
  });
}
