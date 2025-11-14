import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings_outlined, size: 80, color: AppConstant.TEXT_SECONDARY),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          Text(
            'Settings Screen',
            style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, color: AppConstant.TEXT_PRIMARY),
          ),
          Text(
            'Coming Soon!',
            style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY),
          ),
        ],
      ),
    );
  }
}