class OrderList {
  String statusCode;
  String message;
  List<OrderData> data;

  OrderList({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OrderList.fromJson(Map<String, dynamic> json) {
    return OrderList(
      statusCode: json['status_code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<OrderData>.from(
        json['data'].map((x) => OrderData.fromJson(x)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class OrderData {
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
  String customername;
  String customermobile;
  dynamic bottlename;
  dynamic weight;
  dynamic originalprice;
  dynamic discountprice;
  dynamic bottledescription;
  String housenumber;
  String flatnumber;
  String societyname;
  String galinumber;
  String landmark;
  String city;
  String state;
  String pincode;
  dynamic partnername;
  dynamic partnermobile;

  OrderData({
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
    required this.customername,
    required this.customermobile,
    required this.bottlename,
    required this.weight,
    required this.originalprice,
    required this.discountprice,
    required this.bottledescription,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.partnername,
    required this.partnermobile,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      ordernumber: json['ordernumber'] ?? '',
      waterbottleid: json['waterbottleid'] ?? 0,
      price: json['price']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      deliverydate: json['deliverydate'] != null
          ? DateTime.parse(json['deliverydate'])
          : DateTime.now(),
      deliverytime: json['deliverytime'] ?? '',
      addressid: json['addressid'] ?? 0,
      assignedto: json['assignedto'] ?? 0,
      status: json['status'] ?? 0,
      cdate: json['cdate'] != null
          ? DateTime.parse(json['cdate'])
          : DateTime.now(),
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'])
          : DateTime.now(),
      customername: json['customername'] ?? '',
      customermobile: json['customermobile'] ?? '',
      bottlename: json['bottlename'],
      weight: json['weight'],
      originalprice: json['originalprice'],
      discountprice: json['discountprice'],
      bottledescription: json['bottledescription'],
      housenumber: json['housenumber'] ?? '',
      flatnumber: json['flatnumber'] ?? '',
      societyname: json['societyname'] ?? '',
      galinumber: json['galinumber'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      partnername: json['partnername'],
      partnermobile: json['partnermobile'],
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
      'modifiedDate': modifiedDate.toIso8601String(),
      'customername': customername,
      'customermobile': customermobile,
      'bottlename': bottlename,
      'weight': weight,
      'originalprice': originalprice,
      'discountprice': discountprice,
      'bottledescription': bottledescription,
      'housenumber': housenumber,
      'flatnumber': flatnumber,
      'societyname': societyname,
      'galinumber': galinumber,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'partnername': partnername,
      'partnermobile': partnermobile,
    };
  }
}