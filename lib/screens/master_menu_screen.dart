// ========== 1. MASTER MENU SCREEN (Updated) ==========
import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../widgets/menu_expansion_tile.dart';
import 'dashboard/dashboard_screen.dart';
import 'master/customer_screen.dart';
import 'master/detail_screen.dart';
import 'master/norm_screen.dart';
import 'master/process_management_screen.dart';
import 'master/process_screen.dart';
import 'master/product_price_screen.dart';
import 'master/product_screen.dart';
// Import các screen

class MasterMenuScreen extends StatefulWidget {
  const MasterMenuScreen({super.key});

  @override
  State<MasterMenuScreen> createState() => _MasterMenuScreenState();
}

class _MasterMenuScreenState extends State<MasterMenuScreen> {
  MenuModel? selectedMenu;

  // Map menu title với widget screen tương ứng
  Widget _getScreenForMenu(String menuTitle) {
    switch (menuTitle) {
      case 'Tổng quan':
        return const DashboardScreen();
      // Quản lý đơn hàng
      case 'Danh sách báo giá':
        return const QuoteListScreen();
      case 'Danh sách đơn hàng':
        return const OrderListScreen();
      case 'Tiến độ đơn hàng':
        return const OrderProgressScreen();
      case 'Đơn hàng xuất':
        return const OrderExportScreen();

      // Quản lý kho
      case 'Kho vật liệu':
        return const MaterialWarehouseScreen();
      case 'Kho dụng cụ':
        return const ToolWarehouseScreen();
      case 'Kho bán thành phẩm':
        return const SemiProductWarehouseScreen();

      // Quản lý master
      case 'Sản phẩm':
        return const ProductScreen();
      case 'Chi tiết':
        return const DetailScreen();
      case 'Định mức':
        return const NormScreen();
      case 'Đơn giá':
        return const ProductPriceScreen();
      case 'Công đoạn':
        return const ProcessManagementScreen();
      case 'Khách hàng':
        return const CustomerScreen();

      default:
        return _buildWelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[900]!, Colors.blue[800]!],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.dashboard_customize,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quản lý',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Hệ thống',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menu List
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: buildMenuTree(
                      menus: menuList,
                      selectedTitle: selectedMenu?.title,
                      onSelect: (menu) {
                        setState(() => selectedMenu = menu);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (selectedMenu != null) ...[
                        Icon(
                          Icons.folder_open,
                          color: Colors.blue[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          selectedMenu!.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.home_outlined,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Trang chủ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.grey[600]),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        child: Icon(Icons.person, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),

                // Content Area
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: selectedMenu == null
                        ? _buildWelcomeScreen()
                        : Container(
                            key: ValueKey(selectedMenu!.title),
                            child: _getScreenForMenu(selectedMenu!.title),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.touch_app, size: 80, color: Colors.blue[300]),
          ),
          const SizedBox(height: 24),
          Text(
            'Chào mừng đến với Hệ thống Quản lý',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vui lòng chọn menu bên trái để bắt đầu',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// ========== 3. TEMPLATE CHO CÁC SCREEN KHÁC ==========
// Copy template này cho các screen còn lại

// File: lib/screens/order/quote_list_screen.dart
class QuoteListScreen extends StatefulWidget {
  const QuoteListScreen({super.key});

  @override
  State<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  List<dynamic> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    setState(() => isLoading = true);

    // TODO: Gọi API
    // final response = await http.get('api/quotes');
    // setState(() => data = response.data);

    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Danh sách báo giá',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Thêm mới
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm mới'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDataTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('Dữ liệu sẽ hiển thị ở đây sau khi gọi API'),
      ),
    );
  }
}

// Tương tự tạo các class cho:
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Danh sách đơn hàng'));
}

class OrderProgressScreen extends StatelessWidget {
  const OrderProgressScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Tiến độ đơn hàng'));
}

class OrderExportScreen extends StatelessWidget {
  const OrderExportScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Đơn hàng xuất'));
}

class MaterialWarehouseScreen extends StatelessWidget {
  const MaterialWarehouseScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Kho vật liệu'));
}

class ToolWarehouseScreen extends StatelessWidget {
  const ToolWarehouseScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Kho dụng cụ'));
}

class SemiProductWarehouseScreen extends StatelessWidget {
  const SemiProductWarehouseScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Kho bán thành phẩm'));
}
