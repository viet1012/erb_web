import 'package:flutter/material.dart';

import '../../models/master/detail_model.dart';
import '../../widgets/table_column_config.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<DetailModel> _details;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _details = [
      DetailModel(
        stt: 1,
        maChiTiet: 'CT001',
        tenChiTiet: 'Chi tiết A',
        nhomChiTiet: 'Nhóm 1',
        donViChiTiet: 'Cái',
        trongLuong: 1.5,
        donViTrongLuong: 'kg',
        ngayTao: DateTime(2025, 10, 10),
        nguoiTao: 'VietTa',
        ngayCapNhat: DateTime(2025, 10, 20),
        nguoiCapNhat: 'Admin',
      ),
      DetailModel(
        stt: 2,
        maChiTiet: 'CT002',
        tenChiTiet: 'Chi tiết B',
        nhomChiTiet: 'Nhóm 2',
        donViChiTiet: 'Cái',
        trongLuong: 2.0,
        donViTrongLuong: 'kg',
        ngayTao: DateTime(2025, 10, 15),
        nguoiTao: 'VietTa',
        ngayCapNhat: null,
        nguoiCapNhat: null,
      ),
    ];
  }

  Future<void> _showAddOrEditDialog(
    BuildContext context,
    DetailModel? item,
  ) async {
    final isEditing = item != null;

    final maCtrl = TextEditingController(text: item?.maChiTiet ?? '');
    final tenCtrl = TextEditingController(text: item?.tenChiTiet ?? '');
    final nhomCtrl = TextEditingController(text: item?.nhomChiTiet ?? '');
    final donViChiTietCtrl = TextEditingController(
      text: item?.donViChiTiet ?? '',
    );
    final trongLuongCtrl = TextEditingController(
      text: item?.trongLuong.toString() ?? '',
    );
    final donViTrongLuongCtrl = TextEditingController(
      text: item?.donViTrongLuong ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa chi tiết' : 'Thêm chi tiết mới'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: maCtrl,
                  decoration: const InputDecoration(labelText: 'Mã chi tiết'),
                ),
                TextField(
                  controller: tenCtrl,
                  decoration: const InputDecoration(labelText: 'Tên chi tiết'),
                ),
                TextField(
                  controller: nhomCtrl,
                  decoration: const InputDecoration(labelText: 'Nhóm chi tiết'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: trongLuongCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Trọng lượng',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: donViTrongLuongCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Đơn vị trọng lượng',
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: donViChiTietCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Đơn vị chi tiết',
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
              setState(() {
                if (isEditing) {
                  final index = _details.indexOf(item!);
                  _details[index] = DetailModel(
                    stt: item.stt,
                    maChiTiet: maCtrl.text,
                    tenChiTiet: tenCtrl.text,
                    nhomChiTiet: nhomCtrl.text,
                    donViChiTiet: donViChiTietCtrl.text,
                    trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                    donViTrongLuong: donViTrongLuongCtrl.text,
                    ngayTao: item.ngayTao,
                    nguoiTao: item.nguoiTao,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: 'Admin',
                  );
                } else {
                  _details.add(
                    DetailModel(
                      stt: _details.length + 1,
                      maChiTiet: maCtrl.text,
                      tenChiTiet: tenCtrl.text,
                      nhomChiTiet: nhomCtrl.text,
                      donViChiTiet: donViChiTietCtrl.text,
                      trongLuong: double.tryParse(trongLuongCtrl.text) ?? 0,
                      donViTrongLuong: donViTrongLuongCtrl.text,
                      ngayTao: DateTime.now(),
                      nguoiTao: 'Admin',
                      ngayCapNhat: null,
                      nguoiCapNhat: null,
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
      body: DataTableManager<DetailModel>(
        title: 'Danh sách Chi tiết',
        items: _details,
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
            key: 'maChiTiet',
            label: 'Mã chi tiết',
            valueGetter: (d) => d.maChiTiet,
          ),
          TableColumnConfig(
            key: 'tenChiTiet',
            label: 'Tên chi tiết',
            valueGetter: (d) => d.tenChiTiet,
          ),
          TableColumnConfig(
            key: 'nhomChiTiet',
            label: 'Nhóm chi tiết',
            valueGetter: (d) => d.nhomChiTiet,
          ),
          TableColumnConfig(
            key: 'donViChiTiet',
            label: 'Đơn vị chi tiết',
            valueGetter: (d) => d.donViChiTiet,
          ),
          TableColumnConfig(
            key: 'trongLuong',
            label: 'Trọng lượng',
            valueGetter: (d) => '${d.trongLuong} ${d.donViTrongLuong}',
          ),
          TableColumnConfig(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (d) => d.nguoiTao,
          ),
          TableColumnConfig(
            key: 'nguoiCapNhat',
            label: 'Người cập nhật',
            valueGetter: (d) => d.nguoiCapNhat ?? '',
          ),
        ],
        dateColumn: DateColumnConfig<DetailModel>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (d) => d.ngayTao,
        ),
        rowActions: [
          RowAction<DetailModel>(
            icon: Icons.edit,
            tooltip: 'Chỉnh sửa',
            color: Colors.blue,
            onPressed: (item) => _showAddOrEditDialog(context, item),
          ),
          RowAction<DetailModel>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (item) {
              setState(() {
                _details.remove(item);
              });
            },
          ),
        ],
        searchFilter: (item, query) =>
            item.tenChiTiet.toLowerCase().contains(query) ||
            item.maChiTiet.toLowerCase().contains(query) ||
            item.nhomChiTiet.toLowerCase().contains(query),
        onEditItem: (context, item) => _showAddOrEditDialog(context, item),
      ),
    );
  }
}
