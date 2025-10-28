class NormModel {
  final int stt;
  final String maSanPham;
  final String tenSanPham;
  final String maChiTiet;
  final String tenChiTiet;
  final String suDung;
  final String donViSuDung;
  final String ngayTao;
  final String nguoiTao;
  final String ngayCapNhat;
  final String nguoiCapNhat;

  NormModel({
    required this.stt,
    required this.maSanPham,
    required this.tenSanPham,
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.suDung,
    required this.donViSuDung,
    required this.ngayTao,
    required this.nguoiTao,
    required this.ngayCapNhat,
    required this.nguoiCapNhat,
  });

  factory NormModel.fromJson(Map<String, dynamic> json) {
    return NormModel(
      stt: json['stt'] ?? 0,
      maSanPham: json['maSanPham'] ?? '',
      tenSanPham: json['tenSanPham'] ?? '',
      maChiTiet: json['maChiTiet'] ?? '',
      tenChiTiet: json['tenChiTiet'] ?? '',
      suDung: json['suDung'] ?? '',
      donViSuDung: json['donViSuDung'] ?? '',
      ngayTao: json['ngayTao'] ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      ngayCapNhat: json['ngayCapNhat'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stt': stt,
      'maSanPham': maSanPham,
      'tenSanPham': tenSanPham,
      'maChiTiet': maChiTiet,
      'tenChiTiet': tenChiTiet,
      'suDung': suDung,
      'donViSuDung': donViSuDung,
      'ngayTao': ngayTao,
      'nguoiTao': nguoiTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiCapNhat': nguoiCapNhat,
    };
  }
}
