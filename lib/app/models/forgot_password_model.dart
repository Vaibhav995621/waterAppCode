class ForgotPasswordModel {
  final String statusCode;
  final String message;
  final ForgotPasswordData? data;

  ForgotPasswordModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null ? ForgotPasswordData.fromJson(json['data']) : null,
    );
  }
}

class ForgotPasswordData {
  final int otp;

  ForgotPasswordData({
    required this.otp,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      otp: json['otp'] is int ? json['otp'] : int.tryParse(json['otp'].toString()) ?? 0,
    );
  }
}
