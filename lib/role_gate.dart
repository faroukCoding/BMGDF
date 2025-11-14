import 'package:flutter/material.dart';
import 'supabase_service.dart';
import 'admin_dashboard_screen.dart';
import 'driver_dashboard_screen.dart';
import 'auth_screen.dart';
import 'main_layout.dart';

class RoleGate extends StatefulWidget {
  const RoleGate({super.key});

  @override
  State<RoleGate> createState() => _RoleGateState();
}

class _RoleGateState extends State<RoleGate> {
  Future<Map<String, dynamic>?>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = SupabaseService.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          // If profile fetch fails, sign out and go to auth screen
          SupabaseService.signOut();
          return const AuthScreen();
        }

        final userProfile = snapshot.data!;
        final role = userProfile['role'] as String?;

        switch (role) {
          case 'admin':
            return const AdminDashboardScreen();
          case 'affiliate':
            return MainLayout(userProfile: userProfile);
          case 'driver':
            return const DriverDashboardScreen();
          // Add other roles like 'call_center', 'assistant_admin' here
          default:
            // Fallback to affiliate dashboard or an error screen
            return MainLayout(userProfile: userProfile);
        }
      },
    );
  }
}