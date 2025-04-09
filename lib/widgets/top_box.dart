import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBox extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final bool isButton;
  final VoidCallback? onTap;

  const TopBox({
    super.key,
    required this.text,
    required this.height,
    required this.width,
    this.isButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
          horizontal: height * 0.12, vertical: height * 0.08),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF00FF9F),
          width: 2,
        ),
      ),
      child: isButton
          ? GestureDetector(
              onTapDown: (_) => onTap?.call(),
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.pressStart2p(
                    fontSize: height * 0.3,
                    color: const Color(0xFF00FF9F),
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
                          fontSize: height * 0.2,
                          color: const Color(0xFF00FF9F),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
