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

  // Column filters
  Map<String, Set<String>> columnFilters = {
    'maKhachHang': {},
    'tenKhachHang': {},
    'diaChi': {},
    'soDienThoai': {},
    'email': {},
    'maSoThue': {},
  };

  Map<String, Set<String>> availableValues = {
    'maKhachHang': {},
    'tenKhachHang': {},
    'diaChi': {},
    'soDienThoai': {},
    'email': {},
    'maSoThue': {},
  };

  // Date range filter
  DateTime? filterFromDate;
  DateTime? filterToDate;

  @override
  void initState() {
    super.initState();
    _loadDemoData();
    searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
      _extractAvailableValues();
    });
  }

  void _extractAvailableValues() {
    availableValues['maKhachHang'] = customers
        .map((c) => c.maKhachHang)
        .toSet();
    availableValues['tenKhachHang'] = customers
        .map((c) => c.tenKhachHang)
        .toSet();
    availableValues['diaChi'] = customers.map((c) => c.diaChi).toSet();
    availableValues['soDienThoai'] = customers
        .map((c) => c.soDienThoai)
        .toSet();
    availableValues['email'] = customers.map((c) => c.email).toSet();
    availableValues['maSoThue'] = customers.map((c) => c.maSoThue).toSet();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = customers.where((customer) {
        // Text search filter
        final matchesSearch =
            query.isEmpty ||
            customer.maKhachHang.toLowerCase().contains(query) ||
            customer.tenKhachHang.toLowerCase().contains(query) ||
            customer.soDienThoai.contains(query) ||
            customer.email.toLowerCase().contains(query);

        // Column filters
        final matchesColumnFilters =
            (columnFilters['maKhachHang']!.isEmpty ||
                columnFilters['maKhachHang']!.contains(customer.maKhachHang)) &&
            (columnFilters['tenKhachHang']!.isEmpty ||
                columnFilters['tenKhachHang']!.contains(
                  customer.tenKhachHang,
                )) &&
            (columnFilters['diaChi']!.isEmpty ||
                columnFilters['diaChi']!.contains(customer.diaChi)) &&
            (columnFilters['soDienThoai']!.isEmpty ||
                columnFilters['soDienThoai']!.contains(customer.soDienThoai)) &&
            (columnFilters['email']!.isEmpty ||
                columnFilters['email']!.contains(customer.email)) &&
            (columnFilters['maSoThue']!.isEmpty ||
                columnFilters['maSoThue']!.contains(customer.maSoThue));

        // Date range filter
        final matchesDateRange =
            (filterFromDate == null ||
                customer.ngayTao!.isAfter(
                  filterFromDate!.subtract(const Duration(days: 1)),
                )) &&
            (filterToDate == null ||
                customer.ngayTao!.isBefore(
                  filterToDate!.add(const Duration(days: 1)),
                ));

        return matchesSearch && matchesColumnFilters && matchesDateRange;
      }).toList();
    });
  }

  void _showColumnFilter(String columnName, String columnTitle) {
    final tempSelected = Set<String>.from(columnFilters[columnName]!);
    final searchController = TextEditingController();
    List<String> filteredValues = availableValues[columnName]!.toList()..sort();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.filter_list, size: 20),
                const SizedBox(width: 8),
                Text('Lọc: $columnTitle'),
              ],
            ),
            content: SizedBox(
              width: 400,
              height: 500,
              child: Column(
                children: [
                  // Search trong filter
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        if (value.isEmpty) {
                          filteredValues = availableValues[columnName]!.toList()
                            ..sort();
                        } else {
                          filteredValues =
                              availableValues[columnName]!
                                  .where(
                                    (v) => v.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ),
                                  )
                                  .toList()
                                ..sort();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Select All / Clear All
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            tempSelected.addAll(filteredValues);
                          });
                        },
                        icon: const Icon(Icons.check_box, size: 18),
                        label: const Text('Chọn tất cả'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            tempSelected.removeAll(filteredValues);
                          });
                        },
                        icon: const Icon(
                          Icons.check_box_outline_blank,
                          size: 18,
                        ),
                        label: const Text('Bỏ chọn'),
                      ),
                    ],
                  ),
                  const Divider(),
                  // List of values
                  Expanded(
                    child: ListView(
                      children: filteredValues.map((value) {
                        final isSelected = tempSelected.contains(value);
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                          value: isSelected,
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked == true) {
                                tempSelected.add(value);
                              } else {
                                tempSelected.remove(value);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    columnFilters[columnName] = {};
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Xóa bộ lọc'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    columnFilters[columnName] = tempSelected;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDateFilter() {
    DateTime? tempFromDate = filterFromDate;
    DateTime? tempToDate = filterToDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.date_range, size: 20),
                SizedBox(width: 8),
                Text('Lọc: Ngày tạo'),
              ],
            ),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Từ ngày'),
                    subtitle: Text(
                      tempFromDate != null
                          ? DateFormat('dd/MM/yyyy').format(tempFromDate!)
                          : 'Chưa chọn',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempFromDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          tempFromDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: const Text('Đến ngày'),
                    subtitle: Text(
                      tempToDate != null
                          ? DateFormat('dd/MM/yyyy').format(tempToDate!)
                          : 'Chưa chọn',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempToDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          tempToDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    filterFromDate = null;
                    filterToDate = null;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Xóa bộ lọc'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filterFromDate = tempFromDate;
                    filterToDate = tempToDate;
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: const Text('Áp dụng'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      columnFilters.forEach((key, value) {
        value.clear();
      });
      filterFromDate = null;
      filterToDate = null;
      searchController.clear();
      _applyFilters();
    });
  }

  bool _hasActiveFilters() {
    return columnFilters.values.any((set) => set.isNotEmpty) ||
        filterFromDate != null ||
        filterToDate != null;
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
                _extractAvailableValues();
                _applyFilters();
              });

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
                _extractAvailableValues();
                _applyFilters();
              });

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng import Excel đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _exportExcel() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng export Excel đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildFilterableColumnLabel(String label, String columnName) {
    final hasFilter = columnFilters[columnName]!.isNotEmpty;
    return InkWell(
      onTap: () => _showColumnFilter(columnName, label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(
            hasFilter ? Icons.filter_alt : Icons.filter_alt_outlined,
            size: 16,
            color: hasFilter ? Colors.blue[700] : Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterLabel() {
    final hasFilter = filterFromDate != null || filterToDate != null;
    return InkWell(
      onTap: _showDateFilter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ngày tạo', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Icon(
            hasFilter ? Icons.filter_alt : Icons.filter_alt_outlined,
            size: 16,
            color: hasFilter ? Colors.blue[700] : Colors.grey[600],
          ),
        ],
      ),
    );
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
              if (_hasActiveFilters())
                IconButton(
                  onPressed: _clearAllFilters,
                  icon: const Icon(Icons.filter_alt_off),
                  tooltip: 'Xóa tất cả bộ lọc',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[700],
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
                  : filteredCustomers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy khách hàng nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (_hasActiveFilters()) ...[
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: _clearAllFilters,
                              icon: const Icon(Icons.filter_alt_off),
                              label: const Text('Xóa bộ lọc'),
                            ),
                          ],
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Colors.blue[50],
                          ),
                          columns: [
                            const DataColumn(
                              label: Text(
                                'STT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Mã KH',
                                'maKhachHang',
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Tên khách hàng',
                                'tenKhachHang',
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Địa chỉ',
                                'diaChi',
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Số điện thoại',
                                'soDienThoai',
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Email',
                                'email',
                              ),
                            ),
                            DataColumn(
                              label: _buildFilterableColumnLabel(
                                'Mã số thuế',
                                'maSoThue',
                              ),
                            ),
                            DataColumn(label: _buildDateFilterLabel()),
                            const DataColumn(
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
