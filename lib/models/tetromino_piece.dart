import 'package:flutter/material.dart';

// Add piece type enum at top level
enum TetrominoPiece {
  I, // I-shaped piece (cyan)
  O, // O-shaped piece (yellow)
  T, // T-shaped piece (purple)
  S, // S-shaped piece (green)
  Z, // Z-shaped piece (red)
  J, // J-shaped piece (blue)
  L, // L-shaped piece (orange)
}

extension TetrominoPieceShading on TetrominoPiece {
  List<Color> getShadingColors() {
    switch (this) {
      case TetrominoPiece.I:
        return [Colors.white, const Color(0xFF008888)];
      case TetrominoPiece.O:
        return [Colors.white, const Color(0xFF888800)];
      case TetrominoPiece.T:
        return [Colors.white, const Color(0xFF600088)];
      case TetrominoPiece.S:
        return [Colors.white, const Color(0xFF008800)];
      case TetrominoPiece.Z:
        return [Colors.white, const Color(0xFF880000)];
      case TetrominoPiece.J:
        return [Colors.white, const Color(0xFF000088)];
      case TetrominoPiece.L:
        return [Colors.white, const Color(0xFF884400)];
    }
  }
}

extension TetrominoPieceColors on TetrominoPiece {
  static final List<Map<TetrominoPiece, Color>> levelPalettes = [
    // Level 0-1 (Standard colors)
    {
      TetrominoPiece.I: const Color(0xFF00F0F0),
      TetrominoPiece.O: const Color(0xFFF0F000),
      TetrominoPiece.T: const Color(0xFFA000F0),
      TetrominoPiece.S: const Color(0xFF00F000),
      TetrominoPiece.Z: const Color(0xFFFF0000),
      TetrominoPiece.J: const Color(0xFF0000F0),
      TetrominoPiece.L: const Color(0xFFF0A000),
    },
    // Level 2-3
    {
      TetrominoPiece.I: const Color(0xFF50F0F0),
      TetrominoPiece.O: const Color(0xFFF0F050),
      TetrominoPiece.T: const Color(0xFFD050F0),
      TetrominoPiece.S: const Color(0xFF50F050),
      TetrominoPiece.Z: const Color(0xFFF05050),
      TetrominoPiece.J: const Color(0xFF5050F0),
      TetrominoPiece.L: const Color(0xFFF0D050),
    },
    // Level 4-5
    {
      TetrominoPiece.I: const Color(0xFF00A0A0),
      TetrominoPiece.O: const Color(0xFFA0A000),
      TetrominoPiece.T: const Color(0xFF8000A0),
      TetrominoPiece.S: const Color(0xFF00A000),
      TetrominoPiece.Z: const Color(0xFFA00000),
      TetrominoPiece.J: const Color(0xFF0000A0),
      TetrominoPiece.L: const Color(0xFFA08000),
    },
    // Level 6-7
    {
      TetrominoPiece.I: const Color(0xFF80FFFF),
      TetrominoPiece.O: const Color(0xFFFFFF80),
      TetrominoPiece.T: const Color(0xFFFF80FF),
      TetrominoPiece.S: const Color(0xFF80FF80),
      TetrominoPiece.Z: const Color(0xFFFF8080),
      TetrominoPiece.J: const Color(0xFF8080FF),
      TetrominoPiece.L: const Color(0xFFFFB080),
    },
    // Level 8-9
    {
      TetrominoPiece.I: const Color(0xFF008080),
      TetrominoPiece.O: const Color(0xFF808000),
      TetrominoPiece.T: const Color(0xFF600080),
      TetrominoPiece.S: const Color(0xFF008000),
      TetrominoPiece.Z: const Color(0xFF800000),
      TetrominoPiece.J: const Color(0xFF000080),
      TetrominoPiece.L: const Color(0xFF806000),
    },
  ];

  Color getColor(int level) {
    final paletteIndex = (level ~/ 2) % levelPalettes.length;
    return levelPalettes[paletteIndex][this] ?? levelPalettes[0][this]!;
  }
}
