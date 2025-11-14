class Order {
  final int? id;
  final String affiliateId;
  final String customerName;
  final String customerPhone;
  final String customerCity;
  final String customerAddress;
  final String productName;
  final double price;
  final String? notes;
  String? imageUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? commission;
  final String? driverId;
  final String? callCenterId;

  Order({
    this.id,
    required this.affiliateId,
    required this.customerName,
    required this.customerPhone,
    required this.customerCity,
    required this.customerAddress,
    required this.productName,
    required this.price,
    this.notes,
    this.imageUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.commission,
    this.driverId,
    this.callCenterId
  });

  Map<String, dynamic> toJson() {
    return {
      'affiliate_id': affiliateId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_city': customerCity,
      'customer_address': customerAddress,
      'product_name': productName,
      'price': price,
      'notes': notes,
      'image_url': imageUrl,
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      affiliateId: json['affiliate_id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerCity: json['customer_city'],
      customerAddress: json['customer_address'],
      productName: json['product_name'],
      price: (json['price'] as num).toDouble(),
      notes: json['notes'],
      imageUrl: json['image_url'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      commission: json['commission'] != null ? (json['commission'] as num).toDouble() : null,
      driverId: json['driver_id'],
      callCenterId: json['call_center_id'],
    );
  }
}