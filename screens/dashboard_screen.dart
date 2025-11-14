import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'affiliate_dashboard.dart';
import 'admin_dashboard.dart';
import 'assistant_admin_dashboard.dart';
import 'call_center_dashboard.dart';
import 'driver_dashboard.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // أيقونة اللوغو الصغيرة
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xFF00ADB5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.3)),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.shopping_cart_rounded,
                      size: 16,
                      color: Color(0xFF00ADB5),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'BMG Corp',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1A1A2E),
        actions: [
          // معلومات المستخدم
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(Icons.person, size: 18, color: Colors.white70),
                SizedBox(width: 6),
                Text(
                  user?.name.split(' ').first ?? 'مستخدم',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Provider.of<AppState>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/');
              } else if (value == 'settings') {
                _showSettings(context);
              }
            },
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: Color(0xFF1A1A2E),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF00ADB5), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'الإعدادات',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _getDashboardByRole(user!.role),
    );
  }

  Widget _getDashboardByRole(String role) {
    switch (role) {
      case 'affiliate':
        return AffiliateDashboard();
      case 'admin':
        return AdminDashboard();
      case 'assistant_admin':
        return AssistantAdminDashboard();
      case 'call_center':
        return CallCenterDashboard();
      case 'driver':
        return DriverDashboard();
      default:
        return Center(
          child: Text(
            'لوحة غير معروفة',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
            ),
          ),
        );
    }
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.support, color: Color(0xFF00ADB5)),
              title: Text(
                'الدعم الفني',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              subtitle: Text(
                '+966501234567',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                // اتصل بالدعم
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Color(0xFF00ADB5)),
              title: Text(
                'اللغة',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
              subtitle: Text(
                'العربية',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                ),
              ),
              onTap: () {
                // تغيير اللغة
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(
                color: Color(0xFF00ADB5),
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}