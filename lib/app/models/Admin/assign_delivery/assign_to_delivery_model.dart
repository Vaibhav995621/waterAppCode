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
    final dataVal = json['data'];
    return AssignToDeliveryModel(
      statusCode: (json['status_code'] ?? json['statusCode'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      data: Data.fromJson(dataVal is Map<String, dynamic> ? dataVal : const {}),
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
  List<int> orderIds;
  int assignedTo;
  int status;
  String statusText;

  Data({
    required this.orderIds,
    required this.assignedTo,
    required this.status,
    required this.statusText,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final List<int> ids = [];
    final rawIds = json['order_ids'] ?? json['order_id'];
    if (rawIds is List) {
      for (final item in rawIds) {
        final id = int.tryParse(item.toString());
        if (id != null) ids.add(id);
      }
    } else if (rawIds != null) {
      final id = int.tryParse(rawIds.toString());
      if (id != null) ids.add(id);
    }

    return Data(
      orderIds: ids,
      assignedTo: int.tryParse(json['assigned_to']?.toString() ?? '') ?? 0,
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      statusText: (json['status_text'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_ids': orderIds,
      'assigned_to': assignedTo,
      'status': status,
      'status_text': statusText,
    };
  }
}