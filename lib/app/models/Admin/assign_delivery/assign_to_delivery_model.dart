class AssignToDeliveryModel {
  String statusCode;
  String message;
  Data data;

  AssignToDeliveryModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AssignToDeliveryModel.fromJson(Map<String, dynamic> json) {
    return AssignToDeliveryModel(
      statusCode: json['status_code'] ?? '',
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  int orderId;
  int assignedTo;
  int status;
  String statusText;

  Data({
    required this.orderId,
    required this.assignedTo,
    required this.status,
    required this.statusText,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      orderId: json['order_id'] ?? 0,
      assignedTo: json['assigned_to'] ?? 0,
      status: json['status'] ?? 0,
      statusText: json['status_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'assigned_to': assignedTo,
      'status': status,
      'status_text': statusText,
    };
  }
}