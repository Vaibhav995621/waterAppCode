class BottleModel {
  String statusCode;
  String message;
  List<BottleData> data;

  BottleModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BottleModel.fromJson(Map<String, dynamic> json) {
    return BottleModel(
      statusCode: json['status_code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] == null
          ? []
          : List<BottleData>.from(
        json['data'].map((x) => BottleData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class BottleData {
  int id;
  int plantype;
  String bottlename;
  String weight;
  String originalprice;
  String discountprice;
  int quantity;
  String description;
  String photo;
  int status;
  DateTime cdate;
  DateTime modifiedDate;

  BottleData({
    required this.id,
    required this.plantype,
    required this.bottlename,
    required this.weight,
    required this.originalprice,
    required this.discountprice,
    required this.quantity,
    required this.description,
    required this.photo,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
  });

  factory BottleData.fromJson(Map<String, dynamic> json) {
    return BottleData(
      id: json['id'] ?? 0,
      plantype: json['plantype'] ?? 0,
      bottlename: json['bottlename'] ?? '',
      weight: json['weight'] ?? '',
      originalprice: json['originalprice'] ?? '',
      discountprice: json['discountprice'] ?? '',
      quantity: json['quantity'] ?? 0,
      description: json['description'] ?? '',
      photo: json['photo'] ?? '',
      status: json['status'] ?? 0,
      cdate: DateTime.parse(json['cdate']),
      modifiedDate: DateTime.parse(json['modified_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantype': plantype,
      'bottlename': bottlename,
      'weight': weight,
      'originalprice': originalprice,
      'discountprice': discountprice,
      'quantity': quantity,
      'description': description,
      'photo': photo,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
    };
  }
}