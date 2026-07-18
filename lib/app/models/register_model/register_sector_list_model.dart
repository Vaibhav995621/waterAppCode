class RegisterSectorListModel {
  final String statusCode;
  final String message;
  final List<RegisterSectorData> data;

  RegisterSectorListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RegisterSectorListModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<RegisterSectorData> dataList = list != null
        ? list.map((i) => RegisterSectorData.fromJson(i)).toList()
        : [];
    return RegisterSectorListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }
}

class RegisterSectorData {
  final int id;
  final int stateid;
  final int districtid;
  final int subdivisionid;
  final String sectororvillagename;
  final int status;

  RegisterSectorData({
    required this.id,
    required this.stateid,
    required this.districtid,
    required this.subdivisionid,
    required this.sectororvillagename,
    required this.status,
  });

  factory RegisterSectorData.fromJson(Map<String, dynamic> json) {
    return RegisterSectorData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      stateid: json['stateid'] is int ? json['stateid'] : int.tryParse(json['stateid'].toString()) ?? 0,
      districtid: json['districtid'] is int ? json['districtid'] : int.tryParse(json['districtid'].toString()) ?? 0,
      subdivisionid: json['subdivisionid'] is int ? json['subdivisionid'] : int.tryParse(json['subdivisionid'].toString()) ?? 0,
      sectororvillagename: json['sectororvillagename']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
