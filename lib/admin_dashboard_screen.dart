import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_constant.dart';
import 'supabase_service.dart';
import 'glassmorphic_container.dart';
import 'stats_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Admin Dashboard', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => SupabaseService.signOut(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        children: [
           const Row(
              children: [
                Expanded(child: StatsCard(title: 'Total Orders', value: '1,204', icon: Icons.receipt_long, color: AppConstant.PRIMARY_COLOR)),
                SizedBox(width: AppConstant.PADDING_SMALL),
                Expanded(child: StatsCard(title: 'New Affiliates', value: '32', icon: Icons.person_add_alt_1, color: AppConstant.ACCENT_COLOR)),
              ],
            ),
            const SizedBox(height: AppConstant.PADDING_MEDIUM),
            GlassmorphicContainer(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("AI Insights ✨", style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.bold)),
                       const SizedBox(height: AppConstant.PADDING_SMALL),
                       Text("Powered by Gemini 1.5 Flash", style: GoogleFonts.poppins(fontSize: AppConstant.FONT_CAPTION, color: AppConstant.TEXT_SECONDARY)),
                       const Divider(height: 30),
                       _buildInsightRow(Icons.trending_up, "Predictive order volume for next week is ~150 orders."),
                       const SizedBox(height: AppConstant.PADDING_SMALL),
                       _buildInsightRow(Icons.star, "Top affiliates: Ali, Fatima, Omar."),
                       const SizedBox(height: AppConstant.PADDING_SMALL),
                       _buildInsightRow(Icons.warning_amber_rounded, "High rejection rate detected for 'Product X'."),
                    ],
                  ),
                ),
            ),
             const SizedBox(height: AppConstant.PADDING_LARGE),
            Text("Recent Activity", style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppConstant.PADDING_MEDIUM),
            _buildActivityTile("Order #54321 confirmed", "by assistant_admin"),
            _buildActivityTile("New user 'Hassan' joined", "Role: Affiliate"),
        ],
      ),
    );
  }

  Widget _buildInsightRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppConstant.PRIMARY_COLOR, size: 20),
        const SizedBox(width: AppConstant.PADDING_MEDIUM),
        Expanded(child: Text(text, style: GoogleFonts.poppins())),
      ],
    );
  }

   Widget _buildActivityTile(String title, String subtitle) {
    return GlassmorphicContainer(
      margin: const EdgeInsets.only(bottom: AppConstant.PADDING_SMALL),
      child: ListTile(
        leading: const Icon(Icons.history, color: AppConstant.TEXT_SECONDARY),
        title: Text(title, style: GoogleFonts.poppins()),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY)),
      ),
    );
  }
}