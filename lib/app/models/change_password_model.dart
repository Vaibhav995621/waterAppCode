class ChangePasswordModel {
  final String statusCode;
  final String message;
  final dynamic data;

  ChangePasswordModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data,
    };
  }
}
