import 'package:flutter/material.dart';
import 'package:tetris_nes/models/tetromino_piece.dart';
import 'package:tetris_nes/services/theme_service.dart';


class PieceShading extends StatefulWidget {
  final TetrominoPiece piece;
  final int level;
  final double size;
  final bool isFlashing;
  final Duration flashDelay;

  const PieceShading({
    super.key,
    required this.piece,
    required this.level,
    this.size = 10,
    this.isFlashing = false,
    this.flashDelay = Duration.zero,
  });

  @override
  State<PieceShading> createState() => _PieceShadingState();
}

class _PieceShadingState extends State<PieceShading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  bool _started = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Start animation after delay (staggered ripple)
    if (widget.isFlashing) {
      Future.delayed(widget.flashDelay, () {
        if (!mounted) return;
        setState(() => _started = true);
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      return _buildNormalBlock();
    }

    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.size,
        height: widget.size,
        color: Colors.white,
      ),
    );
  }

  Widget _buildNormalBlock() {
    final theme = ThemeService().getThemeForPiece(widget.piece, widget.level);
    final style = widget.piece.getVisualStyle();
    final borderSize = widget.size * 0.15;
    final highlightDotSize = widget.size * 0.15;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(borderSize / 4),
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: widget.size - borderSize,
            height: widget.size - borderSize,
            decoration: BoxDecoration(
              color: theme.fill,
              border: Border.all(color: theme.border, width: borderSize),
            ),
          ),
          if (style == BlockVisualStyle.angledHighlight)
            Positioned(
              top: highlightDotSize,
              left: highlightDotSize,
              child: ClipPath(
                clipper: _TopLeftTriangleClipper(),
                child: Container(
                  width: highlightDotSize * 2,
                  height: highlightDotSize * 2,
                  color: Colors.white,
                ),
              ),
            ),
          if (style == BlockVisualStyle.classicDot ||
              style == BlockVisualStyle.angledHighlight)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: highlightDotSize,
                height: highlightDotSize,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class _TopLeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
