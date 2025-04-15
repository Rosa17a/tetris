
enum TetrominoPiece {
  I, // I-shaped piece
  O, // O-shaped piece
  T, // T-shaped piece
  S, // S-shaped piece
  Z, // Z-shaped piece
  J, // J-shaped piece
  L, // L-shaped piece
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