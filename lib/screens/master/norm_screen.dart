import 'package:flutter/material.dart';

import '../../models/master/norm_model.dart';
import '../../widgets/table_column_config.dart';

class NormScreen extends StatefulWidget {
  const NormScreen({super.key});

  @override
  State<NormScreen> createState() => _NormScreenState();
}

class _NormScreenState extends State<NormScreen> {
  List<NormModel> normList = [
    NormModel(
      stt: 1,
      maSanPham: "SP001",
      tenSanPham: "Sản phẩm A",
      maChiTiet: "CT001",
      tenChiTiet: "Chi tiết A1",
      suDung: "Có",
      donViSuDung: "Cái",
      ngayTao: "2025-10-27",
      nguoiTao: "admin",
      ngayCapNhat: "2025-10-27",
      nguoiCapNhat: "admin",
    ),
  ];

  /// ===========================
  /// Tìm kiếm theo từ khóa
  /// ===========================
  bool _searchFilter(NormModel item, String query) {
    return item.maSanPham.toLowerCase().contains(query) ||
        item.tenSanPham.toLowerCase().contains(query) ||
        item.maChiTiet.toLowerCase().contains(query) ||
        item.tenChiTiet.toLowerCase().contains(query);
  }

  /// ===========================
  /// Thêm hoặc sửa Norm
  /// ===========================
  Future<void> _onEditItem(BuildContext context, NormModel? item) async {
    final isNew = item == null;

    final maSanPhamController = TextEditingController(
      text: item?.maSanPham ?? '',
    );
    final tenSanPhamController = TextEditingController(
      text: item?.tenSanPham ?? '',
    );
    final maChiTietController = TextEditingController(
      text: item?.maChiTiet ?? '',
    );
    final tenChiTietController = TextEditingController(
      text: item?.tenChiTiet ?? '',
    );
    final suDungController = TextEditingController(text: item?.suDung ?? '');
    final donViSuDungController = TextEditingController(
      text: item?.donViSuDung ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isNew ? "Thêm mới Norm" : "Cập nhật Norm"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: maSanPhamController,
                decoration: const InputDecoration(labelText: "Mã sản phẩm"),
              ),
              TextField(
                controller: tenSanPhamController,
                decoration: const InputDecoration(labelText: "Tên sản phẩm"),
              ),
              TextField(
                controller: maChiTietController,
                decoration: const InputDecoration(labelText: "Mã chi tiết"),
              ),
              TextField(
                controller: tenChiTietController,
                decoration: const InputDecoration(labelText: "Tên chi tiết"),
              ),
              TextField(
                controller: suDungController,
                decoration: const InputDecoration(labelText: "Sử dụng"),
              ),
              TextField(
                controller: donViSuDungController,
                decoration: const InputDecoration(labelText: "Đơn vị sử dụng"),
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
              final newItem = NormModel(
                stt: isNew ? normList.length + 1 : item!.stt,
                maSanPham: maSanPhamController.text,
                tenSanPham: tenSanPhamController.text,
                maChiTiet: maChiTietController.text,
                tenChiTiet: tenChiTietController.text,
                suDung: suDungController.text,
                donViSuDung: donViSuDungController.text,
                ngayTao: item?.ngayTao ?? DateTime.now().toIso8601String(),
                nguoiTao: item?.nguoiTao ?? "admin",
                ngayCapNhat: DateTime.now().toIso8601String(),
                nguoiCapNhat: "admin",
              );

              setState(() {
                if (isNew) {
                  normList.add(newItem);
                } else {
                  final index = normList.indexOf(item!);
                  normList[index] = newItem;
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
      body: DataTableManager<NormModel>(
        title: "Danh sách Norm",
        items: normList,
        searchFilter: _searchFilter,
        rowActions: [
          RowAction<NormModel>(
            icon: Icons.edit,
            tooltip: "Sửa",
            color: Colors.blue,
            onPressed: (item) => _onEditItem(context, item),
          ),
          RowAction<NormModel>(
            icon: Icons.delete,
            tooltip: "Xóa",
            color: Colors.red,
            onPressed: (item) {
              setState(() => normList.remove(item));
            },
          ),
        ],
        onEditItem: _onEditItem,
        columns: [
          TableColumnConfig(
            key: 'maSanPham',
            label: 'Mã sản phẩm',
            valueGetter: (item) => item.maSanPham,
          ),
          TableColumnConfig(
            key: 'tenSanPham',
            label: 'Tên sản phẩm',
            valueGetter: (item) => item.tenSanPham,
          ),
          TableColumnConfig(
            key: 'maChiTiet',
            label: 'Mã chi tiết',
            valueGetter: (item) => item.maChiTiet,
          ),
          TableColumnConfig(
            key: 'tenChiTiet',
            label: 'Tên chi tiết',
            valueGetter: (item) => item.tenChiTiet,
          ),
          TableColumnConfig(
            key: 'suDung',
            label: 'Sử dụng',
            valueGetter: (item) => item.suDung,
          ),
          TableColumnConfig(
            key: 'donViSuDung',
            label: 'Đơn vị sử dụng',
            valueGetter: (item) => item.donViSuDung,
          ),
          TableColumnConfig(
            key: 'ngayTao',
            label: 'Ngày tạo',
            valueGetter: (item) => item.ngayTao,
          ),
          TableColumnConfig(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (item) => item.nguoiTao,
          ),
          TableColumnConfig(
            key: 'ngayCapNhat',
            label: 'Ngày cập nhật',
            valueGetter: (item) => item.ngayCapNhat,
          ),
          TableColumnConfig(
            key: 'nguoiCapNhat',
            label: 'Người cập nhật',
            valueGetter: (item) => item.nguoiCapNhat,
          ),
        ],
      ),
    );
  }
}
