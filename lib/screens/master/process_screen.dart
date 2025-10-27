import 'package:flutter/material.dart';
import '../../models/process_model.dart';
import '../../widgets/table_column_config.dart';

class ProcessScreen extends StatefulWidget {
  const ProcessScreen({super.key});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  List<ProcessModel> processList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Dữ liệu mẫu
    processList = [
      ProcessModel(
        stt: 1,
        maSanPham: 'SP001',
        maCongDoan: 'CD_A1',
        ngayTao: DateTime.now().subtract(const Duration(days: 3)),
        nguoiTao: 'Admin',
      ),
      ProcessModel(
        stt: 2,
        maSanPham: 'SP002',
        maCongDoan: 'CD_B2',
        ngayTao: DateTime.now().subtract(const Duration(days: 1)),
        nguoiTao: 'User1',
      ),
    ];
  }

  bool _searchFilter(ProcessModel item, String query) {
    return item.maSanPham.toLowerCase().contains(query) ||
        item.maCongDoan.toLowerCase().contains(query) ||
        (item.nguoiTao ?? '').toLowerCase().contains(query);
  }

  Future<void> _editItem(BuildContext context, ProcessModel? item) async {
    final TextEditingController maSPCtrl = TextEditingController(
      text: item?.maSanPham ?? '',
    );
    final TextEditingController maCDCtrl = TextEditingController(
      text: item?.maCongDoan ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          item == null ? 'Thêm mới quy trình' : 'Chỉnh sửa quy trình',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: maSPCtrl,
              decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
            ),
            TextField(
              controller: maCDCtrl,
              decoration: const InputDecoration(labelText: 'Mã công đoạn'),
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
                  processList.add(
                    ProcessModel(
                      stt: processList.length + 1,
                      maSanPham: maSPCtrl.text,
                      maCongDoan: maCDCtrl.text,
                      ngayTao: DateTime.now(),
                      nguoiTao: 'Admin',
                    ),
                  );
                } else {
                  final index = processList.indexOf(item);
                  processList[index] = item.copyWith(
                    maSanPham: maSPCtrl.text,
                    maCongDoan: maCDCtrl.text,
                    ngayCapNhat: DateTime.now(),
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
      body: DataTableManager<ProcessModel>(
        title: 'Danh sách Quy trình',
        items: processList,
        searchFilter: _searchFilter,
        isLoading: false,
        onEditItem: _editItem,
        rowActions: [
          RowAction<ProcessModel>(
            icon: Icons.edit,
            tooltip: 'Sửa',
            color: Colors.blue,
            onPressed: (item) => _editItem(context, item),
          ),
          RowAction<ProcessModel>(
            icon: Icons.delete,
            tooltip: 'Xóa',
            color: Colors.red,
            onPressed: (item) {
              setState(() => processList.remove(item));
            },
          ),
        ],
        columns: [
          TableColumnConfig<ProcessModel>(
            key: 'maSanPham',
            label: 'Mã sản phẩm',
            valueGetter: (item) => item.maSanPham,
          ),
          TableColumnConfig<ProcessModel>(
            key: 'maCongDoan',
            label: 'Mã công đoạn',
            valueGetter: (item) => item.maCongDoan,
          ),
          TableColumnConfig<ProcessModel>(
            key: 'nguoiTao',
            label: 'Người tạo',
            valueGetter: (item) => item.nguoiTao ?? '',
          ),
        ],
        dateColumn: DateColumnConfig<ProcessModel>(
          key: 'ngayTao',
          label: 'Ngày tạo',
          dateGetter: (item) => item.ngayTao,
        ),
      ),
    );
  }
}
