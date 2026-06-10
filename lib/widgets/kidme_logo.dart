import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KidmeLogo extends StatelessWidget {
  const KidmeLogo({
    super.key,
    this.iconSize = 34,
    this.textSize = 22,
    this.showWordmark = true,
    this.light = false,
  });

  final double iconSize;
  final double textSize;
  final bool showWordmark;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KidmeMark(size: iconSize),
        if (showWordmark) ...[
          SizedBox(width: iconSize * 0.28),
          Text(
            'kidm\u00e9',
            style: TextStyle(
              color: light ? Colors.white : AppColors.primaryNavy,
              fontSize: textSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ],
    );
  }
}

class _KidmeMark extends StatelessWidget {
  const _KidmeMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size * 0.09),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withAlpha(30),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.14),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.midnightNavy,
                  AppColors.elegantNavy,
                  AppColors.deepGreen,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size * 0.22),
            ),
            child: CustomPaint(painter: _BriefcaseSearchPainter()),
          ),
          Positioned(
            right: size * 0.02,
            top: size * 0.03,
            child: Icon(Icons.search_rounded, color: Colors.white, size: size * 0.40),
          ),
          Positioned(
            right: -size * 0.06,
            bottom: -size * 0.06,
            child: Container(
              height: size * 0.26,
              width: size * 0.26,
              decoration: BoxDecoration(
                color: AppColors.emerald,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: size * 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefcaseSearchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.22,
        size.height * 0.42,
        size.width * 0.56,
        size.height * 0.34,
      ),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(body, paint);

    canvas.drawArc(
      Rect.fromLTWH(
        size.width * 0.38,
        size.height * 0.28,
        size.width * 0.24,
        size.height * 0.24,
      ),
      3.14,
      3.14,
      false,
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.24, size.height * 0.56),
      Offset(size.width * 0.76, size.height * 0.56),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
