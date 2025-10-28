class ProcessCodeModel {
  final int stt;
  final String maCongDoan;
  final String tenCongDoan;
  final double thoiGianGiaCong;
  final DateTime? ngayTao;
  final String? nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  ProcessCodeModel({
    required this.stt,
    required this.maCongDoan,
    required this.tenCongDoan,
    required this.thoiGianGiaCong,
    this.ngayTao,
    this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  ProcessCodeModel copyWith({
    String? maCongDoan,
    String? tenCongDoan,
    double? thoiGianGiaCong,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return ProcessCodeModel(
      stt: stt,
      maCongDoan: maCongDoan ?? this.maCongDoan,
      tenCongDoan: tenCongDoan ?? this.tenCongDoan,
      thoiGianGiaCong: thoiGianGiaCong ?? this.thoiGianGiaCong,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }
}
