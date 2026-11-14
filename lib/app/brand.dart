/// Centraliza toda a identidade de marca e nomenclatura do aplicativo.
///
/// Se no futuro você quiser alterar o nome do projeto (ex: de "Grindheim"
/// para qualquer outro ou mudar para uma franquia), basta alterar os valores abaixo.
abstract final class AppBrand {
  /// Nome da série / franquia (opcional)
  static const String seriesTitle = 'RPGym';

  /// Nome do jogo / universo atual
  static const String appName = 'Grindheim';

  /// Subtítulo / Tema
  static const String subtitle = 'A Forja dos Heróis';

  /// Slogan de apresentação
  static const String tagline = 'Forje seu personagem através do esforço real.';

  /// Título completo para cabeçalhos e janelas
  static const String fullTitle = '$seriesTitle: $appName';

  /// Versão de exibição
  static const String version = '0.1.0 (Alfa)';
}
