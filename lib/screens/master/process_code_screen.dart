import 'package:flutter/material.dart';
import '../../models/master/process_code_model.dart';
import '../../widgets/table_column_config.dart';

class ProcessCodeScreen extends StatefulWidget {
  const ProcessCodeScreen({super.key});

  @override
  State<ProcessCodeScreen> createState() => _ProcessCodeScreenState();
}

class _ProcessCodeScreenState extends State<ProcessCodeScreen> {
  List<ProcessCodeModel> processCodeList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Dữ liệu mẫu
    processCodeList = [
      ProcessCodeModel(
        stt: 1,
        maCongDoan: 'CD_A1',
        tenCongDoan: 'Gia công cơ bản',
        thoiGianGiaCong: 2.5,
        ngayTao: DateTime.now().subtract(const Duration(days: 2)),
        nguoiTao: 'Admin',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'User1',
      ),
      ProcessCodeModel(
        stt: 2,
        maCongDoan: 'CD_B2',
        tenCongDoan: 'Kiểm tra chất lượng',
        thoiGianGiaCong: 1.8,
        ngayTao: DateTime.now().subtract(const Duration(days: 1)),
        nguoiTao: 'Admin',
        ngayCapNhat: DateTime.now(),
        nguoiCapNhat: 'User2',
      ),
    ];
  }

  bool _searchFilter(ProcessCodeModel item, String query) {
    return item.maCongDoan.toLowerCase().contains(query) ||
        item.tenCongDoan.toLowerCase().contains(query) ||
        (item.nguoiTao ?? '').toLowerCase().contains(query);
  }

  Future<void> _editItem(BuildContext context, ProcessCodeModel? item) async {
    final TextEditingController maCDCtrl = TextEditingController(
      text: item?.maCongDoan ?? '',
    );
    final TextEditingController tenCDCtrl = TextEditingController(
      text: item?.tenCongDoan ?? '',
    );
    final TextEditingController thoiGianCtrl = TextEditingController(
      text: item?.thoiGianGiaCong?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          item == null ? 'Thêm mã công đoạn' : 'Chỉnh sửa mã công đoạn',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: maCDCtrl,
              decoration: const InputDecoration(labelText: 'Mã công đoạn'),
            ),
            TextField(
              controller: tenCDCtrl,
              decoration: const InputDecoration(labelText: 'Tên công đoạn'),
            ),
            TextField(
              controller: thoiGianCtrl,
              decoration: const InputDecoration(
                labelText: 'Thời gian gia công (giờ)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
                  processCodeList.add(
                    ProcessCodeModel(
                      stt: processCodeList.length + 1,
                      maCongDoan: maCDCtrl.text,
                      tenCongDoan: tenCDCtrl.text,
                      thoiGianGiaCong:
                          double.tryParse(thoiGianCtrl.text) ?? 0.0,
                      ngayTao: DateTime.now(),
                      nguoiTao: 'Admin',
                    ),
                  );
                } else {
                  final index = processCodeList.indexOf(item);
                  processCodeList[index] = item.copyWith(
                    maCongDoan: maCDCtrl.text,
                    tenCongDoan: tenCDCtrl.text,
                    thoiGianGiaCong: double.tryParse(thoiGianCtrl.text) ?? 0.0,
                    ngayCapNhat: DateTime.now(),
                    nguoiCapNhat: 'Admin',
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
      body: DataTableManager<ProcessCodeModel>(
        title: 'Danh sách Mã công đoạn',
        items: processCodeList,
        searchFilter: _searchFilter,
        isLoading: false,
        onEditItem: _editItem,
        rowActions: [
          RowAction<ProcessCodeModel>(
            icon: Icons.edit,
            tooltip: 'Sửa',
            color: Colors.blue,
            onPressed: (item) => _editItem(context, item),
          ),
          RowAction<ProcessCodeModel>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (item) {
              setState(() => processCodeList.remove(item));
            },
          ),
        ],
        columns: [
          TableColumnConfig<ProcessCodeModel>(
            key: 'stt',
            label: 'STT',
            valueGetter: (item) => item.stt.toString(),
          ),
          TableColumnConfig<ProcessCodeModel>(
            key: 'maCongDoan',
            label: 'Mã công đoạn',
            valueGetter: (item) => item.maCongDoan,
          ),
          TableColumnConfig<ProcessCodeModel>(
            key: 'tenCongDoan',
            label: 'Tên công đoạn',
            valueGetter: (item) => item.tenCongDoan,
          ),
          TableColumnConfig<ProcessCodeModel>(
            key: 'thoiGianGiaCong',
            label: 'Thời gian gia công (h)',
            valueGetter: (item) => item.thoiGianGiaCong.toString(),
          ),
          TableColumnConfig<ProcessCodeModel>(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (item) => item.nguoiTao ?? '',
          ),
          TableColumnConfig<ProcessCodeModel>(
            key: 'nguoiCapNhat',
            label: 'Người cập nhật',
            valueGetter: (item) => item.nguoiCapNhat ?? '',
          ),
        ],
        dateColumn: DateColumnConfig<ProcessCodeModel>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (item) => item.ngayTao,
        ),
      ),
    );
  }
}
