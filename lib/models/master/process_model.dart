class ProcessModel {
  final int stt;
  final String maSanPham;
  final String maCongDoan;
  final DateTime? ngayTao;
  final String? nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProcessModel({
    required this.stt,
    required this.maSanPham,
    required this.maCongDoan,
    this.ngayTao,
    this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  /// Chuyển JSON → Object
  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      stt: json['STT'] ?? 0,
      maSanPham: json['MaSanPham'] ?? '',
      maCongDoan: json['MaCongDoan'] ?? '',
      ngayTao: json['NgayTao'] != null
          ? DateTime.tryParse(json['NgayTao'])
          : null,
      nguoiTao: json['NguoiTao'],
      ngayCapNhat: json['NgayCapNhat'] != null
          ? DateTime.tryParse(json['NgayCapNhat'])
          : null,
      nguoiCapNhat: json['NguoiCapNhat'],
    );
  }

  /// Chuyển Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaSanPham': maSanPham,
      'MaCongDoan': maCongDoan,
      'NgayTao': ngayTao?.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  /// Tạo bản sao mới (copy)
  ProcessModel copyWith({
    int? stt,
    String? maSanPham,
    String? maCongDoan,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return ProcessModel(
      stt: stt ?? this.stt,
      maSanPham: maSanPham ?? this.maSanPham,
      maCongDoan: maCongDoan ?? this.maCongDoan,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }
}
