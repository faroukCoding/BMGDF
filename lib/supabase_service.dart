import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'order_model.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const _uuid = Uuid();

  static User? get currentUser => _client.auth.currentUser;
  static String? get currentUserId => _client.auth.currentUser?.id;
  static bool get isAuthenticated => _client.auth.currentUser != null;

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUserId == null) return null;
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', currentUserId!)
          .single();
      return response;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchWhere({
    required String table,
    required String column,
    required dynamic value,
  }) async {
    try {
      final response = await _client.from(table).select().eq(column, value);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Fetch with filter failed: $e');
    }
  }

  static Future<void> createOrder({required Order order, File? imageFile}) async {
    try {
      if (imageFile != null && currentUserId != null) {
        final fileExtension = imageFile.path.split('.').last;
        final fileName = '${_uuid.v4()}.$fileExtension';
        final filePath = '$currentUserId/$fileName';

        await _client.storage.from('order_images').upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

        order.imageUrl = _client.storage.from('order_images').getPublicUrl(filePath);
      }

      await _client.from('orders').insert(order.toJson());

    } catch (e) {
      print('Error creating order: $e');
      throw Exception('Failed to create order. Please try again.');
    }
  }

  static Future<List<Order>> getAffiliateOrders() async {
    if (currentUserId == null) return [];
    try {
      final response = await _client
          .from('orders')
          .select()
          .eq('affiliate_id', currentUserId!)
          .order('created_at', ascending: false);
      
      return response.map((item) => Order.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching affiliate orders: $e');
      throw Exception('Failed to fetch orders.');
    }
  }
}