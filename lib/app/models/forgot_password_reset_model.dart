class ForgotPasswordResetModel {
  final String statusCode;
  final String message;

  ForgotPasswordResetModel({
    required this.statusCode,
    required this.message,
  });

  factory ForgotPasswordResetModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResetModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
