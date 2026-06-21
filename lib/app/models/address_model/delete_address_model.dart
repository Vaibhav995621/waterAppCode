class DeleteAddressModel {
  String statusCode;
  String message;
  String data;

  DeleteAddressModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DeleteAddressModel.fromJson(Map<String, dynamic> json) {
    return DeleteAddressModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data']?.toString() ?? '',
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