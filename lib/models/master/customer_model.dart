class Customer {
  final int stt;
  final String maKhachHang;
  final String tenKhachHang;
  final String diaChi;
  final String soDienThoai;
  final String email;
  final String maSoThue;
  final DateTime? ngayTao;
  final String? nguoiTao;
  final DateTime? ngayCapNhat;
  final String? nguoiCapNhat;

  Customer({
    required this.stt,
    required this.maKhachHang,
    required this.tenKhachHang,
    required this.diaChi,
    required this.soDienThoai,
    required this.email,
    required this.maSoThue,
    this.ngayTao,
    this.nguoiTao,
    this.ngayCapNhat,
    this.nguoiCapNhat,
  });

  /// Chuyển từ JSON sang đối tượng
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      stt: json['STT'] ?? 0,
      maKhachHang: json['MaKhachHang'] ?? '',
      tenKhachHang: json['TenKhachHang'] ?? '',
      diaChi: json['DiaChi'] ?? '',
      soDienThoai: json['SoDienThoai'] ?? '',
      email: json['Email'] ?? '',
      maSoThue: json['MaSoThue'] ?? '',
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

  /// Chuyển từ đối tượng sang JSON (để gửi API)
  Map<String, dynamic> toJson() {
    return {
      'STT': stt,
      'MaKhachHang': maKhachHang,
      'TenKhachHang': tenKhachHang,
      'DiaChi': diaChi,
      'SoDienThoai': soDienThoai,
      'Email': email,
      'MaSoThue': maSoThue,
      'NgayTao': ngayTao?.toIso8601String(),
      'NguoiTao': nguoiTao,
      'NgayCapNhat': ngayCapNhat?.toIso8601String(),
      'NguoiCapNhat': nguoiCapNhat,
    };
  }

  /// Hỗ trợ clone
  Customer copyWith({
    int? stt,
    String? maKhachHang,
    String? tenKhachHang,
    String? diaChi,
    String? soDienThoai,
    String? email,
    String? maSoThue,
    DateTime? ngayTao,
    String? nguoiTao,
    DateTime? ngayCapNhat,
    String? nguoiCapNhat,
  }) {
    return Customer(
      stt: stt ?? this.stt,
      maKhachHang: maKhachHang ?? this.maKhachHang,
      tenKhachHang: tenKhachHang ?? this.tenKhachHang,
      diaChi: diaChi ?? this.diaChi,
      soDienThoai: soDienThoai ?? this.soDienThoai,
      email: email ?? this.email,
      maSoThue: maSoThue ?? this.maSoThue,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }
}
