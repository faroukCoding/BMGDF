import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'glassmorphic_container.dart';
import 'stats_card.dart';

class AffiliateDashboardScreen extends StatelessWidget {
  const AffiliateDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kToolbarHeight + 20),
          Text(
            "Your Dashboard",
            style: GoogleFonts.cairo(
                fontSize: AppConstant.FONT_HEADLINE, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          const Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Total Commissions',
                  value: '€1,250.00',
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppConstant.PRIMARY_COLOR,
                ),
              ),
              SizedBox(width: AppConstant.PADDING_SMALL),
              Expanded(
                child: StatsCard(
                  title: 'Confirmed',
                  value: '€800.00',
                  icon: Icons.check_circle_outlined,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstant.PADDING_SMALL),
          const StatsCard(
            title: 'Pending Commissions',
            value: '€450.00',
            icon: Icons.hourglass_top_outlined,
            color: AppConstant.ACCENT_COLOR,
            isFullWidth: true,
          ),
          const SizedBox(height: AppConstant.PADDING_LARGE),
          Text("Recent Orders",
              style: GoogleFonts.cairo(
                  fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          _buildRecentOrderCard("Order #54321", "iPhone 15 Pro", "Confirmed"),
          _buildRecentOrderCard("Order #54320", "Samsung S24 Ultra", "Pending Review"),
          _buildRecentOrderCard("Order #54319", "Macbook Air M3", "Delivered"),
        ],
      ),
    );
  }

  Widget _buildRecentOrderCard(String orderId, String product, String status) {
    Color statusColor;
    switch (status) {
      case "Confirmed":
        statusColor = Colors.green;
        break;
      case "Pending Review":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = AppConstant.TEXT_SECONDARY;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstant.PADDING_SMALL),
      child: GlassmorphicContainer(
        child: ListTile(
          title: Text(product, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          subtitle: Text(orderId, style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: GoogleFonts.poppins(color: statusColor, fontSize: 12)),
          ),
        ),
      ),
    );
  }
}