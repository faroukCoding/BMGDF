import 'package:flutter/material.dart';

class AppConstant {
  // ═══════════════════════════════════════════════════════════
  // 🎨 APP CONFIGURATION
  // ═══════════════════════════════════════════════════════════
  static const String APP_NAME = 'BMG Connect';
  static const Color PRIMARY_COLOR = Color(0xFF00ADB5);
  static const Color SECONDARY_COLOR = Color(0xFFF2F2F2);
  static const Color ACCENT_COLOR = Color(0xFFFF6B35);
  static const Color BACKGROUND_COLOR = Color(0xFF1A1A2E);
  static const Color SURFACE_COLOR = Color(0xFF2C2C44);
  static const Color ERROR_COLOR = Color(0xFFEF4444);
  static const Color TEXT_PRIMARY = Color(0xFFF2F2F2);
  static const Color TEXT_SECONDARY = Color(0xFFAAAAAA);

  static const LinearGradient HERO_GRADIENT = LinearGradient(
    colors: [PRIMARY_COLOR, BACKGROUND_COLOR],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient BUTTON_GRADIENT = LinearGradient(
    colors: [PRIMARY_COLOR, ACCENT_COLOR],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ═══════════════════════════════════════════════════════════
  // 🤖 GEMINI AI CONFIGURATION
  // ═══════════════════════════════════════════════════════════
  static const String GEMINI_API_KEY = 'YOUR_GEMINI_API_KEY_HERE';
  static const String GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/';
  static const String TEXT_MODEL = 'gemini-1.5-flash-latest';
  static const double TEMPERATURE = 0.5;
  static const int MAX_TOKENS = 2048;
  static const double TOP_P = 0.95;
  static const int TOP_K = 40;

  static const String ADMIN_INSIGHTS_PROMPT = '''
You are a data analyst AI for 'BMG Connect', an affiliate marketing platform.
Analyze the provided data and generate concise, actionable insights for the Admin.
Focus on:
1.  **Predictive Order Volume**: Forecast the next week's order volume based on historical data.
2.  **Best-Performing Affiliates**: Identify the top 3 affiliates by confirmed commissions.
3.  **Potential Issues**: Flag any unusual patterns, like a sudden drop in an affiliate's activity or a high rejection rate for a specific product.

Provide your output in a clean, easy-to-read format. Use bullet points.
''';

  // ═══════════════════════════════════════════════════════════
  // 🗄️ SUPABASE CONFIGURATION
  // ═══════════════════════════════════════════════════════════
  static const String SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
  static const String SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

  // ═══════════════════════════════════════════════════════════
  // 🎨 UI CONSTANTS
  // ═══════════════════════════════════════════════════════════
  static const double PADDING_SMALL = 8.0;
  static const double PADDING_MEDIUM = 16.0;
  static const double PADDING_LARGE = 24.0;
  static const double PADDING_XL = 32.0;

  static const double BORDER_RADIUS_MEDIUM = 8.0;
  static const double BORDER_RADIUS_LARGE = 16.0;
  static const double BORDER_RADIUS_XL = 24.0;

  static const double ELEVATION = 4.0;

  // Font Sizes
  static const double FONT_CAPTION = 12.0;
  static const double FONT_BODY = 14.0;
  static const double FONT_SUBTITLE = 16.0;
  static const double FONT_TITLE = 20.0;
  static const double FONT_HEADLINE = 24.0;
  static const double FONT_DISPLAY = 32.0;
}