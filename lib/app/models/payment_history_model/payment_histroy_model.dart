class PaymentHistoryModel {
  String statusCode;
  String message;
  List<PaymentHistoryData> data;

  PaymentHistoryModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentHistoryModel.fromJson(
      Map<String, dynamic> json) {
    return PaymentHistoryModel(
      statusCode:
      json["status_code"] ?? "",

      message:
      json["message"] ?? "",

      data:
      json["data"] == null
          ? []
          : List<PaymentHistoryData>.from(
        json["data"].map(
              (x) => PaymentHistoryData.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "message": message,
      "data":
      data.map(
            (x) => x.toJson(),
      ).toList(),
    };
  }
}

class PaymentHistoryData {
  int id;
  int customerid;
  int orderid;
  int subscriptionid;
  String totalamount;
  String transId;
  DateTime transDate;

  PaymentHistoryData({
    required this.id,
    required this.customerid,
    required this.orderid,
    required this.subscriptionid,
    required this.totalamount,
    required this.transId,
    required this.transDate,
  });

  factory PaymentHistoryData.fromJson(
      Map<String, dynamic> json) {
    return PaymentHistoryData(
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
      json["trans_date"] == null
          ? DateTime.now()
          : DateTime.parse(
        json["trans_date"],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerid": customerid,
      "orderid": orderid,
      "subscriptionid":
      subscriptionid,
      "totalamount":
      totalamount,
      "trans_id":
      transId,
      "trans_date":
      transDate.toIso8601String(),
    };
  }
}