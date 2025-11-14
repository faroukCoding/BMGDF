import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app_constant.dart';
import 'language_selection_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstant.SUPABASE_URL,
    anonKey: AppConstant.SUPABASE_ANON_KEY,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: AppConstant.APP_NAME,
      theme: ThemeData(
        primaryColor: AppConstant.PRIMARY_COLOR,
        scaffoldBackgroundColor: AppConstant.BACKGROUND_COLOR,
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstant.PRIMARY_COLOR,
          brightness: Brightness.dark,
          background: AppConstant.BACKGROUND_COLOR,
          surface: AppConstant.SURFACE_COLOR,
        ),
      ),
      home: const LanguageSelectionScreen(),
    );
  }
}