import 'package:flutter/foundation.dart';

class DetailModel {
  final int stt;
  final String maChiTiet;
  final String tenChiTiet;
  final String nhomChiTiet;
  final String donViChiTiet;
  final double trongLuong;
  final String donViTrongLuong;
  final DateTime ngayTao;
  final String nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  DetailModel({
    required this.stt,
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.nhomChiTiet,
    required this.donViChiTiet,
    required this.trongLuong,
    required this.donViTrongLuong,
    required this.ngayTao,
    required this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      stt: json['STT'] ?? 0,
      maChiTiet: json['MaChiTiet'] ?? '',
      tenChiTiet: json['TenChiTiet'] ?? '',
      nhomChiTiet: json['NhomChiTiet'] ?? '',
      donViChiTiet: json['DonVi_ChiTiet'] ?? '',
      trongLuong: (json['TrongLuong'] ?? 0).toDouble(),
      donViTrongLuong: json['DonVi_TrongLuong'] ?? '',
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
      'MaChiTiet': maChiTiet,
      'TenChiTiet': tenChiTiet,
      'NhomChiTiet': nhomChiTiet,
      'DonVi_ChiTiet': donViChiTiet,
      'TrongLuong': trongLuong,
      'DonVi_TrongLuong': donViTrongLuong,
      'NgayTao': ngayTao.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }
}
