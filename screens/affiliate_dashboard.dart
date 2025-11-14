import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class AffiliateDashboard extends StatefulWidget {
  @override
  _AffiliateDashboardState createState() => _AffiliateDashboardState();
}

class _AffiliateDashboardState extends State<AffiliateDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUser = appState.currentUser;
    final myOrders = appState.orders.where((order) => order.userId == currentUser!.id).toList();
    final confirmedOrders = myOrders.where((order) => order.status == 'confirmed' || order.status == 'delivered').length;
    final pendingOrders = myOrders.where((order) => order.status == 'pending').length;
    final totalCommissions = myOrders
        .where((order) => order.status == 'confirmed' || order.status == 'delivered')
        .fold(0.0, (sum, order) => sum + (order.commission ?? 0));

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Stats Grid
          _buildStatsGrid(totalCommissions, confirmedOrders, pendingOrders),
          SizedBox(height: 20),
          // Add Order Button
          _buildAddOrderButton(context),
          SizedBox(height: 20),
          // Tabs
          _buildTabs(),
          SizedBox(height: 20),
          // Tab Content
          _buildTabContent(myOrders, appState.payouts),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(double totalCommissions, int confirmedOrders, int pendingOrders) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard('💰', '${totalCommissions.toStringAsFixed(2)}', 'إجمالي العمولات'),
        _buildStatCard('✅', '$confirmedOrders', 'الطلبات المؤكدة'),
        _buildStatCard('⏳', '$pendingOrders', 'الطلبات المعلقة'),
      ],
    );
  }

  Widget _buildStatCard(String icon, String value, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00ADB5),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddOrderButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _showAddOrderModal(context);
      },
      icon: Icon(Icons.add),
      label: Text('إضافة طلب جديد'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF00ADB5),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab('طلباتي', 0),
          ),
          Expanded(
            child: _buildTab('سجل الدفعات', 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int tabIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = tabIndex;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _currentTab == tabIndex ? Color(0xFF00ADB5) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<Order> orders, List<Payout> payouts) {
    if (_currentTab == 0) {
      return _buildOrdersList(orders);
    } else {
      return _buildPayoutHistory(payouts.where((p) => p.userId == Provider.of<AppState>(context).currentUser!.id).toList());
    }
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState('📦', 'لا توجد طلبات');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(orders[index]);
      },
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
        ],
      ),
    );
  }

  Widget _buildPayoutHistory(List<Payout> payouts) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _requestPayout,
          child: Text('طلب سحب العمولات'),
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF00ADB5),
          ),
        ),
        SizedBox(height: 16),
        if (payouts.isEmpty)
          _buildEmptyState('💰', 'لا توجد طلبات سحب')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: payouts.length,
            itemBuilder: (context, index) {
              return _buildPayoutItem(payouts[index]);
            },
          ),
      ],
    );
  }

  Widget _buildPayoutItem(Payout payout) {
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
                'طلب سحب #${payout.id.substring(0, 8)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPayoutStatusColor(payout.payoutStatus).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getPayoutStatusColor(payout.payoutStatus)),
                ),
                child: Text(
                  _getPayoutStatusText(payout.payoutStatus),
                  style: TextStyle(
                    color: _getPayoutStatusColor(payout.payoutStatus),
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
              _buildDetailItem('المبلغ', '${payout.amount} ريال'),
              _buildDetailItem('الحالة', _getPayoutStatusText(payout.payoutStatus)),
              _buildDetailItem('تاريخ الطلب', _formatDate(payout.createdAt)),
              if (payout.adminNotes != null && payout.adminNotes!.isNotEmpty)
                _buildDetailItem('ملاحظات المدير', payout.adminNotes!),
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

  Color _getPayoutStatusColor(String status) {
    switch (status) {
      case 'pending': return Color(0xFFF1C40F);
      case 'approved': return Color(0xFF27AE60);
      case 'rejected': return Color(0xFFE74C3C);
      default: return Color(0xFFF1C40F);
    }
  }

  String _getPayoutStatusText(String status) {
    switch (status) {
      case 'pending': return 'في الانتظار';
      case 'approved': return 'تم الدفع';
      case 'rejected': return 'مرفوض';
      default: return 'غير معروف';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddOrderModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddOrderModal(),
    );
  }

  void _requestPayout() {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUser = appState.currentUser;
    final myOrders = appState.orders.where((order) => 
        order.userId == currentUser!.id && 
        (order.status == 'confirmed' || order.status == 'delivered')
    ).toList();
    
    final totalCommissions = myOrders.fold(0.0, (sum, order) => sum + (order.commission ?? 0));
    
    if (totalCommissions <= 0) {
      _showMessage('لا توجد عمولات متاحة للسحب');
      return;
    }

    final newPayout = Payout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.id,
      amount: totalCommissions,
      payoutStatus: 'pending',
    );

    appState.addPayout(newPayout);
    _showMessage('تم طلب سحب ${totalCommissions.toStringAsFixed(2)} ريال بنجاح');
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

class AddOrderModal extends StatefulWidget {
  @override
  _AddOrderModalState createState() => _AddOrderModalState();
}

class _AddOrderModalState extends State<AddOrderModal> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _orderNotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إضافة طلب جديد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00ADB5),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_customerNameController, 'اسم الزبون'),
            SizedBox(height: 16),
            _buildTextField(_customerPhoneController, 'رقم الهاتف', isPhone: true),
            SizedBox(height: 16),
            _buildTextField(_customerAddressController, 'العنوان', maxLines: 3),
            SizedBox(height: 16),
            _buildTextField(_productNameController, 'اسم المنتج'),
            SizedBox(height: 16),
            _buildTextField(_productPriceController, 'سعر المنتج', isNumber: true),
            SizedBox(height: 16),
            _buildTextField(_orderNotesController, 'ملاحظات إضافية', maxLines: 2),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('إضافة الطلب'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF00ADB5),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPhone = false, bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Color(0xFF16213E).withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      final newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: appState.currentUser!.id,
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        customerAddress: _customerAddressController.text,
        productName: _productNameController.text,
        productPrice: double.parse(_productPriceController.text),
        commission: double.parse(_productPriceController.text) * 0.1, // 10% commission
        status: 'pending',
        notes: _orderNotesController.text.isEmpty ? null : _orderNotesController.text,
      );

      appState.addOrder(newOrder);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة الطلب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}