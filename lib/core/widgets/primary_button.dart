import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.isLoading,
    required this.label,
    required this.onPressed,
    this.color,
    this.height,
    this.width,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 54,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: isLoading
              ? (color ?? theme.primaryColor).withValues(alpha: 0.6)
              : color ?? theme.primaryColor,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style:
                    textStyle ??
                    const TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }
}
