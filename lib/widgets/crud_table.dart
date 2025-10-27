import 'package:flutter/material.dart';
import '../services/excel_service.dart';

class CrudTable extends StatefulWidget {
  final String title;

  const CrudTable({super.key, required this.title});

  @override
  State<CrudTable> createState() => _CrudTableState();
}

class _CrudTableState extends State<CrudTable> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    data = List.generate(5, (i) => {'id': i + 1, 'name': '${widget.title} $i'});
  }

  void addItem() {
    final newId = data.length + 1;
    setState(() {
      data.add({'id': newId, 'name': '${widget.title} $newId'});
    });
  }

  void editItem(int index) async {
    final controller = TextEditingController(text: data[index]['name']);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chỉnh sửa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Tên'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        data[index]['name'] = result;
      });
    }
  }

  void deleteItem(int index) {
    setState(() {
      data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              Row(
                children: [
                  _buildButton(
                    Icons.file_upload,
                    'Import',
                    () => ExcelService.importExcel(context, widget.title),
                  ),
                  const SizedBox(width: 8),
                  _buildButton(
                    Icons.file_download,
                    'Export',
                    () => ExcelService.exportExcel(context, widget.title),
                  ),
                  const SizedBox(width: 8),
                  _buildButton(Icons.add, 'Thêm', addItem),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Tên')),
                    DataColumn(label: Text('Hành động')),
                  ],
                  rows: List.generate(
                    data.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text(data[index]['id'].toString())),
                        DataCell(Text(data[index]['name'])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => editItem(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteItem(index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
