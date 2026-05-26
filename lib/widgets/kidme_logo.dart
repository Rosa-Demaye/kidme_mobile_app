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
                colors: [AppColors.midnightNavy, AppColors.deepBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(size * 0.22),
            ),
            child: Center(
              child: Text(
                'k',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.50,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
              ),
            ),
          ),
          Positioned(
            right: size * 0.08,
            top: size * 0.10,
            child: Icon(
              Icons.search_rounded,
              color: AppColors.goldAccent,
              size: size * 0.42,
            ),
          ),
          Positioned(
            right: -size * 0.06,
            bottom: -size * 0.06,
            child: Container(
              height: size * 0.26,
              width: size * 0.26,
              decoration: BoxDecoration(
                color: AppColors.goldAccent,
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
