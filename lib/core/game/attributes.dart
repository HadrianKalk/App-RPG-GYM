/// Os 6 atributos clássicos do RPG D&D adaptados para a vida real.
enum Attribute {
  strength(
    code: 'FOR',
    name: 'Força',
    description: 'Potência física e levantamento de cargas. Treinos de musculação e calistenia.',
  ),
  dexterity(
    code: 'DES',
    name: 'Destreza',
    description: 'Coordenação, precisão e agilidade. Alongamentos, yoga e esportes.',
  ),
  constitution(
    code: 'CON',
    name: 'Constituição',
    description: 'Resistência, saúde e vitalidade. Cardio, sono reparador e hidratação.',
  ),
  intelligence(
    code: 'INT',
    name: 'Inteligência',
    description: 'Raciocínio lógico e conhecimento técnico. Estudo com foco (Pomodoro) e programação.',
  ),
  wisdom(
    code: 'SAB',
    name: 'Sabedoria',
    description: 'Percepção e autoconhecimento. Meditação, diário, leitura reflexiva e caminhada.',
  ),
  charisma(
    code: 'CAR',
    name: 'Carisma',
    description: 'Expressão, presença e influência. Socialização, falar em público e conversação.',
  );

  const Attribute({
    required this.code,
    required this.name,
    required this.description,
  });

  final String code;
  final String name;
  final String description;
}
