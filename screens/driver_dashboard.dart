import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class DriverDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final driverOrders = appState.orders.where((order) => 
        order.status == 'in_delivery' || order.status == 'confirmed').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة السائق'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (driverOrders.isEmpty)
              _buildEmptyState('🚚', 'لا توجد طلبات للتوصيل')
            else
              ...driverOrders.map((order) => _buildOrderItem(order)).toList(),
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
              if (order.status == 'confirmed') ...[
                ElevatedButton.icon(
                  onPressed: () {
                    _updateOrderStatus(order.id, 'in_delivery');
                  },
                  icon: Icon(Icons.directions_car),
                  label: Text('بدء التوصيل'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF3498DB),
                  ),
                ),
                SizedBox(width: 8),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  _updateOrderStatus(order.id, 'delivered');
                },
                icon: Icon(Icons.check_circle),
                label: Text('تم التسليم'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF27AE60),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _showFailedDeliveryDialog(order.id);
                },
                icon: Icon(Icons.error),
                label: Text('فشل التسليم'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE74C3C),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed': return Color(0xFF27AE60);
      case 'in_delivery': return Color(0xFFF1C40F);
      case 'delivered': return Color(0xFF00ADB5);
      case 'failed': return Color(0xFFE74C3C);
      default: return Color(0xFFF1C40F);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed': return 'مؤكد';
      case 'in_delivery': return 'قيد التوصيل';
      case 'delivered': return 'تم التسليم';
      case 'failed': return 'فشل التسليم';
      default: return 'غير معروف';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateOrderStatus(String orderId, String status) {
    Provider.of<AppState>(context, listen: false).updateOrderStatus(orderId, status);
    
    String message = '';
    switch (status) {
      case 'in_delivery':
        message = 'تم بدء عملية التوصيل';
        break;
      case 'delivered':
        message = 'تم تسليم الطلب بنجاح';
        break;
      case 'failed':
        message = 'تم تسجيل فشل التسليم';
        break;
    }
    
    _showMessage(message);
  }

  void _showFailedDeliveryDialog(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('فشل التسليم'),
        content: Text('يرجى اختيار سبب فشل التسليم:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateOrderStatusWithReason(orderId, 'فشل في الوصول للعميل');
            },
            child: Text('فشل في الوصول للعميل'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateOrderStatusWithReason(orderId, 'رفض الاستلام');
            },
            child: Text('رفض الاستلام'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateOrderStatusWithReason(orderId, 'عنوان غير صحيح');
            },
            child: Text('عنوان غير صحيح'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatusWithReason(String orderId, String reason) {
    Provider.of<AppState>(context, listen: false).updateOrderStatus(orderId, 'failed');
    _showMessage('فشل التسليم: $reason');
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