import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBox extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final bool isButton;
  final VoidCallback? onTap;

  const TopBox({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    this.fontSize =12,
    this.isButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = isButton
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => onTap?.call(),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.pressStart2p(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text
                .split('\n')
                .map((line) => Text(
                      line,
                      style: GoogleFonts.pressStart2p(
                        fontSize: fontSize,
                        color: Colors.white,
                      ),
                    ))
                .toList(),
          );

    return Container(
      height: height,
      width: width,
      color: Colors.black,
      padding: const EdgeInsets.all(4),
      child: Container(
        color: const Color(0xFF2D2D2D),
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: const Color(0xFF88F8FF), // NES cyan
              width: 2,
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
