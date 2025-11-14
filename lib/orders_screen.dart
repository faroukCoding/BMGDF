import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'app_constant.dart';
import 'order_list_item.dart';
import 'order_model.dart';
import 'supabase_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late Future<List<Order>> _ordersFuture;
  late TabController _tabController;
  String _currentStatusFilter = 'all';

  final List<String> _statuses = ['all', 'pending_review', 'confirmed', 'in_delivery', 'delivered', 'rejected', 'draft'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
    _ordersFuture = SupabaseService.getAffiliateOrders();
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentStatusFilter = _statuses[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          _buildFilterTabs(),
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingShimmer();
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final allOrders = snapshot.data!;
                final filteredOrders = _currentStatusFilter == 'all'
                    ? allOrders
                    : allOrders.where((order) => order.status == _currentStatusFilter).toList();

                if (filteredOrders.isEmpty) {
                  return _buildEmptyState(isFiltered: true);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return OrderListItem(order: filteredOrders[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: AppConstant.PRIMARY_COLOR,
      labelColor: AppConstant.PRIMARY_COLOR,
      unselectedLabelColor: AppConstant.TEXT_SECONDARY,
      tabs: _statuses.map((status) {
        return Tab(text: status.replaceAll('_', ' ').toUpperCase());
      }).toList(),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: AppConstant.SURFACE_COLOR,
      highlightColor: AppConstant.SURFACE_COLOR.withOpacity(0.5),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          height: 100,
          margin: const EdgeInsets.only(bottom: AppConstant.PADDING_MEDIUM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstant.BORDER_RADIUS_LARGE),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isFiltered = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 80, color: AppConstant.TEXT_SECONDARY),
          const SizedBox(height: AppConstant.PADDING_MEDIUM),
          Text(
            isFiltered ? 'No Orders Found' : 'You haven\'t placed any orders yet.',
            style: GoogleFonts.cairo(fontSize: AppConstant.FONT_TITLE, color: AppConstant.TEXT_PRIMARY),
          ),
          if (isFiltered)
            Text(
              'No orders match the current filter.',
              style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY),
            )
          else
            Text(
              'Tap the + button to create your first order.',
              style: GoogleFonts.poppins(color: AppConstant.TEXT_SECONDARY),
            ),
        ],
      ),
    );
  }
}