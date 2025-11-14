import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'affiliate_dashboard_screen.dart';
import 'new_order_screen.dart';
import 'orders_screen.dart';
import 'payouts_screen.dart';
import 'settings_screen.dart';
import 'supabase_service.dart';

class MainLayout extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  const MainLayout({super.key, required this.userProfile});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const AffiliateDashboardScreen(),
    const OrdersScreen(),
    const PayoutsScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'BMG Connect',
    'My Orders',
    'My Payouts',
    'Settings',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.userProfile['name'] as String?;
    final initial = (name != null && name.isNotEmpty)
        ? name[0]
        : (SupabaseService.currentUser?.email?.isNotEmpty == true
            ? SupabaseService.currentUser!.email![0]
            : 'U');

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppConstant.BACKGROUND_COLOR.withOpacity(0.5),
        elevation: 0,
        title: Text(_titles[_currentIndex], style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppConstant.PRIMARY_COLOR,
            child: Text(
              initial.toUpperCase(),
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => SupabaseService.signOut(),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewOrderScreen()),
          );
        },
        backgroundColor: AppConstant.ACCENT_COLOR,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: AppConstant.SURFACE_COLOR.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_outlined, "Dashboard", 0),
          _buildNavItem(Icons.receipt_long_outlined, "Orders", 1),
          const SizedBox(width: 40), // Spacer for FAB
          _buildNavItem(Icons.payment_outlined, "Payouts", 2),
          _buildNavItem(Icons.settings_outlined, "Settings", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? AppConstant.PRIMARY_COLOR : AppConstant.TEXT_SECONDARY),
      onPressed: () => _onNavItemTapped(index),
      tooltip: label,
    );
  }
}