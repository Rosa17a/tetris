import 'package:tetris_nes/models/tetromino_color_theme_provider.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/models/tetromino_color_theme.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  late final TetrominoColorThemeProvider themeProvider;

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal();

  Future<void> initialize() async {
    themeProvider = await TetrominoColorThemeProvider.create();
  }

  // Helper method to get the current theme for a piece at a specific level
  TetrominoColorTheme getThemeForPiece(TetrominoPiece piece, int level) {
    return themeProvider.getTheme(piece, level);
  }

  // Helper method to get the visual style for a piece
  BlockVisualStyle getVisualStyleForPiece(TetrominoPiece piece) {
    return themeProvider.getVisualStyle(piece);
  }
}
