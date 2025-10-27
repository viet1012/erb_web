import 'package:flutter/material.dart';

/// Mô hình dữ liệu cho menu có thể lồng nhiều cấp
class MenuModel {
  final String title; // Tên menu hiển thị
  final List<MenuModel> subMenus; // Danh sách menu con
  final IconData? icon; // Icon tùy chọn
  final bool isLeaf; // Có phải là menu cuối (không có con)

  MenuModel(this.title, [this.subMenus = const [], this.icon])
    : isLeaf = subMenus.isEmpty;

  /// Tìm tất cả các menu con (flatten)
  List<MenuModel> flatten() {
    List<MenuModel> all = [this];
    for (final sub in subMenus) {
      all.addAll(sub.flatten());
    }
    return all;
  }

  /// Tìm menu theo tên (dạng đệ quy)
  MenuModel? findByTitle(String name) {
    if (title == name) return this;
    for (final sub in subMenus) {
      final found = sub.findByTitle(name);
      if (found != null) return found;
    }
    return null;
  }

  /// In ra cấu trúc (debug)
  void printTree([String indent = ""]) {
    print('$indent$title');
    for (final sub in subMenus) {
      sub.printTree("$indent  └── ");
    }
  }
}

final List<MenuModel> menuList = [
  MenuModel('Tổng quan'),

  MenuModel('Quản lý đơn hàng', [
    MenuModel('Danh sách báo giá'),
    MenuModel('Danh sách đơn hàng'),
    MenuModel('Tiến độ đơn hàng'),
    MenuModel('Đơn hàng xuất'),
  ]),

  MenuModel('Quản lý kho', [
    MenuModel('Kho vật liệu'),
    MenuModel('Kho dụng cụ'),
    MenuModel('Kho bán thành phẩm'),
  ]),

  MenuModel('Quản lý master', [
    MenuModel('Sản phẩm'),
    MenuModel('Chi tiết'),
    MenuModel('Định mức'),
    MenuModel('Đơn giá'),
    MenuModel('Công đoạn', [
      MenuModel('Gia công'),
      MenuModel('Lắp ráp'),
      MenuModel('Kiểm tra'),
    ]),
    MenuModel('Khách hàng'),
  ]),
];
