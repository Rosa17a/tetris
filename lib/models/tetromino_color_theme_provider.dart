import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tetris_nes/models/tetromino_color_theme.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/colors.dart';

class TetrominoColorThemeProvider {
  late final Map<TetrominoPiece, List<TetrominoColorTheme>> tetrominoThemes;
  late final Map<TetrominoPiece, BlockVisualStyle> visualStyles;
  late final Map<String, Color> colorMap;

  TetrominoColorThemeProvider._(
      this.tetrominoThemes, this.visualStyles, this.colorMap);

  static Future<TetrominoColorThemeProvider> create() async {
    final colorThemesJson =
        await rootBundle.loadString('assets/tetromino_color_themes.json');
    final visualStylesJson =
        await rootBundle.loadString('assets/tetromino_visual_styles.json');
    final colorMapJson = await rootBundle.loadString('assets/color_map.json');

    final colorMap = parseColorMapFromJson(colorMapJson);
    final themes = parseTetrominoThemesFromAliasJson(colorThemesJson, colorMap);
    final styles = parseVisualStylesFromJson(visualStylesJson);

    return TetrominoColorThemeProvider._(themes, styles, colorMap);
  }

  TetrominoColorTheme getTheme(TetrominoPiece piece, int level) {
    final themes = tetrominoThemes[piece] ?? [];
    if (themes.isEmpty) {
      // Return a default theme if none found
      return const TetrominoColorTheme(
        border: AppColors.white,
        fill: AppColors.white,
        level: 0,
      );
    }
    return themes[level % themes.length];
  }

  BlockVisualStyle getVisualStyle(TetrominoPiece piece) {
    return visualStyles[piece] ?? BlockVisualStyle.solid;
  }

  static Map<String, Color> parseColorMapFromJson(String jsonStr) {
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    final Map<String, Color> colorMap = {};

    for (final entry in jsonMap.entries) {
      final colorName = entry.key;
      final colorHex = entry.value as String;
      colorMap[colorName] = Color(int.parse(colorHex));
    }

    return colorMap;
  }

  static Map<TetrominoPiece, BlockVisualStyle> parseVisualStylesFromJson(
      String jsonStr) {
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    final Map<TetrominoPiece, BlockVisualStyle> styles = {};

    for (final entry in jsonMap.entries) {
      final pieceName = entry.key;
      final styleName = entry.value as String;

      final piece = TetrominoPiece.values.firstWhere(
        (e) => e.toString().split('.').last == pieceName,
        orElse: () => TetrominoPiece.I,
      );

      final style = BlockVisualStyle.values.firstWhere(
        (e) => e.toString().split('.').last == styleName,
        orElse: () => BlockVisualStyle.solid,
      );

      styles[piece] = style;
    }

    return styles;
  }

  static Map<TetrominoPiece, List<TetrominoColorTheme>>
      parseTetrominoThemesFromAliasJson(
    String jsonStr,
    Map<String, Color> colorMap,
  ) {
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    final Map<TetrominoPiece, List<TetrominoColorTheme>> themes = {};

    for (final entry in jsonMap.entries) {
      final pieceName = entry.key;
      final piece = TetrominoPiece.values.firstWhere(
        (e) => e.toString().split('.').last == pieceName,
        orElse: () => TetrominoPiece.I,
      );

      final colorThemes = (entry.value as List<dynamic>).map((theme) {
        return TetrominoColorTheme(
          border: colorMap[theme['border']]!,
          fill: colorMap[theme['fill']]!,
          level: theme['level'],
        );
      }).toList();

      themes[piece] = colorThemes;
    }

    return themes;
  }
}
