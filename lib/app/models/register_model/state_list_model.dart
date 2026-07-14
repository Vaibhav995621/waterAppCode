class StateListModel {
  final String statusCode;
  final String message;
  final List<StateData> data;

  StateListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory StateListModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<StateData> dataList = list != null
        ? list.map((i) => StateData.fromJson(i)).toList()
        : [];
    return StateListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: dataList,
    );
  }
}

class StateData {
  final int id;
  final int countryId;
  final String statename;
  final String stateCode;
  final int status;

  StateData({
    required this.id,
    required this.countryId,
    required this.statename,
    required this.stateCode,
    required this.status,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      countryId: json['country_id'] is int
          ? json['country_id']
          : int.tryParse(json['country_id'].toString()) ?? 0,
      statename: json['statename']?.toString() ?? '',
      stateCode: json['state_code']?.toString() ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
