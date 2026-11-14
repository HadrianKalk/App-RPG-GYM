/// Identidade do herói definida na criação de personagem.
///
/// Tudo aqui é **narrativo**: nome, origem e forma de tratamento não alteram
/// nenhum número do jogo. Servem para a UI e, na Fase 2, para o narrador.
library;

/// Forma de tratamento usada nos textos (o português é flexionado em gênero).
enum HeroForm {
  masculine(label: 'Ele', title: 'Herói'),
  feminine(label: 'Ela', title: 'Heroína'),
  neutral(label: 'Neutro', title: 'Lenda');

  const HeroForm({required this.label, required this.title});

  /// Rótulo curto exibido no seletor.
  final String label;

  /// Título genérico ("Herói", "Heroína", "Lenda").
  final String title;
}

/// Origem (background) do herói, no espírito dos antecedentes do D&D 5e.
/// Apenas narrativa: nenhuma origem concede bônus de atributo.
enum HeroOrigin {
  soldier(
    name: 'Ex-Soldado',
    icon: '⚔️',
    description: 'Marcado por guerras que não escolheu. Conhece a disciplina, '
        'mas busca agora uma causa própria.',
  ),
  scholar(
    name: 'Erudito Exilado',
    icon: '📜',
    description: 'Expulso da biblioteca por ler o que não devia. '
        'Sabe que conhecimento sem corpo é chama sem lenha.',
  ),
  wanderer(
    name: 'Andarilho sem Nome',
    icon: '🥾',
    description: 'Ninguém sabe de onde veio. Cada cicatriz é um capítulo que '
        'ainda não contou.',
  ),
  acolyte(
    name: 'Acólito Desgarrado',
    icon: '🕯️',
    description: 'Abandonou o templo quando os deuses se calaram. '
        'Procura a fé que nasce do esforço, não da prece.',
  ),
  smith(
    name: 'Aprendiz de Ferreiro',
    icon: '🔨',
    description: 'Cresceu entre a bigorna e o fogo. Acredita que todo metal — '
        'e toda vontade — se molda sob pressão.',
  ),
  fallenHeir(
    name: 'Herdeiro Caído',
    icon: '👑',
    description: 'Perdeu título, terras e nome de família. '
        'O que restou foi a vontade de reconstruir tudo com as próprias mãos.',
  );

  const HeroOrigin({
    required this.name,
    required this.icon,
    required this.description,
  });

  final String name;
  final String icon;
  final String description;
}

/// Perfil imutável do herói.
final class HeroProfile {
  const HeroProfile({
    required this.name,
    required this.form,
    required this.origin,
    required this.createdAt,
    this.oath,
  });

  /// Tamanho máximo do nome do herói.
  static const int maxNameLength = 24;

  /// Tamanho máximo do juramento.
  static const int maxOathLength = 140;

  final String name;
  final HeroForm form;
  final HeroOrigin origin;
  final DateTime createdAt;

  /// "Por que você treina?" — motivação pessoal, usada pelo narrador.
  final String? oath;

  /// Normaliza e valida um nome. Retorna `null` se válido, ou a mensagem de erro.
  static String? validateName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return 'Todo herói precisa de um nome.';
    if (name.length < 2) return 'Nome muito curto.';
    if (name.length > maxNameLength) {
      return 'Máximo de $maxNameLength caracteres.';
    }
    return null;
  }
}
