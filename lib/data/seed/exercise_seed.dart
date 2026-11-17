import '../../core/game/attributes.dart';
import '../../core/game/exercise_taxonomy.dart';

/// One entry of the built-in exercise catalog.
///
/// [name] is the Portuguese fallback stored in the database (used only if a
/// translation is missing); the displayed name comes from the localized game
/// content key `exercise.<id>`.
final class ExerciseSeedItem {
  const ExerciseSeedItem({
    required this.id,
    required this.name,
    required this.muscle,
    required this.equipment,
    required this.attribute,
    required this.tracking,
  });

  final String id;
  final String name;
  final MuscleGroup muscle;
  final Equipment equipment;
  final Attribute attribute;
  final SetTracking tracking;
}

/// Built-in exercise catalog. It is re-synced into the database on every
/// start (see `WorkoutRepository.syncCatalog`), so editing this list is
/// enough to add, rename or re-classify catalog exercises.
abstract final class ExerciseSeed {
  static const List<ExerciseSeedItem> defaultExercises = [
    ExerciseSeedItem(id: 'ex_supino_reto_barra', name: 'Supino Reto com Barra', muscle: MuscleGroup.chest, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_supino_inclinado_halteres', name: 'Supino Inclinado com Halteres', muscle: MuscleGroup.chest, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_supino_declinado_barra', name: 'Supino Declinado com Barra', muscle: MuscleGroup.chest, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_crucifixo_halteres', name: 'Crucifixo Reto com Halteres', muscle: MuscleGroup.chest, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_crossover_polia', name: 'Crossover na Polia Alta', muscle: MuscleGroup.chest, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_peck_deck', name: 'Voador / Peck Deck', muscle: MuscleGroup.chest, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_flexao_braco', name: 'Flexão de Braço', muscle: MuscleGroup.chest, equipment: Equipment.bodyweight, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_mergulho_paralelas_peito', name: 'Paralelas com foco em Peito', muscle: MuscleGroup.chest, equipment: Equipment.bodyweight, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_puxada_alta_frente', name: 'Puxada Alta Frontal', muscle: MuscleGroup.back, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_remada_curvada_barra', name: 'Remada Curvada com Barra', muscle: MuscleGroup.back, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_remada_baixa_triangulo', name: 'Remada Baixa com Triângulo', muscle: MuscleGroup.back, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_remada_unilateral_serrote', name: 'Remada Serrote com Halter', muscle: MuscleGroup.back, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_barra_fixa_pronada', name: 'Barra Fixa (Pronada)', muscle: MuscleGroup.back, equipment: Equipment.bodyweight, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_barra_fixa_supinada', name: 'Barra Fixa (Supinada)', muscle: MuscleGroup.back, equipment: Equipment.bodyweight, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_pulldown_corda', name: 'Pulldown na Polia com Corda', muscle: MuscleGroup.back, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_levantamento_terra', name: 'Levantamento Terra Clássico', muscle: MuscleGroup.back, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_desenvolvimento_halteres', name: 'Desenvolvimento com Halteres', muscle: MuscleGroup.shoulders, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_desenvolvimento_militar_barra', name: 'Desenvolvimento Militar com Barra', muscle: MuscleGroup.shoulders, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_elevacao_lateral_halteres', name: 'Elevação Lateral com Halteres', muscle: MuscleGroup.shoulders, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_elevacao_lateral_polia', name: 'Elevação Lateral na Polia', muscle: MuscleGroup.shoulders, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_elevacao_frontal_halteres', name: 'Elevação Frontal com Halteres', muscle: MuscleGroup.shoulders, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_crucifixo_invertido_halteres', name: 'Crucifixo Invertido com Halteres', muscle: MuscleGroup.shoulders, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_face_pull_polia', name: 'Face Pull com Corda', muscle: MuscleGroup.shoulders, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_encolhimento_trapezio_barra', name: 'Encolhimento com Barra', muscle: MuscleGroup.traps, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_direta_barra_w', name: 'Rosca Direta com Barra W', muscle: MuscleGroup.biceps, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_alternada_halteres', name: 'Rosca Alternada com Halteres', muscle: MuscleGroup.biceps, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_martelo_halteres', name: 'Rosca Martelo com Halteres', muscle: MuscleGroup.biceps, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_scott_barra_w', name: 'Rosca Scott com Barra W', muscle: MuscleGroup.biceps, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_concentrada_halter', name: 'Rosca Concentrada com Halter', muscle: MuscleGroup.biceps, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_inversa_barra', name: 'Rosca Inversa com Barra', muscle: MuscleGroup.forearms, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_punho_polia', name: 'Flexão de Punho na Polia', muscle: MuscleGroup.forearms, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_punho_inversa_polia', name: 'Extensão de Punho na Polia', muscle: MuscleGroup.forearms, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_rosca_inversa_polia', name: 'Rosca Inversa na Polia', muscle: MuscleGroup.forearms, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_corda_polia', name: 'Tríceps Corda na Polia', muscle: MuscleGroup.triceps, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_barra_reta_polia', name: 'Tríceps Barra Reta na Polia', muscle: MuscleGroup.triceps, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_testa_barra_w', name: 'Tríceps Testa com Barra W', muscle: MuscleGroup.triceps, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_frances_halteres', name: 'Tríceps Francês com Halter', muscle: MuscleGroup.triceps, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_frances_unilateral_polia', name: 'Tríceps Francês Unilateral na Polia', muscle: MuscleGroup.triceps, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_coice_polia', name: 'Tríceps Coice na Polia', muscle: MuscleGroup.triceps, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_triceps_coice_halter', name: 'Tríceps Coice com Halter', muscle: MuscleGroup.triceps, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_mergulho_banco', name: 'Tríceps no Banco', muscle: MuscleGroup.triceps, equipment: Equipment.bodyweight, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_agachamento_livre_barra', name: 'Agachamento Livre com Barra', muscle: MuscleGroup.quads, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_leg_press_45', name: 'Leg Press 45º', muscle: MuscleGroup.quads, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_cadeira_extensora', name: 'Cadeira Extensora', muscle: MuscleGroup.quads, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_agachamento_hack', name: 'Agachamento Hack', muscle: MuscleGroup.quads, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_afundo_com_halteres', name: 'Passada / Afundo com Halteres', muscle: MuscleGroup.quads, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_agachamento_bulgaro', name: 'Agachamento Búlgaro', muscle: MuscleGroup.quads, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_agachamento_bulgaro_smith', name: 'Agachamento Búlgaro no Smith', muscle: MuscleGroup.quads, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_mesa_flexora', name: 'Mesa Flexora', muscle: MuscleGroup.hamstrings, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_cadeira_flexora', name: 'Cadeira Flexora', muscle: MuscleGroup.hamstrings, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_stiff_barra', name: 'Stiff com Barra', muscle: MuscleGroup.hamstrings, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_stiff_halteres', name: 'Stiff com Halteres', muscle: MuscleGroup.hamstrings, equipment: Equipment.dumbbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_elevacao_pelvica_barra', name: 'Elevação Pélvica com Barra', muscle: MuscleGroup.glutes, equipment: Equipment.barbell, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_cadeira_abdutora', name: 'Cadeira Abdutora', muscle: MuscleGroup.glutes, equipment: Equipment.machine, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_panturrilha_em_pe_maquina', name: 'Panturrilha em Pé na Máquina', muscle: MuscleGroup.calves, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_panturrilha_sentado_soleo', name: 'Panturrilha Sentado (Gêmeos)', muscle: MuscleGroup.calves, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_prancha_isometrica', name: 'Prancha Isométrica', muscle: MuscleGroup.core, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_abdominal_infra_paralela', name: 'Elevação de Pernas na Paralela', muscle: MuscleGroup.core, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_abdominal_supra_solo', name: 'Abdominal Tradicional no Solo', muscle: MuscleGroup.core, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_abdominal_polia_corda', name: 'Abdominal na Polia com Corda', muscle: MuscleGroup.core, equipment: Equipment.cable, attribute: Attribute.strength, tracking: SetTracking.weightReps),
    ExerciseSeedItem(id: 'ex_roda_abdominal', name: 'Abdominal com Rodinha (Ab Wheel)', muscle: MuscleGroup.core, equipment: Equipment.other, attribute: Attribute.strength, tracking: SetTracking.reps),
    ExerciseSeedItem(id: 'ex_alongamento_geral', name: 'Alongamento Completo de Cadeias', muscle: MuscleGroup.mobility, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_mobilidade_quadril_tornozelo', name: 'Rotina de Mobilidade de Quadril e Tornozelo', muscle: MuscleGroup.mobility, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_yoga_sessao', name: 'Sessão de Yoga / Vinyasa Flow', muscle: MuscleGroup.mobility, equipment: Equipment.bodyweight, attribute: Attribute.dexterity, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_saltar_corda', name: 'Pular Corda Ágil', muscle: MuscleGroup.cardio, equipment: Equipment.other, attribute: Attribute.dexterity, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_corrida_esteira_rua', name: 'Corrida (Esteira ou Rua)', muscle: MuscleGroup.cardio, equipment: Equipment.other, attribute: Attribute.constitution, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_bicicleta_ergometrica', name: 'Bicicleta Ergométrica', muscle: MuscleGroup.cardio, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_caminhada_inclinada', name: 'Caminhada Inclinada na Esteira', muscle: MuscleGroup.cardio, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_natacao', name: 'Natação Contínua', muscle: MuscleGroup.cardio, equipment: Equipment.other, attribute: Attribute.constitution, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_simulador_escada', name: 'Simulador de Escada', muscle: MuscleGroup.cardio, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.duration),
    ExerciseSeedItem(id: 'ex_remo_ergometro', name: 'Remo Ergométrico', muscle: MuscleGroup.cardio, equipment: Equipment.machine, attribute: Attribute.constitution, tracking: SetTracking.duration),
  ];
}
