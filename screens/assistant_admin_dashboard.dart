import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class AssistantAdminDashboard extends StatefulWidget {
  @override
  _AssistantAdminDashboardState createState() => _AssistantAdminDashboardState();
}

class _AssistantAdminDashboardState extends State<AssistantAdminDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final pendingOrders = appState.orders.where((order) => order.status == 'pending').toList();
    final reviewedOrders = appState.orders.where((order) => order.status != 'pending').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('لوحة المساعد الإداري'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'الطلبات المعلقة (${pendingOrders.length})'),
              Tab(text: 'الطلبات المراجعة (${reviewedOrders.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(pendingOrders, true),
            _buildOrdersList(reviewedOrders, false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, bool showActions) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (orders.isEmpty)
            _buildEmptyState('📦', 'لا توجد طلبات')
          else
            ...orders.map((order) => _buildOrderItem(order, showActions)).toList(),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Order order, bool showActions) {
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
              _buildDetailItem('المنتج', order.productName),
              _buildDetailItem('السعر', '${order.productPrice} ريال'),
              _buildDetailItem('العمولة', '${order.commission ?? 0} ريال'),
              _buildDetailItem('التاريخ', _formatDate(order.createdAt)),
            ],
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildDetailItem('ملاحظات', order.notes!),
          ],
          if (showActions && order.status == 'pending') ...[
            SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateOrderStatus(order.id, 'confirmed');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF27AE60),
                  ),
                  child: Text('تأكيد الطلب'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _updateOrderStatus(order.id, 'rejected');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE74C3C),
                  ),
                  child: Text('رفض الطلب'),
                ),
              ],
            ),
          ],
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
      case 'pending': return Color(0xFFF1C40F);
      case 'confirmed': return Color(0xFF27AE60);
      case 'rejected': return Color(0xFFE74C3C);
      case 'delivered': return Color(0xFF00ADB5);
      case 'in_delivery': return Color(0xFF3498DB);
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
      default: return 'غير معروف';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateOrderStatus(String orderId, String status) {
    Provider.of<AppState>(context, listen: false).updateOrderStatus(orderId, status);
    _showMessage('تم تحديث حالة الطلب بنجاح');
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