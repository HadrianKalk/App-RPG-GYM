import '../../core/game/routine.dart';

/// Built-in routine templates: a starting point for new users.
///
/// Pure data: add/remove a template or tweak targets here; names and
/// descriptions live in the localized game content under
/// `routine.<id>.name` / `.description`.
abstract final class RoutineSeed {
  static const List<Routine> templates = [
    Routine(
      id: 'tpl_push',
      source: RoutineSource.template,
      exercises: [
        RoutineExercise(exerciseId: 'ex_supino_reto_barra', sets: 4, repsMin: 6, repsMax: 8, restSeconds: 150),
        RoutineExercise(exerciseId: 'ex_supino_inclinado_halteres', sets: 3, repsMin: 8, repsMax: 10, restSeconds: 120),
        RoutineExercise(exerciseId: 'ex_desenvolvimento_militar_barra', sets: 3, repsMin: 6, repsMax: 8, restSeconds: 150),
        RoutineExercise(exerciseId: 'ex_elevacao_lateral_halteres', sets: 3, repsMin: 12, repsMax: 15, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_triceps_corda_polia', sets: 3, repsMin: 10, repsMax: 12, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_mergulho_paralelas_peito', sets: 2, toFailure: true, restSeconds: 90),
      ],
    ),
    Routine(
      id: 'tpl_pull',
      source: RoutineSource.template,
      exercises: [
        RoutineExercise(exerciseId: 'ex_barra_fixa_pronada', sets: 4, repsMin: 6, repsMax: 10, restSeconds: 150),
        RoutineExercise(exerciseId: 'ex_remada_curvada_barra', sets: 4, repsMin: 6, repsMax: 8, restSeconds: 150),
        RoutineExercise(exerciseId: 'ex_remada_baixa_triangulo', sets: 3, repsMin: 10, repsMax: 12, restSeconds: 90),
        RoutineExercise(exerciseId: 'ex_face_pull_polia', sets: 3, repsMin: 12, repsMax: 15, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_rosca_direta_barra_w', sets: 3, repsMin: 8, repsMax: 10, restSeconds: 90),
        RoutineExercise(exerciseId: 'ex_rosca_martelo_halteres', sets: 3, repsMin: 10, repsMax: 12, restSeconds: 60),
      ],
    ),
    Routine(
      id: 'tpl_legs',
      source: RoutineSource.template,
      exercises: [
        RoutineExercise(exerciseId: 'ex_agachamento_livre_barra', sets: 4, repsMin: 5, repsMax: 8, restSeconds: 180),
        RoutineExercise(exerciseId: 'ex_stiff_barra', sets: 3, repsMin: 8, repsMax: 10, restSeconds: 150),
        RoutineExercise(exerciseId: 'ex_leg_press_45', sets: 3, repsMin: 10, repsMax: 12, restSeconds: 120),
        RoutineExercise(exerciseId: 'ex_cadeira_flexora', sets: 3, repsMin: 10, repsMax: 12, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_elevacao_pelvica_barra', sets: 3, repsMin: 8, repsMax: 12, restSeconds: 90),
        RoutineExercise(exerciseId: 'ex_panturrilha_em_pe_maquina', sets: 4, repsMin: 12, repsMax: 15, restSeconds: 60),
      ],
    ),
    Routine(
      id: 'tpl_cardio_mobility',
      source: RoutineSource.template,
      exercises: [
        RoutineExercise(exerciseId: 'ex_mobilidade_quadril_tornozelo', sets: 1, durationSeconds: 600, restSeconds: 30),
        RoutineExercise(exerciseId: 'ex_corrida_esteira_rua', sets: 1, durationSeconds: 1500, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_saltar_corda', sets: 3, durationSeconds: 120, restSeconds: 60),
        RoutineExercise(exerciseId: 'ex_prancha_isometrica', sets: 3, durationSeconds: 45, restSeconds: 45),
        RoutineExercise(exerciseId: 'ex_alongamento_geral', sets: 1, durationSeconds: 600, restSeconds: 0),
      ],
    ),
  ];
}
