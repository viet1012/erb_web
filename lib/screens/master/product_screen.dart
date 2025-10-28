import 'package:flutter/material.dart';
import '../../models/master/product_model.dart';
import '../../widgets/table_column_config.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late List<ProductModel> _productList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _productList = [
      ProductModel(
        stt: 1,
        maSanPham: 'SP001',
        tenSanPham: 'Sản phẩm A',
        nhomSanPham: 'Nhóm 1',
        trongLuong: 12.5,
        donViTrongLuong: 'kg',
        ngayTao: DateTime(2025, 10, 1),
        nguoiTao: 'VietTa',
        ngayCapNhat: DateTime(2025, 10, 20),
        nguoiCapNhat: 'Admin',
        soLuongLenhSanXuat: 50,
      ),
      ProductModel(
        stt: 2,
        maSanPham: 'SP002',
        tenSanPham: 'Sản phẩm B',
        nhomSanPham: 'Nhóm 2',
        trongLuong: 8.2,
        donViTrongLuong: 'kg',
        ngayTao: DateTime(2025, 10, 2),
        nguoiTao: 'VietTa',
        ngayCapNhat: null,
        nguoiCapNhat: null,
        soLuongLenhSanXuat: 30,
      ),
    ];
  }

  // 👉 Hàm thêm/sửa sản phẩm được đưa vào trong class
  Future<void> _showAddOrEditProductDialog(
    BuildContext context,
    ProductModel? item,
  ) async {
    final isEditing = item != null;

    final TextEditingController maSanPhamCtrl = TextEditingController(
      text: item?.maSanPham ?? '',
    );
    final TextEditingController tenSanPhamCtrl = TextEditingController(
      text: item?.tenSanPham ?? '',
    );
    final TextEditingController nhomSanPhamCtrl = TextEditingController(
      text: item?.nhomSanPham ?? '',
    );
    final TextEditingController trongLuongCtrl = TextEditingController(
      text: item?.trongLuong.toString() ?? '',
    );
    final TextEditingController donViTrongLuongCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? '',
    );
    final TextEditingController soLuongCtrl = TextEditingController(
      text: item?.soLuongLenhSanXuat.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
              ),
              TextField(
                controller: tenSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: nhomSanPhamCtrl,
                decoration: const InputDecoration(labelText: 'Nhóm sản phẩm'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: trongLuongCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Trọng lượng',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: donViTrongLuongCtrl,
                      decoration: const InputDecoration(labelText: 'Đơn vị'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: soLuongCtrl,
                decoration: const InputDecoration(
                  labelText: 'Số lượng lệnh SX',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  final index = _productList.indexOf(item!);
                  _productList[index] = ProductModel(
                    stt: item.stt,
                    maSanPham: maSanPhamCtrl.text,
                    tenSanPham: tenSanPhamCtrl.text,
                    nhomSanPham: nhomSanPhamCtrl.text,
                    trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: item.ngayTao,
                    nguoiTao: item.nguoiTao,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: 'Admin',
                    soLuongLenhSanXuat: int.tryParse(soLuongCtrl.text) ?? 0,
                  );
                } else {
                  _productList.add(
                    ProductModel(
                      stt: _productList.length + 1,
                      maSanPham: maSanPhamCtrl.text,
                      tenSanPham: tenSanPhamCtrl.text,
                      nhomSanPham: nhomSanPhamCtrl.text,
                      trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                      donViTrongLuong: donViTrongLuongCtrl.text,
                      ngayTao: DateTime.now(),
                      nguoiTao: 'Admin',
                      ngayCapNhat: null,
                      nguoiCapNhat: null,
                      soLuongLenhSanXuat: int.tryParse(soLuongCtrl.text) ?? 0,
                    ),
                  );
                }
              });

              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataTableManager<ProductModel>(
        title: 'Danh sách Sản phẩm',
        items: _productList,
        isLoading: _isLoading,
        onRefresh: () {
          setState(() {
            _isLoading = true;
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _isLoading = false;
            });
          });
        },
        columns: [
          TableColumnConfig(
            key: 'maSanPham',
            label: 'Mã sản phẩm',
            valueGetter: (p) => p.maSanPham,
          ),
          TableColumnConfig(
            key: 'tenSanPham',
            label: 'Tên sản phẩm',
            valueGetter: (p) => p.tenSanPham,
          ),
          TableColumnConfig(
            key: 'nhomSanPham',
            label: 'Nhóm sản phẩm',
            valueGetter: (p) => p.nhomSanPham,
          ),
          TableColumnConfig(
            key: 'trongLuong',
            label: 'Trọng lượng',
            valueGetter: (p) => '${p.trongLuong} ${p.donViTrongLuong}',
          ),
          TableColumnConfig(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (p) => p.nguoiTao,
          ),
          TableColumnConfig(
            key: 'nguoiCapNhat',
            label: 'Người cập nhật',
            valueGetter: (p) => p.nguoiCapNhat ?? '',
          ),
          TableColumnConfig(
            key: 'soLuongLenhSanXuat',
            label: 'SL Lệnh SX',
            valueGetter: (p) => p.soLuongLenhSanXuat.toString(),
          ),
        ],
        dateColumn: DateColumnConfig<ProductModel>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (p) => p.ngayTao,
        ),
        rowActions: [
          RowAction<ProductModel>(
            icon: Icons.edit,
            tooltip: 'Chỉnh sửa',
            color: Colors.blue,
            onPressed: (product) =>
                _showAddOrEditProductDialog(context, product),
          ),
          RowAction<ProductModel>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (product) {
              setState(() {
                _productList.remove(product);
              });
            },
          ),
        ],
        searchFilter: (item, query) =>
            item.tenSanPham.toLowerCase().contains(query) ||
            item.maSanPham.toLowerCase().contains(query) ||
            item.nhomSanPham.toLowerCase().contains(query),
        onEditItem: (context, item) =>
            _showAddOrEditProductDialog(context, item),
      ),
    );
  }
}
