// product_model.dart
class ProductModel {
  final int stt;
  final String maSanPham;
  final String tenSanPham;
  final String nhomSanPham;
  final double trongLuong;
  final String donViTrongLuong;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;
  final int soLuongLenhSanXuat;

  ProductModel({
    required this.stt,
    required this.maSanPham,
    required this.tenSanPham,
    required this.nhomSanPham,
    required this.trongLuong,
    required this.donViTrongLuong,
    required this.ngayTao,
    this.ngayCapNhat,
    required this.nguoiTao,
    this.nguoiCapNhat,
    required this.soLuongLenhSanXuat,
  });
}
