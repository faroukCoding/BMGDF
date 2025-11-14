import 'package:flutter/material.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اللوغو الكبير
            _buildLogo(),
            SizedBox(height: 30),
            // مؤشر التحميل
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00ADB5)),
            ),
            SizedBox(height: 20),
            // نص التحميل
            Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // صورة اللوغو
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.3)),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.shopping_cart,
                  size: 50,
                  color: Color(0xFF00ADB5),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        // اسم التطبيق
        Text(
          'BMG Corp',
          style: TextStyle(
            color: Color(0xFF00ADB5),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 10),
        // وصف التطبيق
        Text(
          'نظام إدارة التسويق بالعمولة',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}