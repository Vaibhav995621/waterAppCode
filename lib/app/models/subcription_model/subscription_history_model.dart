import 'package:intl/intl.dart';

class SubscriptionHistoryModel {
  String statusCode;
  String message;
  List<SubscriptionData> data;

  SubscriptionHistoryModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryModel(
      statusCode: json['status_code'] ?? '', // API returned status_code
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubscriptionData.fromJson(e))
          .toList() ?? [],
    );
  }
}

class SubscriptionData {
  int id;
  int customerid;
  int orderid;
  int subscriptionid;
  String totalamount;
  String transId;
  DateTime transDate;
  int status;
  OrderDetails? orderDetails; // Changed from String to Object?
  SubscriptionDetails? subscriptionDetails; // Changed to Nullable?

  SubscriptionData({
    required this.id,
    required this.customerid,
    required this.orderid,
    required this.subscriptionid,
    required this.totalamount,
    required this.transId,
    required this.transDate,
    required this.status,
    this.orderDetails,
    this.subscriptionDetails,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      orderid: json['orderid'] ?? 0,
      subscriptionid: json['subscriptionid'] ?? 0,
      totalamount: json['totalamount']?.toString() ?? '0',
      transId: json['trans_id'] ?? 'N/A',
      transDate: json['trans_date'] != null
          ? (DateTime.tryParse(json['trans_date']) ?? DateTime.now())
          : DateTime.now(),
      status: json['status'] ?? 0,
      orderDetails: json['order_details'] != null && json['order_details'] is Map
          ? OrderDetails.fromJson(json['order_details'])
          : null,
      subscriptionDetails: json['subscription_details'] != null && json['subscription_details'] is Map
          ? SubscriptionDetails.fromJson(json['subscription_details'])
          : null,
    );
  }
}

class SubscriptionDetails {
  int id;
  String planname;
  String plandetails;
  String originalprice;
  String price;
  int bottlequantity;
  int status;
  DateTime cdate;
  DateTime modifiedDate;

  SubscriptionDetails({
    required this.id,
    required this.planname,
    required this.plandetails,
    required this.originalprice,
    required this.price,
    required this.bottlequantity,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      id: json['id'] ?? 0,
      planname: json['planname'] ?? '',
      plandetails: json['plandetails'] ?? '',
      originalprice: json['originalprice']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      bottlequantity: json['bottlequantity'] ?? 0,
      status: json['status'] ?? 0,
      cdate: DateTime.tryParse(json['cdate'] ?? '') ?? DateTime.now(),
      modifiedDate: DateTime.tryParse(json['modified_date'] ?? '') ?? DateTime.now(),
    );
  }
}

class OrderDetails {
  int id;
  int customerid;
  String ordernumber;
  int waterbottleid;
  String price;
  int quantity;
  String deliverydate;
  String deliverytime;
  int addressid;
  int? assignedto;
  int paymentstatus;
  int status;

  OrderDetails({
    required this.id,
    required this.customerid,
    required this.ordernumber,
    required this.waterbottleid,
    required this.price,
    required this.quantity,
    required this.deliverydate,
    required this.deliverytime,
    required this.addressid,
    this.assignedto,
    required this.paymentstatus,
    required this.status,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      ordernumber: json['ordernumber'] ?? '',
      waterbottleid: json['waterbottleid'] ?? 0,
      price: json['price']?.toString() ?? '0',
      quantity: json['quantity'] ?? 0,
      deliverydate: json['deliverydate'] ?? '',
      deliverytime: json['deliverytime'] ?? '',
      addressid: json['addressid'] ?? 0,
      assignedto: json['assignedto'],
      paymentstatus: json['paymentstatus'] ?? 0,
      status: json['status'] ?? 0,
    );
  }
}