class SubscriptionModel {
  String statusCode;
  String message;
  List<SubscriptionData> data;

  SubscriptionModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SubscriptionModel.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionModel(
      statusCode: json["status_code"] ?? "",
      message: json["message"] ?? "",
      data: json["data"] != null
          ? List<SubscriptionData>.from(
        json["data"].map(
              (x) => SubscriptionData.fromJson(x),
        ),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "message": message,
      "data":
      data.map((x) => x.toJson()).toList(),
    };
  }
}

class SubscriptionData {
  int id;
  String planname;
  String plandetails;
  String originalprice;
  String price;
  int bottlequantity;
  int status;
  DateTime cdate;
  DateTime modifiedDate;
  int totalsave;
  double rateperbottle;

  SubscriptionData({
    required this.id,
    required this.planname,
    required this.plandetails,
    required this.originalprice,
    required this.price,
    required this.bottlequantity,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
    required this.totalsave,
    required this.rateperbottle,
  });

  factory SubscriptionData.fromJson(
      Map<String, dynamic> json) {
    return SubscriptionData(
      id: json["id"] ?? 0,
      planname: json["planname"] ?? "",
      plandetails:
      json["plandetails"] ?? "",
      originalprice:
      json["originalprice"] ?? "",
      price: json["price"] ?? "",
      bottlequantity:
      json["bottlequantity"] ?? 0,
      status: json["status"] ?? 0,
      cdate: json["cdate"] != null
          ? DateTime.parse(
        json["cdate"],
      )
          : DateTime.now(),
      modifiedDate:
      json["modifiedDate"] != null
          ? DateTime.parse(
        json["modifiedDate"],
      )
          : DateTime.now(),
      totalsave:
      json["totalsave"] ?? 0,
      rateperbottle:
      (json["rateperbottle"] ?? 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "planname": planname,
      "plandetails": plandetails,
      "originalprice":
      originalprice,
      "price": price,
      "bottlequantity":
      bottlequantity,
      "status": status,
      "cdate":
      cdate.toIso8601String(),
      "modifiedDate":
      modifiedDate
          .toIso8601String(),
      "totalsave": totalsave,
      "rateperbottle":
      rateperbottle,
    };
  }
}