import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF00ADB5);
  static const primaryDark = Color(0xFF00848B);
  static const primaryLight = Color(0xFF33BDC3);
  
  static const secondary = Color(0xFF6C7B7F);
  static const background = Color(0xFF1A1A2E);
  static const cardBackground = Color(0xFF16213E);
  static const surface = Color(0xFF0F3460);
  
  static const success = Color(0xFF27AE60);
  static const successLight = Color(0xFF58D68D);
  static const warning = Color(0xFFF1C40F);
  static const warningLight = Color(0xFFF7DC6F);
  static const error = Color(0xFFE74C3C);
  static const errorLight = Color(0xFFF1948A);
  static const info = Color(0xFF3498DB);
  static const infoLight = Color(0xFF85C1E9);
  
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0BEC5);
  static const textDisabled = Color(0xFF78909C);
  
  static const divider = Color(0xFF37474F);
  static const shadow = Color(0x26000000);
}

class AppStrings {
  static const appName = 'BMG Corp';
  static const welcomeMessage = 'مرحباً بك في نظام إدارة التسويق بالعمولة والتوصيل';
  static const companyName = 'شركة BMG للتسويق';
  
  // Auth
  static const login = 'تسجيل الدخول';
  static const register = 'إنشاء حساب';
  static const email = 'البريد الإلكتروني';
  static const password = 'كلمة المرور';
  static const fullName = 'الاسم الكامل';
  static const phone = 'رقم الهاتف';
  static const role = 'الدور';
  
  // Roles
  static const affiliate = 'مسوّق';
  static const admin = 'مدير';
  static const assistantAdmin = 'مساعد إداري';
  static const callCenter = 'مؤكد الطلبات';
  static const driver = 'سائق';
  
  // Status
  static const pending = 'معلق';
  static const confirmed = 'مؤكد';
  static const rejected = 'مرفوض';
  static const delivered = 'تم التسليم';
  static const inDelivery = 'قيد التوصيل';
  static const failed = 'فشل التسليم';
  
  // Common
  static const save = 'حفظ';
  static const cancel = 'إلغاء';
  static const delete = 'حذف';
  static const edit = 'تعديل';
  static const view = 'عرض';
  static const add = 'إضافة';
  static const search = 'بحث';
  static const filter = 'تصفية';
}

class AppRoles {
  static const affiliate = 'affiliate';
  static const admin = 'admin';
  static const assistantAdmin = 'assistant_admin';
  static const callCenter = 'call_center';
  static const driver = 'driver';
  
  static String getRoleDisplayName(String role) {
    switch (role) {
      case affiliate: return AppStrings.affiliate;
      case admin: return AppStrings.admin;
      case assistantAdmin: return AppStrings.assistantAdmin;
      case callCenter: return AppStrings.callCenter;
      case driver: return AppStrings.driver;
      default: return 'غير معروف';
    }
  }
  
  static List<Map<String, String>> getRolesList() {
    return [
      {'value': affiliate, 'label': AppStrings.affiliate},
      {'value': admin, 'label': AppStrings.admin},
      {'value': assistantAdmin, 'label': AppStrings.assistantAdmin},
      {'value': callCenter, 'label': AppStrings.callCenter},
      {'value': driver, 'label': AppStrings.driver},
    ];
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      // Colors
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.primaryDark,
      primaryColorLight: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.background,
      backgroundColor: AppColors.background,
      cardColor: AppColors.cardBackground,
      dialogBackgroundColor: AppColors.cardBackground,
      
      // Font
      fontFamily: 'Cairo',
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18,
         