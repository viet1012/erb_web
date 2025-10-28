import 'package:flutter/foundation.dart';

class ProductPriceModel {
  final int stt;
  final String maSanPham;
  final String maKhachHang;
  final double donGia;
  final String donViSuDung;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProductPriceModel({
    required this.stt,
    required this.maSanPham,
    required this.maKhachHang,
    required this.donGia,
    required this.donViSuDung,
    required this.ngayTao,
    required this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) {
    return ProductPriceModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      maKhachHang: json['MaKhachHang'] ?? '',
      donGia: (json['DonGia'] ?? 0).toDouble(),
      donViSuDung: json['DonVi_SuDung'] ?? '',
      ngayTao: DateTime.tryParse(json['NgayTao'] ?? '') ?? DateTime.now(),
      nguoiTao: json['NguoiTao'] ?? '',
      ngayCapNhat: json['NgayCapNhat'] != null
          ? DateTime.tryParse(json['NgayCapNhat'])
          : null,
      nguoiCapNhat: json['NguoiCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaSanPham': maSanPham,
      'MaKhachHang': maKhachHang,
      'DonGia': donGia,
      'DonVi_SuDung': donViSuDung,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }
}
