class RegisterLocalityListModel {
  final String statusCode;
  final String message;
  final List<RegisterLocalityData> data;

  RegisterLocalityListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RegisterLocalityListModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<RegisterLocalityData> dataList = list != null
        ? list.map((i) => RegisterLocalityData.fromJson(i)).toList()
        : [];
    return RegisterLocalityListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }
}

class RegisterLocalityData {
  final int id;
  final int stateid;
  final int districtid;
  final int subdivisionid;
  final int sectorid;
  final String localityname;
  final int status;

  RegisterLocalityData({
    required this.id,
    required this.stateid,
    required this.districtid,
    required this.subdivisionid,
    required this.sectorid,
    required this.localityname,
    required this.status,
  });

  factory RegisterLocalityData.fromJson(Map<String, dynamic> json) {
    return RegisterLocalityData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      stateid: json['stateid'] is int ? json['stateid'] : int.tryParse(json['stateid'].toString()) ?? 0,
      districtid: json['districtid'] is int ? json['districtid'] : int.tryParse(json['districtid'].toString()) ?? 0,
      subdivisionid: json['subdivisionid'] is int ? json['subdivisionid'] : int.tryParse(json['subdivisionid'].toString()) ?? 0,
      sectorid: json['sectorid'] is int ? json['sectorid'] : int.tryParse(json['sectorid'].toString()) ?? 0,
      localityname: json['localityname']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
