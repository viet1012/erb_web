import 'package:flutter/material.dart';
import '../../models/master/product_price_model.dart';
import '../../widgets/table_column_config.dart';

class ProductPriceScreen extends StatefulWidget {
  const ProductPriceScreen({super.key});

  @override
  State<ProductPriceScreen> createState() => _ProductPriceScreenState();
}

class _ProductPriceScreenState extends State<ProductPriceScreen> {
  late List<ProductPriceModel> _priceList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _priceList = [
      ProductPriceModel(
        stt: 1,
        maSanPham: 'SP001',
        maKhachHang: 'KH001',
        donGia: 125000,
        donViSuDung: 'VND',
        ngayTao: DateTime(2025, 10, 1),
        nguoiTao: 'VietTa',
        ngayCapNhat: DateTime(2025, 10, 10),
        nguoiCapNhat: 'Admin',
      ),
      ProductPriceModel(
        stt: 2,
        maSanPham: 'SP002',
        maKhachHang: 'KH002',
        donGia: 98000,
        donViSuDung: 'VND',
        ngayTao: DateTime(2025, 10, 2),
        nguoiTao: 'VietTa',
        ngayCapNhat: null,
        nguoiCapNhat: null,
      ),
    ];
  }

  Future<void> _onEditItem(
    BuildContext context,
    ProductPriceModel? item,
  ) async {
    // Form thêm/sửa sản phẩm
    await showDialog(
      context: context,
      builder: (context) {
        final maSPController = TextEditingController(
          text: item?.maSanPham ?? '',
        );
        final maKHController = TextEditingController(
          text: item?.maKhachHang ?? '',
        );
        final donGiaController = TextEditingController(
          text: item != null ? item.donGia.toString() : '',
        );
        final donViController = TextEditingController(
          text: item?.donViSuDung ?? '',
        );

        return AlertDialog(
          title: Text(item == null ? 'Thêm mới đơn giá' : 'Chỉnh sửa đơn giá'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: maSPController,
                  decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
                ),
                TextField(
                  controller: maKHController,
                  decoration: const InputDecoration(labelText: 'Mã khách hàng'),
                ),
                TextField(
                  controller: donGiaController,
                  decoration: const InputDecoration(labelText: 'Đơn giá'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: donViController,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị sử dụng',
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (item == null) {
                    _priceList.add(
                      ProductPriceModel(
                        stt: _priceList.length + 1,
                        maSanPham: maSPController.text,
                        maKhachHang: maKHController.text,
                        donGia: double.tryParse(donGiaController.text) ?? 0,
                        donViSuDung: donViController.text,
                        ngayTao: DateTime.now(),
                        nguoiTao: 'VietTa',
                        ngayCapNhat: null,
                        nguoiCapNhat: null,
                      ),
                    );
                  } else {
                    item.maSanPham == maSPController.text;
                    item.maKhachHang == maKHController.text;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataTableManager<ProductPriceModel>(
        title: 'Đơn giá sản phẩm',
        items: _priceList,
        isLoading: _isLoading,
        onRefresh: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _isLoading = false);
        },
        columns: [
          TableColumnConfig(
            key: 'maSanPham',
            label: 'Mã sản phẩm',
            valueGetter: (p) => p.maSanPham,
          ),
          TableColumnConfig(
            key: 'maKhachHang',
            label: 'Mã khách hàng',
            valueGetter: (p) => p.maKhachHang,
          ),
          TableColumnConfig(
            key: 'donGia',
            label: 'Đơn giá',
            valueGetter: (p) => p.donGia.toStringAsFixed(0),
          ),
          TableColumnConfig(
            key: 'donViSuDung',
            label: 'Đơn vị sử dụng',
            valueGetter: (p) => p.donViSuDung,
          ),
          TableColumnConfig(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (p) => p.nguoiTao,
          ),
        ],
        dateColumn: DateColumnConfig<ProductPriceModel>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (p) => p.ngayTao,
        ),
        rowActions: [
          RowAction<ProductPriceModel>(
            icon: Icons.edit,
            tooltip: 'Chỉnh sửa',
            color: Colors.blue,
            onPressed: (p) => _onEditItem(context, p),
          ),
          RowAction<ProductPriceModel>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (p) {
              setState(() => _priceList.remove(p));
            },
          ),
        ],
        onEditItem: _onEditItem,
        searchFilter: (item, query) =>
            item.maSanPham.toLowerCase().contains(query) ||
            item.maKhachHang.toLowerCase().contains(query),
      ),
    );
  }
}
