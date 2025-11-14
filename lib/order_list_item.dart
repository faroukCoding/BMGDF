import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'app_constant.dart';
import 'glassmorphic_container.dart';
import 'order_model.dart';
import 'order_detail_screen.dart';

class OrderListItem extends StatelessWidget {
  final Order order;
  const OrderListItem({super.key, required this.order});

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
    final formattedDate = order.createdAt != null ? DateFormat('dd MMM yyyy').format(order.createdAt!) : 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(order: order),
          ),
        );
      },
      child: GlassmorphicContainer(
        margin: const EdgeInsets.only(bottom: AppConstant.PADDING_MEDIUM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
          child: Row(
            children: [
              _buildImage(),
              const SizedBox(width: AppConstant.PADDING_MEDIUM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: GoogleFonts.cairo(
                        fontSize: AppConstant.FONT_SUBTITLE,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.TEXT_PRIMARY,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'To: ${order.customerName}',
                      style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY, fontSize: AppConstant.FONT_CAPTION),
                    ),
                    Text(
                      'On: $formattedDate',
                      style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY, fontSize: AppConstant.FONT_CAPTION),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '€${order.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: AppConstant.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstant.FONT_BODY,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status.replaceAll('_', ' ').toUpperCase(),
                            style: GoogleFonts.poppins(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_MEDIUM),
      child: CachedNetworkImage(
        imageUrl: order.imageUrl ?? 'https://picsum.photos/seed/${order.id}/100',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: AppConstant.SURFACE_COLOR),
        errorWidget: (context, url, error) => Container(
          width: 80,
          height: 80,
          color: AppConstant.SURFACE_COLOR,
          child: const Icon(Icons.shopping_bag_outlined, color: AppConstant.TEXT_SECONDARY),
        ),
      ),
    );
  }
}