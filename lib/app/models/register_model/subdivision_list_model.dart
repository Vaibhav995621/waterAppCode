class SubdivisionListModel {
  final String statusCode;
  final String message;
  final List<SubdivisionData> data;

  SubdivisionListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SubdivisionListModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<SubdivisionData> dataList = list != null
        ? list.map((i) => SubdivisionData.fromJson(i)).toList()
        : [];
    return SubdivisionListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }
}

class SubdivisionData {
  final int id;
  final int stateid;
  final int districtid;
  final String subdivisionname;
  final String pincode;
  final int status;

  SubdivisionData({
    required this.id,
    required this.stateid,
    required this.districtid,
    required this.subdivisionname,
    required this.pincode,
    required this.status,
  });

  factory SubdivisionData.fromJson(Map<String, dynamic> json) {
    return SubdivisionData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      stateid: json['stateid'] is int ? json['stateid'] : int.tryParse(json['stateid'].toString()) ?? 0,
      districtid: json['districtid'] is int ? json['districtid'] : int.tryParse(json['districtid'].toString()) ?? 0,
      subdivisionname: json['subdivisionname']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
