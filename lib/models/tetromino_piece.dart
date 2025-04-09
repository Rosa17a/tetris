import 'dart:ui';

enum TetrominoPiece {
  I, // I-shaped piece (cyan)
  O, // O-shaped piece (yellow)
  T, // T-shaped piece (purple)
  S, // S-shaped piece (green)
  Z, // Z-shaped piece (red)
  J, // J-shaped piece (blue)
  L, // L-shaped piece (orange)
}

enum BlockVisualStyle {
  classicDot, // NES-style with top-left white dot
  angledHighlight, // angled triangular highlight (e.g. cyan block)
  solid, // no dot or highlight, just solid fill
}

extension TetrominoStyleExtension on TetrominoPiece {
  BlockVisualStyle getVisualStyle() {
    switch (this) {
      case TetrominoPiece.I:
        return BlockVisualStyle.classicDot;
      case TetrominoPiece.O:
        return BlockVisualStyle.solid;
      case TetrominoPiece.T:
        return BlockVisualStyle.classicDot;
      case TetrominoPiece.S:
        return BlockVisualStyle.angledHighlight;
      case TetrominoPiece.Z:
        return BlockVisualStyle.angledHighlight;
      case TetrominoPiece.J:
        return BlockVisualStyle.angledHighlight;
      case TetrominoPiece.L:
        return BlockVisualStyle.angledHighlight;
    }
  }
}

class TetrominoColorTheme {
  final Color border;
  final Color fill;

  const TetrominoColorTheme({
    required this.border,
    required this.fill,
  });
}

// Example: level-based color themes (expand as needed)
const Map<TetrominoPiece, List<TetrominoColorTheme>> tetrominoThemes = {
  TetrominoPiece.I: [
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF00A800),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFFDB00CD),
      fill: Color(0xFFFFFFFF),
    ),
     TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
       TetrominoColorTheme(
      border: Color(0xFFE7005B),
      fill: Color(0xFFFFFFFF),
    ),
  ],
  TetrominoPiece.O: [
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF00A800),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFFDB00CD),
      fill: Color(0xFFFFFFFF),
    ),
     TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
       TetrominoColorTheme(
      border: Color(0xFFE7005B),
      fill: Color(0xFFFFFFFF),
    ),
  ],
  TetrominoPiece.T: [
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF00A800),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFFDB00CD),
      fill: Color(0xFFFFFFFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFFFFFFFF),
    ),
       TetrominoColorTheme(
      border: Color(0xFFE7005B),
      fill: Color(0xFFFFFFFF),
    ),
  ],
  TetrominoPiece.S: [
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFF0057F6),
    ),
    TetrominoColorTheme(
      border: Color(0xFF00A800),
      fill: Color(0xFF00A800),
    ),
    TetrominoColorTheme(
      border: Color(0xFFDB00CD),
      fill: Color(0xFFDB00CD),
    ),
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFF0057F6),
    ),
     TetrominoColorTheme(
      border: Color(0xFFE7005B),
      fill: Color(0xFFE7005B),
    ),
  ],
  TetrominoPiece.Z: [
    TetrominoColorTheme(
      border: Color(0xFF3EBEFF),
      fill: Color(0xFF3EBEFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF80D010),
      fill: Color(0xFF80D010),
    ),
    TetrominoColorTheme(
      border: Color(0xFFF878F8),
      fill: Color(0xFFF878F8),
    ),
    TetrominoColorTheme(
      border: Color(0xFF5BDB57),
      fill: Color(0xFF5BDB57),
    ),
      TetrominoColorTheme(
      border: Color(0xFF58F898),
      fill: Color(0xFF58F898),
    ),
  ],
  TetrominoPiece.J: [
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFF0057F6),
    ),
    TetrominoColorTheme(
      border: Color(0xFF00A800),
      fill: Color(0xFF00A800),
    ),
    TetrominoColorTheme(
      border: Color(0xFFDB00CD),
      fill: Color(0xFFDB00CD),
    ),
    TetrominoColorTheme(
      border: Color(0xFF0057F6),
      fill: Color(0xFF0057F6),
    ),
     TetrominoColorTheme(
      border: Color(0xFFE7005B),
      fill: Color(0xFFE7005B),
    ),
  ],
  TetrominoPiece.L: [
    TetrominoColorTheme(
      border: Color(0xFF3EBEFF),
      fill: Color(0xFF3EBEFF),
    ),
    TetrominoColorTheme(
      border: Color(0xFF80D010),
      fill: Color(0xFF80D010),
    ),
    TetrominoColorTheme(
      border: Color(0xFFF878F8),
      fill: Color(0xFFF878F8),
    ),
    TetrominoColorTheme(
      border: Color(0xFF5BDB57),
      fill: Color(0xFF5BDB57),
    ),
      TetrominoColorTheme(
      border: Color(0xFF58F898),
      fill: Color(0xFF58F898),
    ),
  ],
};

extension TetrominoPieceExtension on TetrominoPiece {
  TetrominoColorTheme getTheme(int level) {
    final themes = tetrominoThemes[this]!;
    return themes[(level - 1) % themes.length];
  }
}
