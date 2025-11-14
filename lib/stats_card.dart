import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'glassmorphic_container.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isFullWidth;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.PADDING_SMALL),
        child: isFullWidth ? _buildFullWidthLayout() : _buildHalfWidthLayout(),
      ),
    );
  }

  Widget _buildHalfWidthLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: AppConstant.PADDING_SMALL),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: AppConstant.TEXT_SECONDARY, fontSize: AppConstant.FONT_BODY),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
              color: AppConstant.TEXT_PRIMARY,
              fontSize: AppConstant.FONT_TITLE,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

   Widget _buildFullWidthLayout() {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: AppConstant.PADDING_MEDIUM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY, fontSize: AppConstant.FONT_BODY)),
            Text(value, style: GoogleFonts.cairo(color: AppConstant.TEXT_PRIMARY, fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}