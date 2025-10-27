import 'package:flutter/material.dart';
import '../../models/customer_model.dart';
import '../../widgets/table_column_config.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    customers = [
      Customer(
        stt: 1,
        maKhachHang: "KH001",
        tenKhachHang: "Công ty ABC",
        diaChi: "123 Nguyễn Trãi, Hà Nội",
        soDienThoai: "0909123456",
        email: "contact@abc.vn",
        maSoThue: "0101234567",
        ngayTao: DateTime.now().subtract(const Duration(days: 5)),
        nguoiTao: "Admin",
      ),
      Customer(
        stt: 2,
        maKhachHang: "KH002",
        tenKhachHang: "Công ty XYZ",
        diaChi: "456 Trần Hưng Đạo, TP.HCM",
        soDienThoai: "0988777666",
        email: "info@xyz.com",
        maSoThue: "0309999999",
        ngayTao: DateTime.now().subtract(const Duration(days: 2)),
        nguoiTao: "Admin",
      ),
    ];
  }

  /// Hàm lọc theo từ khóa tìm kiếm
  bool _searchFilter(Customer item, String query) {
    return item.maKhachHang.toLowerCase().contains(query) ||
        item.tenKhachHang.toLowerCase().contains(query) ||
        item.soDienThoai.toLowerCase().contains(query) ||
        item.email.toLowerCase().contains(query);
  }

  /// Hàm mở dialog thêm / sửa
  Future<void> _onEditCustomer(BuildContext context, Customer? customer) async {
    final isEditing = customer != null;
    final TextEditingController maController = TextEditingController(
      text: customer?.maKhachHang ?? '',
    );
    final TextEditingController tenController = TextEditingController(
      text: customer?.tenKhachHang ?? '',
    );
    final TextEditingController diaChiController = TextEditingController(
      text: customer?.diaChi ?? '',
    );
    final TextEditingController sdtController = TextEditingController(
      text: customer?.soDienThoai ?? '',
    );
    final TextEditingController emailController = TextEditingController(
      text: customer?.email ?? '',
    );
    final TextEditingController mstController = TextEditingController(
      text: customer?.maSoThue ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Cập nhật khách hàng' : 'Thêm khách hàng mới'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: maController,
                decoration: const InputDecoration(labelText: "Mã khách hàng"),
              ),
              TextField(
                controller: tenController,
                decoration: const InputDecoration(labelText: "Tên khách hàng"),
              ),
              TextField(
                controller: diaChiController,
                decoration: const InputDecoration(labelText: "Địa chỉ"),
              ),
              TextField(
                controller: sdtController,
                decoration: const InputDecoration(labelText: "Số điện thoại"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: mstController,
                decoration: const InputDecoration(labelText: "Mã số thuế"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  final index = customers.indexOf(customer!);
                  customers[index] = customer.copyWith(
                    maKhachHang: maController.text,
                    tenKhachHang: tenController.text,
                    diaChi: diaChiController.text,
                    soDienThoai: sdtController.text,
                    email: emailController.text,
                    maSoThue: mstController.text,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: "Admin",
                  );
                } else {
                  customers.add(
                    Customer(
                      stt: customers.length + 1,
                      maKhachHang: maController.text,
                      tenKhachHang: tenController.text,
                      diaChi: diaChiController.text,
                      soDienThoai: sdtController.text,
                      email: emailController.text,
                      maSoThue: mstController.text,
                      ngayTao: DateTime.now(),
                      nguoiTao: "Admin",
                    ),
                  );
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataTableManager<Customer>(
        title: "Danh sách khách hàng",
        items: customers,
        searchFilter: _searchFilter,
        rowActions: [
          RowAction<Customer>(
            icon: Icons.edit,
            tooltip: 'Sửa',
            color: Colors.blue,
            onPressed: (item) => _onEditCustomer(context, item),
          ),
          RowAction<Customer>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (item) {
              setState(() {
                customers.remove(item);
              });
            },
          ),
        ],
        onEditItem: _onEditCustomer,
        columns: [
          TableColumnConfig<Customer>(
            key: 'maKhachHang',
            label: 'Mã KH',
            valueGetter: (c) => c.maKhachHang,
          ),
          TableColumnConfig<Customer>(
            key: 'tenKhachHang',
            label: 'Tên khách hàng',
            valueGetter: (c) => c.tenKhachHang,
          ),
          TableColumnConfig<Customer>(
            key: 'diaChi',
            label: 'Địa chỉ',
            valueGetter: (c) => c.diaChi,
          ),
          TableColumnConfig<Customer>(
            key: 'soDienThoai',
            label: 'Số điện thoại',
            valueGetter: (c) => c.soDienThoai,
          ),
          TableColumnConfig<Customer>(
            key: 'email',
            label: 'Email',
            valueGetter: (c) => c.email,
          ),
          TableColumnConfig<Customer>(
            key: 'maSoThue',
            label: 'Mã số thuế',
            valueGetter: (c) => c.maSoThue,
          ),
        ],
        dateColumn: DateColumnConfig<Customer>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (c) => c.ngayTao,
        ),
      ),
    );
  }
}
