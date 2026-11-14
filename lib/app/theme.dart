import 'package:material_ui/material_ui.dart';

import '../core/game/attributes.dart';
import '../features/settings/domain/app_settings.dart';

/// Dark-fantasy pixel theme. Colors are fixed; the display font (titles,
/// numbers, buttons) follows the user's [AppFontStyle].
abstract final class AppTheme {
  // --- Base palette -------------------------------------------------------
  static const Color obsidianBlack = Color(0xFF0F0F12);
  static const Color castIron = Color(0xFF181A20);
  static const Color forgedSteel = Color(0xFF232630);
  static const Color ironBorder = Color(0xFF353945);

  // --- Accents --------------------------------------------------------------
  static const Color emberGold = Color(0xFFE0A96D);
  static const Color emberGoldDark = Color(0xFFA87A48);
  static const Color emberGoldLight = Color(0xFFF3CF9F);
  static const Color emberOrange = Color(0xFFD4733A);
  static const Color bloodCrimson = Color(0xFF9E2A2B);
  static const Color darkBlood = Color(0xFF5E1718);
  static const Color doneGreen = Color(0xFF1D2A1F);

  // --- Text -----------------------------------------------------------------
  static const Color ashWhite = Color(0xFFEDE8E1);
  static const Color dullSilver = Color(0xFF9E9FA5);
  static const Color darkAsh = Color(0xFF6B6E77);

  // --- Attribute colors -----------------------------------------------------
  static const Map<Attribute, Color> attributeColors = {
    Attribute.strength: Color(0xFFC0392B),
    Attribute.dexterity: Color(0xFF27AE60),
    Attribute.constitution: Color(0xFFE67E22),
    Attribute.intelligence: Color(0xFF2980B9),
    Attribute.wisdom: Color(0xFF8E44AD),
    Attribute.charisma: Color(0xFFF39C12),
  };

  static Color attributeColor(Attribute a) => attributeColors[a]!;

  /// Body font (always readable sans-serif).
  static const String bodyFont = 'Inter';

  /// Builds the app theme for the chosen display [fontStyle].
  static ThemeData build(AppFontStyle fontStyle) {
    final display = DisplayFont.of(fontStyle);

    TextStyle d(double size, {Color color = ashWhite}) => display.style(size, color: color);
    const body = TextStyle(fontFamily: bodyFont);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: bodyFont,
      scaffoldBackgroundColor: obsidianBlack,
      canvasColor: castIron,
      extensions: [display],
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
        backgroundColor: castIron,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: d(24),
        iconTheme: const IconThemeData(color: emberGold),
        shape: const Border(bottom: BorderSide(color: forgedSteel, width: 3)),
      ),
      dividerTheme: const DividerThemeData(color: forgedSteel, thickness: 2, space: 2),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: forgedSteel,
        contentTextStyle: body.copyWith(color: ashWhite),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: emberGold, width: 2),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: castIron,
        titleTextStyle: d(24, color: emberGold),
        contentTextStyle: body.copyWith(color: dullSilver, fontSize: 14),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: emberGold, width: 3),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: obsidianBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: ironBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: ironBorder, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: emberGold, width: 2),
        ),
        hintStyle: TextStyle(color: darkAsh),
        labelStyle: TextStyle(color: dullSilver),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: emberGold,
          textStyle: d(18),
          shape: const RoundedRectangleBorder(),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: castIron,
        selectedColor: emberGold,
        side: const BorderSide(color: ironBorder, width: 2),
        shape: const RoundedRectangleBorder(),
        labelStyle: d(17),
        showCheckmark: false,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: emberGold,
        inactiveTrackColor: forgedSteel,
        thumbColor: emberGold,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 9),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: emberGold),
      textTheme: TextTheme(
        displayLarge: d(56),
        displayMedium: d(46),
        displaySmall: d(40),
        headlineMedium: d(32),
        headlineSmall: d(28),
        titleLarge: d(24),
        titleMedium: d(20),
        titleSmall: d(17),
        bodyLarge: body.copyWith(color: ashWhite, fontSize: 16),
        bodyMedium: body.copyWith(color: dullSilver, fontSize: 14),
        bodySmall: body.copyWith(color: darkAsh, fontSize: 12),
        labelLarge: d(20, color: emberGold),
        labelMedium: d(16, color: dullSilver),
        labelSmall: d(14, color: darkAsh),
      ),
    );
  }
}

/// Theme extension carrying the display font, so any widget can render
/// pixel/classic headings and numbers via `DisplayFont.of(context)`.
///
/// Sizes are written for the pixel font; the classic serif is visually
/// larger, so it is scaled down by [scale].
@immutable
class DisplayFont extends ThemeExtension<DisplayFont> {
  const DisplayFont({required this.family, required this.scale, required this.weight});

  factory DisplayFont.of(AppFontStyle style) => switch (style) {
        AppFontStyle.pixel => const DisplayFont(family: 'Jersey10', scale: 1.0, weight: FontWeight.w400),
        AppFontStyle.classic => const DisplayFont(family: 'Cinzel', scale: 0.78, weight: FontWeight.w700),
      };

  final String family;
  final double scale;
  final FontWeight weight;

  /// Display text style at a pixel-font-equivalent [size].
  TextStyle style(double size, {Color color = AppTheme.ashWhite, double? height}) => TextStyle(
        fontFamily: family,
        fontSize: size * scale,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: 0.4,
      );

  /// Reads the extension from the current theme.
  static DisplayFont from(BuildContext context) =>
      Theme.of(context).extension<DisplayFont>() ?? DisplayFont.of(AppFontStyle.pixel);

  @override
  DisplayFont copyWith({String? family, double? scale, FontWeight? weight}) => DisplayFont(
        family: family ?? this.family,
        scale: scale ?? this.scale,
        weight: weight ?? this.weight,
      );

  @override
  DisplayFont lerp(ThemeExtension<DisplayFont>? other, double t) =>
      t < 0.5 ? this : (other as DisplayFont? ?? this);
}
