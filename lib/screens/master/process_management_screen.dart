import 'package:flutter/material.dart';
import 'process_screen.dart';
import 'process_code_screen.dart';

class ProcessManagementScreen extends StatefulWidget {
  const ProcessManagementScreen({super.key});

  @override
  State<ProcessManagementScreen> createState() =>
      _ProcessManagementScreenState();
}

class _ProcessManagementScreenState extends State<ProcessManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue[700],
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.blue[700],
              unselectedLabelColor: Colors.grey[500],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Quy trình'),
                Tab(text: 'Mã công đoạn'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ProcessScreen(), ProcessCodeScreen()],
      ),
    );
  }
}
