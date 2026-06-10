import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class KidmeButton extends StatefulWidget {
  const KidmeButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryNavy,
    this.foregroundColor = Colors.white,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  State<KidmeButton> createState() => _KidmeButtonState();
}

class _KidmeButtonState extends State<KidmeButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      scale: _pressed ? 0.98 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.backgroundColor.withAlpha(42),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Listener(
          onPointerDown: (_) => setState(() => _pressed = true),
          onPointerUp: (_) => setState(() => _pressed = false),
          onPointerCancel: (_) => setState(() => _pressed = false),
          child: ElevatedButton.icon(
            onPressed: widget.onPressed,
            icon: Icon(widget.icon),
            label: Text(widget.label),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
