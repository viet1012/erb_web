import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý hệ thống',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MasterMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MasterMenuScreen extends StatefulWidget {
  const MasterMenuScreen({super.key});

  @override
  State<MasterMenuScreen> createState() => _MasterMenuScreenState();
}

class _MasterMenuScreenState extends State<MasterMenuScreen> {
  String? selectedMainMenu;
  String? selectedSubMenu;

  final Map<String, List<String>> menuStructure = {
    'Tổng quan': [],
    'Quản lý đơn hàng': [
      'Danh sách báo giá',
      'Danh sách đơn hàng',
      'Tiến độ đơn hàng',
      'Đơn hàng xuất',
    ],
    'Quản lý kho': ['Kho vật liệu', 'Kho dụng cụ', 'Kho bán thành phẩm'],
    'Quản lý master': [
      'Sản phẩm',
      'Chi tiết',
      'Định mức',
      'Đơn giá',
      'Công đoạn',
      'Khách hàng',
    ],
  };

  // Dữ liệu CRUD demo cho mỗi SubMenu
  final Map<String, List<Map<String, dynamic>>> data = {};

  @override
  void initState() {
    super.initState();
    for (var subs in menuStructure.values) {
      for (var sub in subs) {
        data[sub] = List.generate(5, (i) => {'id': i + 1, 'name': '$sub $i'});
      }
    }
  }

  void addItem(String subMenu) {
    final newId = (data[subMenu]?.length ?? 0) + 1;
    final newItem = {'id': newId, 'name': '$subMenu $newId'};
    setState(() {
      data[subMenu]?.add(newItem);
    });
  }

  void editItem(String subMenu, int index) async {
    final controller = TextEditingController(
      text: data[subMenu]![index]['name'],
    );
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
        data[subMenu]![index]['name'] = result;
      });
    }
  }

  void deleteItem(String subMenu, int index) {
    setState(() {
      data[subMenu]?.removeAt(index);
    });
  }

  void importExcel(String subMenu) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import file: ${file.path} (giả lập)')),
      );
    }
  }

  void exportExcel(String subMenu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export $subMenu ra Excel (giả lập)')),
    );
  }

  Widget buildCrudContent(String subMenu) {
    final list = data[subMenu] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => importExcel(subMenu),
                child: const Text('Import Excel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => exportExcel(subMenu),
                child: const Text('Export Excel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => addItem(subMenu),
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Tên')),
                DataColumn(label: Text('Hành động')),
              ],
              rows: List.generate(
                list.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text(list[index]['id'].toString())),
                    DataCell(Text(list[index]['name'])),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => editItem(subMenu, index),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => deleteItem(subMenu, index),
                            icon: const Icon(Icons.delete),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final subMenus = selectedMainMenu != null
        ? menuStructure[selectedMainMenu]!
        : <String>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý hệ thống')),
      body: Row(
        children: [
          // Menu chính bên trái
          Container(
            width: 200,
            color: Colors.blueGrey.shade50,
            child: ListView(
              children: menuStructure.keys.map((menu) {
                final isSelected = selectedMainMenu == menu;
                return ListTile(
                  title: Text(menu),
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedMainMenu = menu;
                      selectedSubMenu = null;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          // Menu phụ
          Container(
            width: 200,
            color: Colors.grey.shade100,
            child: selectedMainMenu == null || subMenus.isEmpty
                ? const Center(child: Text('Chọn menu chính'))
                : ListView(
                    children: subMenus.map((sub) {
                      final isSelected = selectedSubMenu == sub;
                      return ListTile(
                        title: Text(sub),
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedSubMenu = sub;
                          });
                        },
                      );
                    }).toList(),
                  ),
          ),

          // Nội dung chính
          Expanded(
            child: selectedSubMenu == null
                ? const Center(
                    child: Text('Chọn menu con để hiển thị nội dung'),
                  )
                : buildCrudContent(selectedSubMenu!),
          ),
        ],
      ),
    );
  }
}
