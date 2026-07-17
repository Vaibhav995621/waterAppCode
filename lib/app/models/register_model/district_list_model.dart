class DistrictListModel {
  final String statusCode;
  final String message;
  final List<DistrictData> data;

  DistrictListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DistrictListModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<DistrictData> dataList = list != null
        ? list.map((i) => DistrictData.fromJson(i)).toList()
        : [];
    return DistrictListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }
}

class DistrictData {
  final int id;
  final int stateid;
  final String districtname;
  final int status;

  DistrictData({
    required this.id,
    required this.stateid,
    required this.districtname,
    required this.status,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      stateid: json['stateid'] is int ? json['stateid'] : int.tryParse(json['stateid'].toString()) ?? 0,
      districtname: json['districtname']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
