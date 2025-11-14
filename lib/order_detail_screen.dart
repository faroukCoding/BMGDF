import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'app_constant.dart';
import 'glassmorphic_container.dart';
import 'order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
      case 'delivered':
        return Colors.green;
      case 'pending_review':
      case 'in_delivery':
        return Colors.orange;
      case 'rejected':
        return AppConstant.ERROR_COLOR;
      case 'draft':
        return AppConstant.TEXT_SECONDARY;
      default:
        return AppConstant.PRIMARY_COLOR;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final formattedDate = order.createdAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt!) : 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}', style: GoogleFonts.cairo()),
        backgroundColor: AppConstant.BACKGROUND_COLOR.withOpacity(0.5),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        children: [
          _buildImage(),
          const SizedBox(height: AppConstant.PADDING_LARGE),
          GlassmorphicContainer(
            child: Padding(
              padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName,
                    style: GoogleFonts.cairo(
                      fontSize: AppConstant.FONT_HEADLINE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstant.PADDING_SMALL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '€${order.price.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          color: AppConstant.PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstant.FONT_TITLE,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status.replaceAll('_', ' ').toUpperCase(),
                          style: GoogleFonts.poppins(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                   Text(
                    'Created on: $formattedDate',
                    style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          _buildSection('Customer Details', [
            _buildDetailRow(Icons.person_outline, 'Name', order.customerName),
            _buildDetailRow(Icons.phone_outlined, 'Phone', order.customerPhone),
            _buildDetailRow(Icons.location_city_outlined, 'City', order.customerCity),
            _buildDetailRow(Icons.location_on_outlined, 'Address', order.customerAddress),
          ]),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          if (order.notes != null && order.notes!.isNotEmpty)
            _buildSection('Notes', [
              Text(order.notes!, style: GoogleFonts.poppins()),
            ]),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_XL),
      child: CachedNetworkImage(
        imageUrl: order.imageUrl ?? 'https://picsum.photos/seed/${order.id}/400',
        height: 200,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          color: AppConstant.SURFACE_COLOR,
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: AppConstant.SURFACE_COLOR,
          child: const Icon(Icons.shopping_bag_outlined, color: AppConstant.TEXT_SECONDARY, size: 60),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return GlassmorphicContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: AppConstant.FONT_TITLE,
                fontWeight: FontWeight.w600,
                color: AppConstant.PRIMARY_COLOR,
              ),
            ),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstant.PADDING_MEDIUM),
      child: Row(
        children: [
          Icon(icon, color: AppConstant.TEXT_SECONDARY, size: 20),
          const SizedBox(width: AppConstant.PADDING_MEDIUM),
          Text('$label: ', style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY)),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}