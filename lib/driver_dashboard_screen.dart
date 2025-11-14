import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'glassmorphic_container.dart';
import 'supabase_service.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Your Deliveries', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => SupabaseService.signOut(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        itemCount: 3, // Dummy count
        itemBuilder: (context, index) {
          return _buildDeliveryCard(
            context: context,
            customerName: 'Ahmed Ali',
            address: '123 Flutter St, Dart City',
            productName: 'Gaming Laptop',
          );
        },
      ),
    );
  }

  Widget _buildDeliveryCard({
    required BuildContext context,
    required String customerName,
    required String address,
    required String productName,
  }) {
    return GlassmorphicContainer(
      margin: const EdgeInsets.only(bottom: AppConstant.PADDING_MEDIUM),
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_pin_circle_outlined, color: AppConstant.PRIMARY_COLOR),
                const SizedBox(width: AppConstant.PADDING_SMALL),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customerName, style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.bold)),
                      Text(address, style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY)),
                    ],
                  ),
                ),
                 const Icon(Icons.map_outlined, color: AppConstant.ACCENT_COLOR),
              ],
            ),
            const Divider(height: 30),
            Text(productName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppConstant.PADDING_MEDIUM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.route_outlined),
                  label: const Text('On Route'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppConstant.PRIMARY_COLOR),
                ),
                 ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check),
                  label: const Text('Delivered'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}