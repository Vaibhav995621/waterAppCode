class AdminOrderListModel {
  String statusCode;
  String message;
  Data data;

  AdminOrderListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AdminOrderListModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AdminOrderListModel(
      statusCode: json['status_code']?.toString() ?? '',
      message: json['message'] ?? '',
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
  List<Order> allOrders;
  List<Order> pendingOrders;
  List<Order> assignedOrders;
  List<Order> outForDeliveryOrders;
  List<Order> deliveredOrders;

  Data({
    required this.allOrders,
    required this.pendingOrders,
    required this.assignedOrders,
    required this.outForDeliveryOrders,
    required this.deliveredOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      allOrders: (json['all_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),

      pendingOrders: (json['pending_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),

      assignedOrders: (json['assigned_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),

      outForDeliveryOrders:
      (json['out_for_delivery_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),

      deliveredOrders:
      (json['delivered_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all_orders':
      allOrders.map((e) => e.toJson()).toList(),
      'pending_orders':
      pendingOrders.map((e) => e.toJson()).toList(),
      'assigned_orders':
      assignedOrders.map((e) => e.toJson()).toList(),
      'out_for_delivery_orders':
      outForDeliveryOrders.map((e) => e.toJson()).toList(),
      'delivered_orders':
      deliveredOrders.map((e) => e.toJson()).toList(),
    };
  }
}

class Order {
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
  int paymentstatus;
  int status;
  DateTime cdate;
  DateTime modifiedDate;
  String customerName;
  String deliveryPartnerName;
  String statusText;
  int deliveryPartnerId;
  CustomerDetails customerDetails;
  DeliveryDetails deliveryDetails;

  Order({
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
    required this.paymentstatus,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
    required this.customerName,
    required this.deliveryPartnerName,
    required this.statusText,
    required this.deliveryPartnerId,
    required this.customerDetails,
    required this.deliveryDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      ordernumber: json['ordernumber'] ?? '',
      waterbottleid: json['waterbottleid'] ?? 0,
      price: json['price']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      deliverydate: DateTime.tryParse(
        json['deliverydate'] ?? '',
      ) ??
          DateTime.now(),
      deliverytime: json['deliverytime'] ?? '',
      addressid: json['addressid'] ?? 0,
      assignedto: json['assignedto'] ?? 0,
      paymentstatus: json['paymentstatus'] ?? 0,
      status: json['status'] ?? 0,
      cdate: DateTime.tryParse(
        json['cdate'] ?? '',
      ) ??
          DateTime.now(),
      modifiedDate: DateTime.tryParse(
        json['modifiedDate'] ?? '',
      ) ??
          DateTime.now(),
      customerName: json['customerName'] ?? '',
      deliveryPartnerName:
      json['deliveryPartnerName'] ?? '',
      statusText: json['statusText'] ?? '',
      deliveryPartnerId:
      json['deliveryPartnerId'] ?? 0,
      customerDetails: CustomerDetails.fromJson(
        json['customer_details'] ?? {},
      ),
      deliveryDetails: DeliveryDetails.fromJson(
        json['delivery_details'] ?? {},
      ),
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
      'paymentstatus': paymentstatus,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'customerName': customerName,
      'deliveryPartnerName': deliveryPartnerName,
      'statusText': statusText,
      'deliveryPartnerId': deliveryPartnerId,
      'customer_details': customerDetails.toJson(),
      'delivery_details': deliveryDetails.toJson(),
    };
  }
}

class CustomerDetails {
  int id;
  String fullname;
  String mobile;
  String email;
  String photo;
  int status;
  DateTime cdate;
  int role;
  Address address;

  CustomerDetails({
    required this.id,
    required this.fullname,
    required this.mobile,
    required this.email,
    required this.photo,
    required this.status,
    required this.cdate,
    required this.role,
    required this.address,
  });

  factory CustomerDetails.fromJson(
      Map<String, dynamic> json,
      ) {
    return CustomerDetails(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      status: json['status'] ?? 0,
      cdate: DateTime.tryParse(
        json['cdate'] ?? '',
      ) ??
          DateTime.now(),
      role: json['role'] ?? 0,
      address: Address.fromJson(
        json['address'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'mobile': mobile,
      'email': email,
      'photo': photo,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'role': role,
      'address': address.toJson(),
    };
  }
}

class Address {
  String fulladdress;
  int floornumber;
  String housenumber;
  String flatnumber;
  String societyname;
  String galinumber;
  String sector;
  String landmark;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;

  Address({
    required this.fulladdress,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.sector,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefaultAddress,
  });

  factory Address.fromJson(
      Map<String, dynamic> json,
      ) {
    return Address(
      fulladdress: json['fulladdress'] ?? '',
      floornumber: json['floornumber'] ?? 0,
      housenumber: json['housenumber'] ?? '',
      flatnumber: json['flatnumber'] ?? '',
      societyname: json['societyname'] ?? '',
      galinumber: json['galinumber'] ?? '',
      sector: json['sector']?.toString() ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      isDefaultAddress:
      json['isDefaultAddress'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fulladdress': fulladdress,
      'floornumber': floornumber,
      'housenumber': housenumber,
      'flatnumber': flatnumber,
      'societyname': societyname,
      'galinumber': galinumber,
      'sector': sector,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isDefaultAddress': isDefaultAddress,
    };
  }
}

class DeliveryDetails {
  int deliveryPartnerId;
  String deliveryPartnerName;
  String mobileNo;
  String email;
  String photo;
  int status;
  DateTime cdate;
  int role;

  DeliveryDetails({
    required this.deliveryPartnerId,
    required this.deliveryPartnerName,
    required this.mobileNo,
    required this.email,
    required this.photo,
    required this.status,
    required this.cdate,
    required this.role,
  });

  factory DeliveryDetails.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryDetails(
      deliveryPartnerId:
      json['delivery_partner_id'] ?? 0,
      deliveryPartnerName:
      json['delivery_partner_name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      status: json['status'] ?? 0,
      cdate: DateTime.tryParse(
        json['cdate'] ?? '',
      ) ??
          DateTime.now(),
      role: json['role'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_partner_id': deliveryPartnerId,
      'delivery_partner_name': deliveryPartnerName,
      'mobile_no': mobileNo,
      'email': email,
      'photo': photo,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'role': role,
    };
  }
}