import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final orders = appState.orders;
    final users = appState.users;
    final products = appState.products;
    final payouts = appState.payouts;
    final notifications = appState.notifications;

    final totalRevenue = orders
        .where((order) => order.status == 'delivered')
        .fold(0.0, (sum, order) => sum + order.productPrice);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text('لوحة المدير'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'جميع الطلبات (${orders.length})'),
              Tab(text: 'المنتجات (${products.length})'),
              Tab(text: 'المستخدمين (${users.length})'),
              Tab(text: 'طلبات السحب (${payouts.length})'),
              Tab(text: 'التقارير'),
              Tab(text: 'الإشعارات (${notifications.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllOrdersTab(orders, users),
            _buildProductsTab(products),
            _buildUsersTab(users),
            _buildPayoutsTab(payouts, users),
            _buildReportsTab(orders, users, products),
            _buildNotificationsTab(notifications),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  Widget _buildAllOrdersTab(List<Order> orders, List<User> users) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (orders.isEmpty)
            _buildEmptyState('📦', 'لا توجد طلبات')
          else
            ...orders.map((order) => _buildAdminOrderItem(order, users)).toList(),
        ],
      ),
    );
  }

  Widget _buildAdminOrderItem(Order order, List<User> users) {
    final user = users.firstWhere(
      (user) => user.id == order.userId,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طلب #${order.id.substring(0, 8)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00ADB5),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'بواسطة: ${user.name}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
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
              _buildDetailItem('العمولة', '${order.commission} ريال'),
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

  Widget _buildProductsTab(List<Product> products) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (products.isEmpty)
            _buildEmptyState('🛍️', 'لا توجد منتجات')
          else
            ...products.map((product) => _buildProductItem(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
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
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                  fontSize: 18,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: product.status == 'active' 
                    ? Color(0xFF27AE60).withOpacity(0.2)
                    : Color(0xFF95A5A6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: product.status == 'active' 
                      ? Color(0xFF27AE60)
                      : Color(0xFF95A5A6)
                  ),
                ),
                child: Text(
                  product.status == 'active' ? 'نشط' : 'غير نشط',
                  style: TextStyle(
                    color: product.status == 'active' 
                      ? Color(0xFF27AE60)
                      : Color(0xFF95A5A6),
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
              _buildDetailItem('السعر', '${product.price} ريال'),
              _buildDetailItem('العمولة', '${product.commission} ريال'),
              _buildDetailItem('الفئة', product.category ?? 'غير محدد'),
              _buildDetailItem('تاريخ الإضافة', _formatDate(product.createdAt)),
            ],
          ),
          if (product.description != null && product.description!.isNotEmpty) ...[
            SizedBox(height: 8),
            _buildDetailItem('الوصف', product.description!),
          ],
          SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  _toggleProductStatus(product.id);
                },
                style: ElevatedButton.styleFrom(
                  primary: product.status == 'active' ? Color(0xFFE74C3C) : Color(0xFF27AE60),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  product.status == 'active' ? 'تعطيل' : 'تفعيل',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _showEditProductModal(product);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF3498DB),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'تعديل',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab(List<User> users) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (users.isEmpty)
            _buildEmptyState('👥', 'لا يوجد مستخدمين')
          else
            ...users.map((user) => _buildUserItem(user)).toList(),
        ],
      ),
    );
  }

  Widget _buildUserItem(User user) {
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
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                  fontSize: 18,
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
                  _getRoleText(user.role),
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
              _buildDetailItem('البريد الإلكتروني', user.email),
              _buildDetailItem('رقم الهاتف', user.phone),
              _buildDetailItem('الدور', _getRoleText(user.role)),
              _buildDetailItem('تاريخ التسجيل', _formatDate(user.createdAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsTab(List<Payout> payouts, List<User> users) {
    final pendingPayouts = payouts.where((p) => p.payoutStatus == 'pending').toList();
    final processedPayouts = payouts.where((p) => p.payoutStatus != 'pending').toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A2E).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Color(0xFF00ADB5),
                borderRadius: BorderRadius.circular(8),
              ),
              tabs: [
                Tab(text: 'طلبات معلقة (${pendingPayouts.length})'),
                Tab(text: 'تم معالجتها (${processedPayouts.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPayoutsList(pendingPayouts, users, true),
                _buildPayoutsList(processedPayouts, users, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutsList(List<Payout> payouts, List<User> users, bool showActions) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (payouts.isEmpty)
            _buildEmptyState('💰', 'لا توجد طلبات سحب')
          else
            ...payouts.map((payout) => _buildPayoutItem(payout, users, showActions)).toList(),
        ],
      ),
    );
  }

  Widget _buildPayoutItem(Payout payout, List<User> users, bool showActions) {
    final user = users.firstWhere(
      (user) => user.id == payout.userId,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب سحب من ${user.name}',
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
              _buildDetailItem('تاريخ الطلب', _formatDate(payout.createdAt)),
              if (payout.adminNotes != null && payout.adminNotes!.isNotEmpty)
                _buildDetailItem('ملاحظات المدير', payout.adminNotes!),
            ],
          ),
          if (showActions) ...[
            SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _approvePayout(payout.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF27AE60),
                  ),
                  child: Text('موافقة'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _rejectPayout(payout.id);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE74C3C),
                  ),
                  child: Text('رفض'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportsTab(List<Order> orders, List<User> users, List<Product> products) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A2E).withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: 'month',
                    decoration: InputDecoration(
                      labelText: 'الفترة الزمنية',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Color(0xFF1A1A2E),
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(value: 'day', child: Text('اليوم')),
                      DropdownMenuItem(value: 'week', child: Text('الأسبوع')),
                      DropdownMenuItem(value: 'month', child: Text('الشهر')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _exportReports,
                  icon: Icon(Icons.analytics),
                  label: Text('تصدير التقارير'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6C7B7F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildChartContainer('الطلبات حسب الحالة', _buildOrdersStatusChart(orders)),
              _buildChartContainer('أفضل المسوّقين', _buildTopAffiliatesChart(orders, users)),
              _buildChartContainer('العمولات الشهرية', _buildMonthlyCommissionsChart(orders)),
              _buildChartContainer('المنتجات الأكثر مبيعاً', _buildTopProductsChart(orders)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF16213E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF00ADB5).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF00ADB5),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildOrdersStatusChart(List<Order> orders) {
    final statusCounts = {
      'pending': orders.where((o) => o.status == 'pending').length,
      'confirmed': orders.where((o) => o.status == 'confirmed').length,
      'delivered': orders.where((o) => o.status == 'delivered').length,
      'rejected': orders.where((o) => o.status == 'rejected').length,
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final entry in statusCounts.entries)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(entry.key),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${_getStatusText(entry.key)}: ${entry.value}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopAffiliatesChart(List<Order> orders, List<User> users) {
    final affiliates = users.where((u) => u.role == 'affiliate');
    final affiliateStats = affiliates.map((affiliate) {
      final affiliateOrders = orders.where((o) => o.userId == affiliate.id && o.status == 'delivered');
      return {
        'name': affiliate.name,
        'count': affiliateOrders.length,
        'commission': affiliateOrders.fold(0.0, (sum, o) => sum + (o.commission ?? 0))
      };
    }).toList();

    affiliateStats.sort((a, b) => b['commission'].compareTo(a['commission']));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: affiliateStats.length,
      itemBuilder: (context, index) {
        final stat = affiliateStats[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(0xFF00ADB5),
            child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
          ),
          title: Text(stat['name'], style: TextStyle(color: Colors.white, fontSize: 12)),
          subtitle: Text('${stat['commission']} ريال', style: TextStyle(color: Colors.white70)),
          trailing: Text('${stat['count']} طلب', style: TextStyle(color: Colors.white70)),
        );
      },
    );
  }

  Widget _buildMonthlyCommissionsChart(List<Order> orders) {
    return Center(
      child: Text(
        'رسم بياني للعمولات الشهرية',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTopProductsChart(List<Order> orders) {
    final productCounts = {};
    orders.where((o) => o.status == 'delivered').forEach((order) {
      productCounts[order.productName] = (productCounts[order.productName] ?? 0) + 1;
    });

    final sortedProducts = productCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        final entry = sortedProducts[index];
        return ListTile(
          leading: Icon(Icons.shopping_bag, color: Color(0xFF00ADB5)),
          title: Text(entry.key, style: TextStyle(color: Colors.white, fontSize: 12)),
          trailing: Text('${entry.value}', style: TextStyle(color: Colors.white70)),
        );
      },
    );
  }

  Widget _buildNotificationsTab(List<AppNotification> notifications) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (notifications.isEmpty)
            _buildEmptyState('📢', 'لا توجد إشعارات')
          else
            ...notifications.map((notification) => _buildNotificationItem(notification)).toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF16213E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border(right: BorderSide(
          color: _getPriorityColor(notification.priority), 
          width: 4
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ADB5),
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPriorityColor(notification.priority).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getPriorityColor(notification.priority)),
                ),
                child: Text(
                  _getPriorityText(notification.priority),
                  style: TextStyle(
                    color: _getPriorityColor(notification.priority),
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
              _buildDetailItem('الرسالة', notification.message),
              _buildDetailItem('المستهدفين', _getTargetText(notification.target)),
              _buildDetailItem('المرسل', notification.senderName),
              _buildDetailItem('تاريخ الإرسال', _formatDate(notification.createdAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showFloatingActionMenu(context);
      },
      backgroundColor: Color(0xFF00ADB5),
      child: Icon(Icons.add),
    );
  }

  void _showFloatingActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add_shopping_cart, color: Color(0xFF00ADB5)),
                title: Text('إضافة منتج جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddProductModal(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_add, color: Color(0xFF00ADB5)),
                title: Text('إضافة مستخدم جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddUserModal(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: Color(0xFF00ADB5)),
                title: Text('إرسال إشعار جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _showSendNotificationModal(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'normal': return Color(0xFF3498DB);
      case 'high': return Color(0xFFF1C40F);
      case 'urgent': return Color(0xFFE74C3C);
      default: return Color(0xFF3498DB);
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'normal': return 'عادية';
      case 'high': return 'عالية';
      case 'urgent': return 'عاجلة';
      default: return 'عادية';
    }
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'affiliate': return 'مسوّق';
      case 'admin': return 'مدير';
      case 'assistant_admin': return 'مساعد إداري';
      case 'call_center': return 'مؤكد الطلبات';
      case 'driver': return 'سائق';
      default: return 'غير معروف';
    }
  }

  String _getTargetText(String target) {
    switch (target) {
      case 'all': return 'جميع المستخدمين';
      case 'affiliate': return 'المسوّقين';
      case 'call_center': return 'مؤكدي الطلبات';
      case 'driver': return 'السائقين';
      case 'assistant_admin': return 'المساعدين الإداريين';
      default: return 'غير محدد';
    }
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

  // Action methods
  void _toggleProductStatus(String productId) {
    Provider.of<AppState>(context, listen: false).toggleProductStatus(productId);
  }

  void _approvePayout(String payoutId) {
    Provider.of<AppState>(context, listen: false).updatePayoutStatus(payoutId, 'approved', 'تم الدفع نقداً');
    _showMessage('تم الموافقة على طلب السحب');
  }

  void _rejectPayout(String payoutId) {
    Provider.of<AppState>(context, listen: false).updatePayoutStatus(payoutId, 'rejected', 'تم رفض الطلب');
    _showMessage('تم رفض طلب السحب');
  }

  void _exportReports() {
    _showMessage('تم تصدير التقرير بنجاح');
  }

  void _showEditProductModal(Product product) {
    // Implement product editing modal
  }

  void _showAddProductModal(BuildContext context) {
    // Implement add product modal
  }

  void _showAddUserModal(BuildContext context) {
    // Implement add user modal
  }

  void _showSendNotificationModal(BuildContext context) {
    // Implement send notification modal
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