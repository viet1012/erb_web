import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;
  late List<SalesData> _chartData;
  late List<RevenueData> _revenueData;

  @override
  void initState() {
    super.initState();
    _loadData();
    _chartData = getChartData();
    _revenueData = getRevenueData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  List<SalesData> getChartData() {
    return [
      SalesData('Th1', 35),
      SalesData('Th2', 28),
      SalesData('Th3', 34),
      SalesData('Th4', 32),
      SalesData('Th5', 40),
      SalesData('Th6', 38),
      SalesData('Th7', 45),
      SalesData('Th8', 52),
      SalesData('Th9', 48),
      SalesData('Th10', 55),
      SalesData('Th11', 50),
      SalesData('Th12', 60),
    ];
  }

  List<RevenueData> getRevenueData() {
    return [
      RevenueData('Sản phẩm A', 35, Colors.blue),
      RevenueData('Sản phẩm B', 28, Colors.green),
      RevenueData('Sản phẩm C', 34, Colors.orange),
      RevenueData('Sản phẩm D', 32, Colors.red),
      RevenueData('Sản phẩm E', 40, Colors.purple),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Đơn hàng',
                  '156',
                  Icons.shopping_cart,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Doanh thu',
                  '2.5M',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Sản phẩm',
                  '89',
                  Icons.inventory,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Khách hàng',
                  '42',
                  Icons.people,
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Line Chart - Doanh thu theo tháng
          _buildChartSection(
            title: 'Doanh thu theo tháng',
            child: SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  LineSeries<SalesData, String>(
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Pie Chart - Tỷ lệ doanh thu sản phẩm
          _buildChartSection(
            title: 'Tỷ lệ doanh thu sản phẩm',
            child: SizedBox(
              height: 300,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries>[
                  PieSeries<RevenueData, String>(
                    dataSource: _revenueData,
                    xValueMapper: (RevenueData data, _) =>
                        data.product, // Sửa lỗi ở đây
                    yValueMapper: (RevenueData data, _) => data.revenue,
                    pointColorMapper: (RevenueData data, _) => data.color,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    enableTooltip: true,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Column Chart - So sánh hiệu suất
          _buildChartSection(
            title: 'So sánh hiệu suất quý',
            child: SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<SalesData, String>(
                    dataSource: _chartData.sublist(0, 4),
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    color: Colors.blue[400],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}

class RevenueData {
  final String product;
  final double revenue;
  final Color color;

  RevenueData(this.product, this.revenue, this.color);
}
