class NotificationModel {
  final String statusCode;
  final String message;
  final List<NotificationData> data;

  NotificationModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<NotificationData> dataList = list != null
        ? list.map((i) => NotificationData.fromJson(i)).toList()
        : [];

    return NotificationModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.map((i) => i.toJson()).toList(),
    };
  }
}

class NotificationData {
  final int id;
  final String title;
  final String message;
  final int status;
  final String cdate;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.status,
    required this.cdate,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : (int.tryParse(json['status']?.toString() ?? '0') ?? 0),
      cdate: json['cdate']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'status': status,
      'cdate': cdate,
    };
  }
}
