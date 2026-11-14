import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta e tema visual inspirados em Dark Fantasy (Berserk / Dark Souls / Grimdark)
/// com estética de ferro fundido, brasa da forja e sangue seco.
abstract final class AppTheme {
  // Cores Base - Escuridão e Aço
  static const Color obsidianBlack = Color(0xFF0F0F12);
  static const Color castIron = Color(0xFF181A20);
  static const Color forgedSteel = Color(0xFF232630);
  static const Color ironBorder = Color(0xFF353945);

  // Destaques - Brasa e Fogo
  static const Color emberGold = Color(0xFFE0A96D);
  static const Color emberOrange = Color(0xFFD4733A);

  // Acento - Sangue e Ferida
  static const Color bloodCrimson = Color(0xFF9E2A2B);
  static const Color darkBlood = Color(0xFF5E1718);

  // Textos - Cinzas e Prata
  static const Color ashWhite = Color(0xFFEDE8E1);
  static const Color dullSilver = Color(0xFF9E9FA5);
  static const Color darkAsh = Color(0xFF6B6E77);

  // Cores de Atributos D&D
  static const Color colorStrength = Color(0xFFC0392B);     // Vermelho guerreiro
  static const Color colorDexterity = Color(0xFF27AE60);    // Verde ágil
  static const Color colorConstitution = Color(0xFFE67E22); // Laranja vital
  static const Color colorIntelligence = Color(0xFF2980B9); // Azul arcano
  static const Color colorWisdom = Color(0xFF8E44AD);       // Roxo místico
  static const Color colorCharisma = Color(0xFFF39C12);     // Dourado radiante

  static ThemeData get darkTheme {

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBlack,
      canvasColor: castIron,
      colorScheme: const ColorScheme.dark(
        primary: emberGold,
        onPrimary: obsidianBlack,
        secondary: bloodCrimson,
        onSecondary: ashWhite,
        surface: castIron,
        onSurface: ashWhite,
        error: bloodCrimson,
        onError: ashWhite,
        outline: ironBorder,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: castIron.withValues(alpha: 0.95),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ashWhite,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: emberGold),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: castIron,
        indicatorColor: emberGold.withValues(alpha: 0.15),
        elevation: 4,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? emberGold : dullSilver,
            letterSpacing: 0.8,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? emberGold : dullSilver,
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: castIron,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: ironBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ironBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.w600, letterSpacing: 1.1),
        titleMedium: GoogleFonts.cinzel(color: ashWhite, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: ashWhite, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: dullSilver, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: darkAsh, fontSize: 12),
        labelLarge: GoogleFonts.cinzel(color: emberGold, fontWeight: FontWeight.bold, letterSpacing: 1.0),
      ),
    );
  }
}
