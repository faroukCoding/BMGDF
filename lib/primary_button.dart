import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppConstant.BUTTON_GRADIENT,
        borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: AppConstant.PADDING_MEDIUM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.cairo(
            color: AppConstant.TEXT_PRIMARY,
            fontSize: AppConstant.FONT_SUBTITLE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}