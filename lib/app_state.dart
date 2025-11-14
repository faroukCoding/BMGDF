import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String? password;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.password,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Order {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String productName;
  final double productPrice;
  final double? commission;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.productName,
    required this.productPrice,
    this.commission,
    required this.status,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Order copyWith({
    String? status,
    String? notes,
  }) {
    return Order(
      id: id,
      userId: userId,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      productName: productName,
      productPrice: productPrice,
      commission: commission,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double commission;
  final String? description;
  final String? category;
  final String status;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.commission,
    this.description,
    this.category,
    required this.status,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class Payout {
  final String id;
  final String userId;
  final double amount;
  final String payoutStatus;
  final String? adminNotes;
  final DateTime createdAt;

  Payout({
    required this.id,
    required this.userId,
    required this.amount,
    required this.payoutStatus,
    this.adminNotes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String target;
  final String priority;
  final String senderId;
  final String senderName;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.target,
    required this.priority,
    required this.senderId,
    required this.senderName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class AppState with ChangeNotifier {
  User? _currentUser;
  List<Order> _orders = [];
  List<User> _users = [];
  List<Product> _products = [];
  List<Payout> _payouts = [];
  List<AppNotification> _notifications = [];

  User? get currentUser => _currentUser;
  List<Order> get orders => _orders;
  List<User> get users => _users;
  List<Product> get products => _products;
  List<Payout> get payouts => _payouts;
  List<AppNotification> get notifications => _notifications;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _orders = [];
    _users = [];
    _products = [];
    _payouts = [];
    _notifications = [];
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void toggleProductStatus(String productId) {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      final currentStatus = _products[index].status;
      _products[index] = Product(
        id: _products[index].id,
        name: _products[index].name,
        price: _products[index].price,
        commission: _products[index].commission,
        description: _products[index].description,
        category: _products[index].category,
        status: currentStatus == 'active' ? 'inactive' : 'active',
        createdAt: _products[index].createdAt,
      );
      notifyListeners();
    }
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void addPayout(Payout payout) {
    _payouts.add(payout);
    notifyListeners();
  }

  void updatePayoutStatus(String payoutId, String status, String adminNotes) {
    final index = _payouts.indexWhere((payout) => payout.id == payoutId);
    if (index != -1) {
      _payouts[index] = Payout(
        id: _payouts[index].id,
        userId: _payouts[index].userId,
        amount: _payouts[index].amount,
        payoutStatus: status,
        adminNotes: adminNotes,
        createdAt: _payouts[index].createdAt,
      );
      notifyListeners();
    }
  }

  void addNotification(AppNotification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  AppState() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _users.addAll([
      User(
        id: '1',
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        role: 'affiliate',
        phone: '0512345678',
      ),
      User(
        id: '2',
        name: 'مدير النظام',
        email: 'admin@example.com',
        role: 'admin',
        phone: '0512345679',
      ),
      User(
        id: '3',
        name: 'مساعد إداري',
        email: 'assistant@example.com',
        role: 'assistant_admin',
        phone: '0512345680',
      ),
      User(
        id: '4',
        name: 'موظف اتصالات',
        email: 'callcenter@example.com',
        role: 'call_center',
        phone: '0512345681',
      ),
      User(
        id: '5',
        name: 'سائق توصيل',
        email: 'driver@example.com',
        role: 'driver',
        phone: '0512345682',
      ),
    ]);

    _products.addAll([
      Product(
        id: '1',
        name: 'منتج رقم 1',
        price: 100.0,
        commission: 10.0,
        description: 'وصف المنتج الأول',
        category: 'فئة 1',
        status: 'active',
      ),
      Product(
        id: '2',
        name: 'منتج رقم 2',
        price: 200.0,
        commission: 20.0,
        description: 'وصف المنتج الثاني',
        category: 'فئة 2',
        status: 'active',
      ),
      Product(
        id: '3',
        name: 'منتج رقم 3',
        price: 150.0,
        commission: 15.0,
        description: 'وصف المنتج الثالث',
        category: 'فئة 1',
        status: 'active',
      ),
    ]);

    _orders.addAll([
      Order(
        id: '1',
        userId: '1',
        customerName: 'زبون 1',
        customerPhone: '0511111111',
        customerAddress: 'عنوان الزبون 1، الرياض',
        productName: 'منتج رقم 1',
        productPrice: 100.0,
        commission: 10.0,
        status: 'pending',
        notes: 'طلب عاجل',
      ),
      Order(
        id: '2',
        userId: '1',
        customerName: 'زبون 2',
        customerPhone: '0522222222',
        customerAddress: 'عنوان الزبون 2، جدة',
        productName: 'منتج رقم 2',
        productPrice: 200.0,
        commission: 20.0,
        status: 'confirmed',
      ),
      Order(
        id: '3',
        userId: '1',
        customerName: 'زبون 3',
        customerPhone: '0533333333',
        customerAddress: 'عنوان الزبون 3، الدمام',
        productName: 'منتج رقم 3',
        productPrice: 150.0,
        commission: 15.0,
        status: 'in_delivery',
      ),
      Order(
        id: '4',
        userId: '1',
        customerName: 'زبون 4',
        customerPhone: '0544444444',
        customerAddress: 'عنوان الزبون 4، الرياض',
        productName: 'منتج رقم 1',
        productPrice: 100.0,
        commission: 10.0,
        status: 'delivered',
      ),
    ]);

    _payouts.addAll([
      Payout(
        id: '1',
        userId: '1',
        amount: 150.0,
        payoutStatus: 'pending',
      ),
      Payout(
        id: '2',
        userId: '1',
        amount: 200.0,
        payoutStatus: 'approved',
        adminNotes: 'تم الدفع نقداً',
      ),
    ]);

    _notifications.addAll([
      AppNotification(
        id: '1',
        title: 'ترحيب بالنظام',
        message: 'مرحباً بك في نظام إدارة التسويق بالعمولة',
        target: 'all',
        priority: 'normal',
        senderId: '2',
        senderName: 'مدير النظام',
      ),
      AppNotification(
        id: '2',
        title: 'تحديث جديد',
        message: 'تم إضافة ميزات جديدة في النظام',
        target: 'affiliate',
        priority: 'high',
        senderId: '2',
        senderName: 'مدير النظام',
      ),
    ]);
  }
}