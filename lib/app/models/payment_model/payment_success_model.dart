class PaymentSuccessModel {
  String statusCode;
  String message;
  Data data;

  PaymentSuccessModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentSuccessModel.fromJson(
      Map<String, dynamic> json) {
    return PaymentSuccessModel(
      statusCode:
      json["status_code"] ?? "",
      message:
      json["message"] ?? "",
      data: Data.fromJson(
        json["data"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code":
      statusCode,
      "message":
      message,
      "data":
      data.toJson(),
    };
  }
}

class Data {
  int id;
  int customerid;
  int orderid;
  int subscriptionid;
  String totalamount;
  String transId;
  DateTime? transDate;

  Data({
    required this.id,
    required this.customerid,
    required this.orderid,
    required this.subscriptionid,
    required this.totalamount,
    required this.transId,
    this.transDate,
  });

  factory Data.fromJson(
      Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,

      customerid:
      json["customerid"] ?? 0,

      orderid:
      json["orderid"] ?? 0,

      subscriptionid:
      json["subscriptionid"] ?? 0,

      totalamount:
      json["totalamount"] ?? "",

      transId:
      json["trans_id"] ?? "",

      transDate:
      json["trans_date"] != null
          ? DateTime.parse(
          json["trans_date"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerid":
      customerid,
      "orderid":
      orderid,
      "subscriptionid":
      subscriptionid,
      "totalamount":
      totalamount,
      "trans_id":
      transId,
      "trans_date":
      transDate
          ?.toIso8601String(),
    };
  }
}