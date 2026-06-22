class SectorListModel {
  String statusCode;
  String message;
  List<String> data;

  SectorListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SectorListModel.fromJson(Map<String, dynamic> json) {
    return SectorListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message'] ?? '',
      data: json['data'] == null
          ? []
          : List<String>.from(json['data'].map((x) => x.toString())),
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
