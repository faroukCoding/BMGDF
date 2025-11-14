import 'package:flutter/material.dart';
import '../app_state.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  final bool showActions;
  final Function(String, String)? onStatusUpdate;
  final List<User>? users; // للمسؤولين لعرض معلومات المستخدم

  const OrderItem({
    Key? key,
    required this.order,
    this.showActions = false,
    this.onStatusUpdate,
    this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = users?.firstWhere(
      (u) => u.id == order.userId,
      orElse: () => User(
        id: 'unknown',
        name: 'مستخدم غير معروف',
        email: '',
        role: '',
        phone: '',
      ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF16213E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border(right: BorderSide(color: Color(0xFF00ADB5), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with order info and status
          _buildOrderHeader(order, user),
          SizedBox(height: 12),
          
          // Order details
          _buildOrderDetails(order),
          
          // User info (for admin views)
          if (user != null && users != null) _buildUserInfo(user),
          
          // Notes if exists
          if (order.notes != null && order.notes!.isNotEmpty) 
            _buildOrderNotes(order.notes!),
          
          // Actions if enabled
          if (showActions && onStatusUpdate != null) 
            _buildOrderActions(order, onStatusUpdate!),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(Order order, User? user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلب #${order.id.substring(0, 8)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                  fontSize: 16,
                ),
              ),
              if (user != null && users != null) ...[
                SizedBox(height: 4),
                Text(
                  'بواسطة: ${user.name}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _getStatusColor(order.status)),
          ),
          child: Text(
            _getStatusText(order.status),
            style: TextStyle(
              color: _getStatusColor(order.status),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildDetailItem('اسم الزبون', order.customerName),
        _buildDetailItem('رقم الهاتف', order.customerPhone),
        if (order.customerAddress != null && order.customerAddress!.isNotEmpty)
          _buildDetailItem('العنوان', order.customerAddress!),
        _buildDetailItem('المنتج', order.productName),
        _buildDetailItem('السعر', '${order.productPrice} ريال'),
        if (order.commission != null && order.commission! > 0)
          _buildDetailItem('العمولة', '${order.commission} ريال'),
        _buildDetailItem('التاريخ', _formatDate(order.createdAt)),
      ],
    );
  }

  Widget _buildUserInfo(User user) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 16, color: Colors.white70),
          SizedBox(width: 8),
          Text(
            'المسوّق: ${user.name}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.phone, size: 16, color: Colors.white70),
          SizedBox(width: 8),
          Text(
            user.phone,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotes(String notes) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFF1C40F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFF1C40F).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note, size: 16, color: Color(0xFFF1C40F)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              notes,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderActions(Order order, Function(String, String) onStatusUpdate) {
    final currentUserRole = ''; // سيتم تمريرها من الشاشة الأم
    
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Row(
        children: [
          // Actions for Assistant Admin
          if (order.status == 'pending') ...[
            _buildActionButton(
              'تأكيد',
              Color(0xFF27AE60),
              Icons.check_circle,
              () => onStatusUpdate(order.id, 'confirmed'),
            ),
            SizedBox(width: 8),
            _buildActionButton(
              'رفض',
              Color(0xFFE74C3C),
              Icons.cancel,
              () => onStatusUpdate(order.id, 'rejected'),
            ),
          ],
          
          // Actions for Call Center
          if (order.status == 'confirmed') ...[
            _buildActionButton(
              'جاهز للتوصيل',
              Color(0xFF3498DB),
              Icons.delivery_dining,
              () => onStatusUpdate(order.id, 'in_delivery'),
            ),
          ],
          
          // Actions for Driver
          if (order.status == 'confirmed' || order.status == 'in_delivery') ...[
            if (order.status == 'confirmed') 
              _buildActionButton(
                'بدء التوصيل',
                Color(0xFF3498DB),
                Icons.directions_car,
                () => onStatusUpdate(order.id, 'in_delivery'),
              ),
            SizedBox(width: 8),
            _buildActionButton(
              'تم التسليم',
              Color(0xFF27AE60),
              Icons.check_circle,
              () => onStatusUpdate(order.id, 'delivered'),
            ),
            SizedBox(width: 8),
            _buildActionButton(
              'فشل التسليم',
              Color(0xFFE74C3C),
              Icons.error,
              () => onStatusUpdate(order.id, 'failed'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text, style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Color(0xFFF1C40F);
      case 'confirmed': return Color(0xFF27AE60);
      case 'rejected': return Color(0xFFE74C3C);
      case 'delivered': return Color(0xFF00ADB5);
      case 'in_delivery': return Color(0xFF3498DB);
      case 'failed': return Color(0xFFE74C3C);
      default: return Color(0xFFF1C40F);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return 'معلق';
      case 'confirmed': return 'مؤكد';
      case 'rejected': return 'مرفوض';
      case 'delivered': return 'تم التسليم';
      case 'in_delivery': return 'قيد التوصيل';
      case 'failed': return 'فشل التسليم';
      default: return 'غير معروف';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}