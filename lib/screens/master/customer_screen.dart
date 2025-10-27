import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/customer_model.dart';

// import '../services/customer_service.dart'; // Uncomment khi có API

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDemoData();
    searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Demo data - Thay bằng API call sau
  void _loadDemoData() {
    setState(() {
      customers = List.generate(
        10,
        (i) => Customer(
          stt: i + 1,
          maKhachHang: 'KH${(i + 1).toString().padLeft(4, '0')}',
          tenKhachHang: 'Khách hàng ${i + 1}',
          diaChi: 'Địa chỉ ${i + 1}, Quận ${(i % 12) + 1}, TP.HCM',
          soDienThoai: '090${(1000000 + i).toString()}',
          email: 'customer${i + 1}@example.com',
          maSoThue: '${1234567890 + i}',
          ngayTao: DateTime.now().subtract(Duration(days: i * 10)),
          nguoiTao: 'Admin',
          ngayCapNhat: DateTime.now().subtract(Duration(days: i * 5)),
          nguoiCapNhat: 'Admin',
        ),
      );
      filteredCustomers = customers;
    });
  }

  // TODO: Thay bằng API call thật
  /*
  Future<void> _fetchCustomers() async {
    setState(() => isLoading = true);
    try {
      final data = await CustomerService.getAll();
      setState(() {
        customers = data;
        filteredCustomers = data;
      });
    } catch (e) {
      _showErrorDialog('Lỗi tải dữ liệu: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }
  */

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = customers.where((customer) {
        return customer.maKhachHang.toLowerCase().contains(query) ||
            customer.tenKhachHang.toLowerCase().contains(query) ||
            customer.soDienThoai.contains(query) ||
            customer.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showAddDialog() {
    _showCustomerDialog(null);
  }

  void _showEditDialog(Customer customer) {
    _showCustomerDialog(customer);
  }

  void _showCustomerDialog(Customer? customer) {
    final isEdit = customer != null;
    final maKHController = TextEditingController(
      text: customer?.maKhachHang ?? '',
    );
    final tenKHController = TextEditingController(
      text: customer?.tenKhachHang ?? '',
    );
    final diaChiController = TextEditingController(
      text: customer?.diaChi ?? '',
    );
    final sdtController = TextEditingController(
      text: customer?.soDienThoai ?? '',
    );
    final emailController = TextEditingController(text: customer?.email ?? '');
    final mstController = TextEditingController(text: customer?.maSoThue ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Chỉnh sửa khách hàng' : 'Thêm khách hàng mới'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: maKHController,
                  decoration: const InputDecoration(
                    labelText: 'Mã khách hàng *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tenKHController,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: diaChiController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: sdtController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: mstController,
                  decoration: const InputDecoration(
                    labelText: 'Mã số thuế',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (maKHController.text.isEmpty || tenKHController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập đầy đủ thông tin bắt buộc'),
                  ),
                );
                return;
              }

              final newCustomer = Customer(
                stt: isEdit ? customer.stt : customers.length + 1,
                maKhachHang: maKHController.text,
                tenKhachHang: tenKHController.text,
                diaChi: diaChiController.text,
                soDienThoai: sdtController.text,
                email: emailController.text,
                maSoThue: mstController.text,
                ngayTao: customer?.ngayTao ?? DateTime.now(),
                nguoiTao: customer?.nguoiTao ?? 'Admin',
                ngayCapNhat: DateTime.now(),
                nguoiCapNhat: 'Admin',
              );

              setState(() {
                if (isEdit) {
                  final index = customers.indexWhere(
                    (c) => c.stt == customer.stt,
                  );
                  customers[index] = newCustomer;
                } else {
                  customers.add(newCustomer);
                }
                _filterCustomers();
              });

              // TODO: Call API để lưu
              // await CustomerService.save(newCustomer);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEdit ? 'Cập nhật thành công' : 'Thêm mới thành công',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
          ),
        ],
      ),
    );
  }

  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
          'Bạn có chắc chắn muốn xóa khách hàng "${customer.tenKhachHang}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                customers.removeWhere((c) => c.stt == customer.stt);
                _filterCustomers();
              });

              // TODO: Call API để xóa
              // await CustomerService.delete(customer.stt);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Xóa thành công'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _importExcel() async {
    // TODO: Implement import Excel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng import Excel đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );

    /* Implement với file_picker và excel packages:
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    
    if (result != null) {
      final bytes = result.files.first.bytes;
      final excel = Excel.decodeBytes(bytes!);
      
      List<Customer> importedCustomers = [];
      for (var row in excel.tables[excel.tables.keys.first]!.rows.skip(1)) {
        importedCustomers.add(Customer.fromExcelRow(row));
      }
      
      setState(() {
        customers.addAll(importedCustomers);
        _filterCustomers();
      });
    }
    */
  }

  Future<void> _exportExcel() async {
    // TODO: Implement export Excel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng export Excel đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );

    /* Implement với excel package:
    var excel = Excel.createExcel();
    var sheet = excel['Customers'];
    
    // Header
    sheet.appendRow([
      'STT', 'Mã KH', 'Tên KH', 'Địa chỉ', 'SĐT', 
      'Email', 'MST', 'Ngày tạo', 'Người tạo'
    ]);
    
    // Data
    for (var customer in customers) {
      sheet.appendRow([
        customer.stt,
        customer.maKhachHang,
        customer.tenKhachHang,
        customer.diaChi,
        customer.soDienThoai,
        customer.email,
        customer.maSoThue,
        customer.ngayTao?.toString(),
        customer.nguoiTao,
      ]);
    }
    
    // Save file
    final bytes = excel.encode()!;
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'customers_${DateTime.now().millisecondsSinceEpoch}.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);
    */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quản lý khách hàng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                    Icons.file_upload,
                    'Import Excel',
                    Colors.green,
                    _importExcel,
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.file_download,
                    'Export Excel',
                    Colors.blue,
                    _exportExcel,
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.add,
                    'Thêm mới',
                    Colors.blue[700]!,
                    _showAddDialog,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo mã, tên, SĐT, email...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  'Tổng: ${filteredCustomers.length} khách hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Table
          Expanded(
            child: Container(
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.blue[50],
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'STT',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Mã KH',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tên khách hàng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Địa chỉ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Số điện thoại',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Mã số thuế',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ngày tạo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Hành động',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: filteredCustomers.map((customer) {
                          return DataRow(
                            cells: [
                              DataCell(Text(customer.stt.toString())),
                              DataCell(Text(customer.maKhachHang)),
                              DataCell(
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    customer.tenKhachHang,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    customer.diaChi,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(customer.soDienThoai)),
                              DataCell(Text(customer.email)),
                              DataCell(Text(customer.maSoThue)),
                              DataCell(
                                Text(
                                  customer.ngayTao != null
                                      ? DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(customer.ngayTao!)
                                      : '',
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      tooltip: 'Sửa',
                                      onPressed: () =>
                                          _showEditDialog(customer),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Xóa',
                                      onPressed: () =>
                                          _deleteCustomer(customer),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
