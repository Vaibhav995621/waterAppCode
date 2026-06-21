class AddOrderModel {
  String statusCode;
  String message;
  Data data;

  AddOrderModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddOrderModel.fromJson(Map<String, dynamic> json) {
    return AddOrderModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
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
  int id;
  int customerid;
  String ordernumber;
  int waterbottleid;
  String price;
  int quantity;
  DateTime deliverydate;
  String deliverytime;
  int addressid;
  int assignedto;
  int status;
  DateTime cdate;
  DateTime modifiedDate;

  Data({
    required this.id,
    required this.customerid,
    required this.ordernumber,
    required this.waterbottleid,
    required this.price,
    required this.quantity,
    required this.deliverydate,
    required this.deliverytime,
    required this.addressid,
    required this.assignedto,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      ordernumber: json['ordernumber']?.toString() ?? '',
      waterbottleid: json['waterbottleid'] ?? 0,
      price: json['price']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      deliverydate: DateTime.tryParse(
          json['deliverydate']?.toString() ?? '') ??
          DateTime.now(),
      deliverytime: json['deliverytime']?.toString() ?? '',
      addressid: json['addressid'] ?? 0,
      assignedto: json['assignedto'] ?? 0,
      status: json['status'] ?? 0,
      cdate:
      DateTime.tryParse(json['cdate']?.toString() ?? '') ??
          DateTime.now(),
      modifiedDate: DateTime.tryParse(
          json['modified_date']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerid': customerid,
      'ordernumber': ordernumber,
      'waterbottleid': waterbottleid,
      'price': price,
      'quantity': quantity,
      'deliverydate': deliverydate.toIso8601String(),
      'deliverytime': deliverytime,
      'addressid': addressid,
      'assignedto': assignedto,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
    };
  }
}