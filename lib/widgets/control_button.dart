import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final String symbol;
  final String action;
  final double size;
  final bool isEnabled;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapCancel;

  const ControlButton({
    super.key,
    required this.symbol,
    required this.action,
    required this.size,
    required this.isEnabled,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: isEnabled ? (_) => onTapDown?.call() : null,
      onTapUp: isEnabled ? (_) => onTapUp?.call() : null,
      onTapCancel: isEnabled ? onTapCancel : null,
      child: Container(
        width: size,
        height: size,
        color: Colors.black, // Outer black layer
        padding: const EdgeInsets.all(3),
        child: Container(
          color: const Color(0xFF2D2D2D), // Middle gray layer
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: const Color(0xFF88F8FF), // Inner cyan NES border
                width: 2,
              ),
            ),
            child: Center(
              child: CustomPaint(
                size: Size(size * 0.6, size * 0.6),
                painter: _SymbolPainter(symbol: symbol),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SymbolPainter extends CustomPainter {
  final String symbol;

  _SymbolPainter({required this.symbol});

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: const Color(0xFF88F8FF), // NES cyan symbol
      fontSize: size.height * 0.8,
      fontFamily: 'PressStart2P', // Optional: match game font
    );

    final textSpan = TextSpan(text: symbol, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_SymbolPainter oldDelegate) =>
      symbol != oldDelegate.symbol;
}