import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'home_page.dart';
import 'primary_button.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstant.HERO_GRADIENT,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstant.PADDING_XL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Text(
                  'BMG',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.TEXT_PRIMARY,
                  ),
                ),
                Text(
                  'CONNECT',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: AppConstant.TEXT_PRIMARY.withOpacity(0.8),
                  ),
                ),
                const Spacer(flex: 3),
                Text(
                  'Welcome to BMG Connect!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: AppConstant.FONT_HEADLINE,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.TEXT_PRIMARY,
                  ),
                ),
                const SizedBox(height: AppConstant.PADDING_MEDIUM),
                Text(
                  'Select Your Language',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: AppConstant.FONT_SUBTITLE,
                    color: AppConstant.TEXT_SECONDARY,
                  ),
                ),
                const SizedBox(height: AppConstant.PADDING_LARGE),
                PrimaryButton(
                  text: 'English',
                  onPressed: () => _navigateToHome(context),
                ),
                const SizedBox(height: AppConstant.PADDING_MEDIUM),
                PrimaryButton(
                  text: 'العربية',
                  onPressed: () => _navigateToHome(context),
                  gradient: LinearGradient(
                    colors: [
                      AppConstant.SURFACE_COLOR,
                      AppConstant.SURFACE_COLOR.withOpacity(0.8)
                    ],
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}