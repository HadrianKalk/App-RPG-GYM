import '../../core/game/attributes.dart';

final class ExerciseSeedItem {
  const ExerciseSeedItem({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.attribute,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final Attribute attribute;
}

abstract final class ExerciseSeed {
  static const List<ExerciseSeedItem> defaultExercises = [
    // --- PEITO (Força) ---
    ExerciseSeedItem(id: 'ex_supino_reto_barra', name: 'Supino Reto com Barra', muscleGroup: 'Peitoral', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_supino_inclinado_halteres', name: 'Supino Inclinado com Halteres', muscleGroup: 'Peitoral', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_supino_declinado_barra', name: 'Supino Declinado com Barra', muscleGroup: 'Peitoral', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_crucifixo_halteres', name: 'Crucifixo Reto com Halteres', muscleGroup: 'Peitoral', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_crossover_polia', name: 'Crossover na Polia Alta', muscleGroup: 'Peitoral', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_peck_deck', name: 'Voador / Peck Deck', muscleGroup: 'Peitoral', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_flexao_braco', name: 'Flexão de Braço', muscleGroup: 'Peitoral', equipment: 'Peso Corporal', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_mergulho_paralelas_peito', name: 'Paralelas com foco em Peito', muscleGroup: 'Peitoral', equipment: 'Peso Corporal', attribute: Attribute.strength),

    // --- COSTAS (Força) ---
    ExerciseSeedItem(id: 'ex_puxada_alta_frente', name: 'Puxada Alta Frontal', muscleGroup: 'Dorsal', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_remada_curvada_barra', name: 'Remada Curvada com Barra', muscleGroup: 'Dorsal', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_remada_baixa_triangulo', name: 'Remada Baixa com Triângulo', muscleGroup: 'Dorsal', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_remada_unilateral_serrote', name: 'Remada Serrote com Halter', muscleGroup: 'Dorsal', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_barra_fixa_pronada', name: 'Barra Fixa (Pronada)', muscleGroup: 'Dorsal', equipment: 'Peso Corporal', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_barra_fixa_supinada', name: 'Barra Fixa (Supinada)', muscleGroup: 'Dorsal', equipment: 'Peso Corporal', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_pulldown_corda', name: 'Pulldown na Polia com Corda', muscleGroup: 'Dorsal', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_levantamento_terra', name: 'Levantamento Terra Clássico', muscleGroup: 'Costas / Cadeia Posterior', equipment: 'Barra', attribute: Attribute.strength),

    // --- OMBROS & TRAPÉZIO (Força) ---
    ExerciseSeedItem(id: 'ex_desenvolvimento_halteres', name: 'Desenvolvimento com Halteres', muscleGroup: 'Deltoides', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_desenvolvimento_militar_barra', name: 'Desenvolvimento Militar com Barra', muscleGroup: 'Deltoides', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_elevacao_lateral_halteres', name: 'Elevação Lateral com Halteres', muscleGroup: 'Deltoides', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_elevacao_lateral_polia', name: 'Elevação Lateral na Polia', muscleGroup: 'Deltoides', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_elevacao_frontal_halteres', name: 'Elevação Frontal com Halteres', muscleGroup: 'Deltoides', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_crucifixo_invertido_halteres', name: 'Crucifixo Invertido com Halteres', muscleGroup: 'Deltoides Posterior', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_face_pull_polia', name: 'Face Pull com Corda', muscleGroup: 'Deltoides Posterior', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_encolhimento_trapezio_barra', name: 'Encolhimento com Barra', muscleGroup: 'Trapézio', equipment: 'Barra', attribute: Attribute.strength),

    // --- BÍCEPS & ANTEBRAÇO (Força) ---
    ExerciseSeedItem(id: 'ex_rosca_direta_barra_w', name: 'Rosca Direta com Barra W', muscleGroup: 'Bíceps', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_rosca_alternada_halteres', name: 'Rosca Alternada com Halteres', muscleGroup: 'Bíceps', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_rosca_martelo_halteres', name: 'Rosca Martelo com Halteres', muscleGroup: 'Bíceps / Braquiorradial', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_rosca_scott_barra_w', name: 'Rosca Scott com Barra W', muscleGroup: 'Bíceps', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_rosca_concentrada_halter', name: 'Rosca Concentrada com Halter', muscleGroup: 'Bíceps', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_rosca_inversa_barra', name: 'Rosca Inversa com Barra', muscleGroup: 'Antebraço', equipment: 'Barra', attribute: Attribute.strength),

    // --- TRÍCEPS (Força) ---
    ExerciseSeedItem(id: 'ex_triceps_corda_polia', name: 'Tríceps Corda na Polia', muscleGroup: 'Tríceps', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_triceps_barra_reta_polia', name: 'Tríceps Barra Reta na Polia', muscleGroup: 'Tríceps', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_triceps_testa_barra_w', name: 'Tríceps Testa com Barra W', muscleGroup: 'Tríceps', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_triceps_frances_halteres', name: 'Tríceps Francês com Halter', muscleGroup: 'Tríceps', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_mergulho_banco', name: 'Tríceps no Banco', muscleGroup: 'Tríceps', equipment: 'Peso Corporal', attribute: Attribute.strength),

    // --- QUADRÍCEPS & PERNAS (Força / Constituição) ---
    ExerciseSeedItem(id: 'ex_agachamento_livre_barra', name: 'Agachamento Livre com Barra', muscleGroup: 'Quadríceps / Glúteos', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_leg_press_45', name: 'Leg Press 45º', muscleGroup: 'Quadríceps', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_cadeira_extensora', name: 'Cadeira Extensora', muscleGroup: 'Quadríceps', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_agachamento_hack', name: 'Agachamento Hack', muscleGroup: 'Quadríceps', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_afundo_com_halteres', name: 'Passada / Afundo com Halteres', muscleGroup: 'Pernas', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_agachamento_bulgaro', name: 'Agachamento Búlgaro', muscleGroup: 'Pernas / Glúteos', equipment: 'Halter', attribute: Attribute.strength),

    // --- POSTERIOR DE COXA & GLÚTEOS (Força) ---
    ExerciseSeedItem(id: 'ex_mesa_flexora', name: 'Mesa Flexora', muscleGroup: 'Isquiotibiais', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_cadeira_flexora', name: 'Cadeira Flexora', muscleGroup: 'Isquiotibiais', equipment: 'Máquina', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_stiff_barra', name: 'Stiff com Barra', muscleGroup: 'Isquiotibiais / Glúteos', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_stiff_halteres', name: 'Stiff com Halteres', muscleGroup: 'Isquiotibiais / Glúteos', equipment: 'Halter', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_elevacao_pelvica_barra', name: 'Elevação Pélvica com Barra', muscleGroup: 'Glúteos', equipment: 'Barra', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_cadeira_abdutora', name: 'Cadeira Abdutora', muscleGroup: 'Glúteos', equipment: 'Máquina', attribute: Attribute.strength),

    // --- PANTURRILHA (Força / Constituição) ---
    ExerciseSeedItem(id: 'ex_panturrilha_em_pe_maquina', name: 'Panturrilha em Pé na Máquina', muscleGroup: 'Panturrilhas', equipment: 'Máquina', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_panturrilha_sentado_soleo', name: 'Panturrilha Sentado (Gêmeos)', muscleGroup: 'Panturrilhas', equipment: 'Máquina', attribute: Attribute.constitution),

    // --- ABDÔMEN & CORE (Destreza / Força) ---
    ExerciseSeedItem(id: 'ex_prancha_isometrica', name: 'Prancha Isométrica', muscleGroup: 'Core / Abdômen', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_abdominal_infra_paralela', name: 'Elevação de Pernas na Paralela', muscleGroup: 'Abdômen', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_abdominal_supra_solo', name: 'Abdominal Tradicional no Solo', muscleGroup: 'Abdômen', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_abdominal_polia_corda', name: 'Abdominal na Polia com Corda', muscleGroup: 'Abdômen', equipment: 'Polia', attribute: Attribute.strength),
    ExerciseSeedItem(id: 'ex_roda_abdominal', name: 'Abdominal com Rodinha (Ab Wheel)', muscleGroup: 'Core', equipment: 'Outro', attribute: Attribute.strength),

    // --- MOBILIDADE & AGILIDADE (Destreza) ---
    ExerciseSeedItem(id: 'ex_alongamento_geral', name: 'Alongamento Completo de Cadeias', muscleGroup: 'Corpo Inteiro', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_mobilidade_quadril_tornozelo', name: 'Rotina de Mobilidade de Quadril e Tornozelo', muscleGroup: 'Membros Inferiores', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_yoga_sessao', name: 'Sessão de Yoga / Vinyasa Flow', muscleGroup: 'Corpo Inteiro', equipment: 'Peso Corporal', attribute: Attribute.dexterity),
    ExerciseSeedItem(id: 'ex_saltar_corda', name: 'Pular Corda Ágil', muscleGroup: 'Corpo Inteiro', equipment: 'Outro', attribute: Attribute.dexterity),

    // --- CARDIO & RESISTÊNCIA (Constituição) ---
    ExerciseSeedItem(id: 'ex_corrida_esteira_rua', name: 'Corrida (Esteira ou Rua)', muscleGroup: 'Cardiovascular', equipment: 'Outro', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_bicicleta_ergometrica', name: 'Bicicleta Ergométrica', muscleGroup: 'Cardiovascular', equipment: 'Máquina', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_caminhada_inclinada', name: 'Caminhada Inclinada na Esteira', muscleGroup: 'Cardiovascular', equipment: 'Máquina', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_natacao', name: 'Natação Contínua', muscleGroup: 'Corpo Inteiro', equipment: 'Outro', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_simulador_escada', name: 'Simulador de Escada', muscleGroup: 'Pernas / Cardiovascular', equipment: 'Máquina', attribute: Attribute.constitution),
    ExerciseSeedItem(id: 'ex_remo_ergometro', name: 'Remo Ergométrico', muscleGroup: 'Corpo Inteiro', equipment: 'Máquina', attribute: Attribute.constitution),
  ];
}
