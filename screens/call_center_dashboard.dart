import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';

class CallCenterDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final confirmedOrders = appState.orders.where((order) => order.status == 'confirmed').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة مركز الاتصالات'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (confirmedOrders.isEmpty)
              _buildEmptyState('📞', 'لا توجد طلبات مؤكدة')
            else
              ...confirmedOrders.map((order) => _buildOrderItem(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.id.substring(0, 8)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF27AE60).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF27AE60)),
                ),
                child: Text(
                  'مؤكد',
                  style: TextStyle(
                    color: Color(0xFF27AE60),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildDetailItem('اسم الزبون', order.customerName),
              _buildDetailItem('رقم الهاتف', order.customerPhone),
              _buildDetailItem('العنوان', order.customerAddress),
              _buildDetailItem('المنتج', order.productName),
              _buildDetailItem('السعر', '${order.productPrice} ريال'),
              _buildDetailItem('التاريخ', _formatDate(order.createdAt)),
            ],
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildDetailItem('ملاحظات', order.notes!),
          ],
          SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _callCustomer(order.customerPhone);
                },
                icon: Icon(Icons.phone),
                label: Text('اتصال بالزبون'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF27AE60),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _updateOrderStatus(order.id, 'in_delivery');
                },
                icon: Icon(Icons.delivery_dining),
                label: Text('جاهز للتوصيل'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF3498DB),
                ),
              ),
            ],
          ),
        ],
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
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String icon, String text) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _callCustomer(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showMessage('لا يمكن فتح تطبيق الهاتف');
    }
  }

  void _updateOrderStatus(String orderId, String status) {
    Provider.of<AppState>(context, listen: false).updateOrderStatus(orderId, status);
    _showMessage('تم تحديث حالة الطلب إلى "جاهز للتوصيل"');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF00ADB5),
      ),
    );
  }
}