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

/// Supports both:
///   - Single order detail response: data = { ...order fields... }
///   - Order list response:           data = { all_orders: [...], pending_orders: [...], ... }
class Data {
  // Single-order detail fields (new API)
  Order? order;

  // List-based fields (existing order-list API)
  List<Order> allOrders;
  List<Order> pendingOrders;
  List<Order> assignedOrders;
  List<Order> outForDeliveryOrders;
  List<Order> deliveredOrders;
  List<Order> cancelledOrders;

  Data({
    this.order,
    required this.allOrders,
    required this.pendingOrders,
    required this.assignedOrders,
    required this.outForDeliveryOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // Detect single-order response by presence of 'id' / 'ordernumber' at root
    final isSingleOrder = json.containsKey('ordernumber') || json.containsKey('id');

    return Data(
      order: isSingleOrder ? Order.fromJson(json) : null,

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

      cancelledOrders:
      (json['cancelled_orders'] as List? ?? [])
          .map((e) => Order.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    if (order != null) {
      return order!.toJson();
    }
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
      'cancelled_orders':
      cancelledOrders.map((e) => e.toJson()).toList(),
    };
  }
}

class Order {
  // paymentmode: 0=Cash, 1=UPI, 2=Card, 3=Online
  int paymentmode;
  int id;
  int customerid;
  String ordernumber;
  int waterbottleid;
  String price;
  String bottleprice;         // base bottle price
  String floorprice;          // floor delivery charge
  String quickdeliverycharge; // quick delivery surcharge
  int quantity;
  DateTime deliverydate;
  String deliverytime;
  int addressid;
  int assignedto;
  String paymentstatus;
  int status;
  int isSchedule;             // is_schedule
  int quickDelivery;          // quick_delivery
  int custFloornumber;        // cust_floornumber
  int custIsLiftAvailable;    // cust_is_lift_available
  DateTime cdate;
  DateTime modifiedDate;
  String customerName;
  String deliveryPartnerName;
  String statusText;
  String waterbottleName;
  int deliveryPartnerId;
  CustomerDetails customerDetails;
  DeliveryDetails deliveryDetails;

  // Bottle detail fields
  String bottleWeight;
  String bottleOriginalprice;
  String bottleDiscountprice;
  int totalbottleQuantity;
  String bottleDescription;

  Order({
    required this.id,
    required this.customerid,
    required this.ordernumber,
    required this.waterbottleid,
    required this.price,
    required this.bottleprice,
    required this.floorprice,
    required this.quickdeliverycharge,
    required this.quantity,
    required this.deliverydate,
    required this.deliverytime,
    required this.addressid,
    required this.assignedto,
    required this.paymentstatus,
    required this.paymentmode,
    required this.status,
    required this.isSchedule,
    required this.quickDelivery,
    required this.custFloornumber,
    required this.custIsLiftAvailable,
    required this.cdate,
    required this.modifiedDate,
    required this.customerName,
    required this.deliveryPartnerName,
    required this.statusText,
    required this.deliveryPartnerId,
    required this.customerDetails,
    required this.deliveryDetails,
    required this.waterbottleName,
    required this.bottleWeight,
    required this.bottleOriginalprice,
    required this.bottleDiscountprice,
    required this.totalbottleQuantity,
    required this.bottleDescription,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      customerid: json['customerid'] ?? 0,
      ordernumber: json['ordernumber'] ?? '',
      waterbottleName: (json['waterbottle_name'] ?? json['waterbottel_name'] ?? json['waterbottleName'] ?? json['waterbottelName'] ?? json['waterbottlename'] ?? json['waterbottelname'] ?? json['bottle_name'] ?? json['bottel_name'] ?? json['bottleName'] ?? json['bottelName'] ?? json['name'] ?? '').toString(),
      waterbottleid: json['waterbottleid'] ?? 0,
      price: json['price']?.toString() ?? '',
      bottleprice: (json['bottleprice'] ?? json['bottle_price'] ?? json['bottlePrice'] ?? '0').toString(),
      floorprice: (json['floorprice'] ?? json['floor_price'] ?? json['floorPrice'] ?? json['floorcharges'] ?? json['floor_charges'] ?? json['floorCharges'] ?? '0').toString(),
      quickdeliverycharge: (json['quickdeliverycharge'] ??
          json['quick_delivery_charge'] ??
          json['quickDeliveryCharge'] ??
          json['quick_delivery_charges'] ??
          json['quickDeliveryCharges'] ??
          json['quickdeliverycharges'] ??
          json['fastdeliverycharges'] ??
          json['fast_delivery_charges'] ??
          json['fastDeliveryCharges'] ??
          json['fastdeliverycharge'] ??
          json['fast_delivery_charge'] ??
          json['fastDeliveryCharge'] ??
          '0').toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      deliverydate: DateTime.tryParse(
        json['deliverydate']?.toString() ?? '',
      ) ??
          DateTime.now(),
      deliverytime: json['deliverytime']?.toString() ?? '',
      addressid: int.tryParse(json['addressid']?.toString() ?? '0') ?? 0,
      assignedto: int.tryParse(json['assignedto']?.toString() ?? '0') ?? 0,
      paymentstatus: (json['paymentstatus'] ?? json['payment_status'] ?? '0').toString(),
      paymentmode: int.tryParse(json['paymentmode']?.toString() ?? '0') ?? 0,
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      isSchedule: int.tryParse((json['is_schedule'] ?? json['isSchedule'] ?? json['isschedule'] ?? '').toString()) ?? (json['is_schedule'] == true ? 1 : 0),
      quickDelivery: (int.tryParse((json['quick_delivery'] ?? json['quickDelivery'] ?? json['quickdelivery'] ?? '').toString()) ?? (json['quick_delivery'] == true ? 1 : 0)) == 1 || ((double.tryParse((json['quickdeliverycharge'] ?? json['quick_delivery_charge'] ?? json['quickDeliveryCharge'] ?? json['quick_delivery_charges'] ?? json['quickDeliveryCharges'] ?? json['quickdeliverycharges'] ?? json['fastdeliverycharges'] ?? json['fast_delivery_charges'] ?? json['fastDeliveryCharges'] ?? json['fastdeliverycharge'] ?? json['fast_delivery_charge'] ?? json['fastDeliveryCharge'] ?? '0').toString()) ?? 0) > 0) ? 1 : 0,
      custFloornumber: int.tryParse((json['cust_floornumber'] ?? json['custFloornumber'] ?? json['floor'] ?? json['floornumber'] ?? json['customer_details']?['address']?['floornumber'] ?? '').toString()) ?? 0,
      custIsLiftAvailable: int.tryParse((json['cust_is_lift_available'] ?? json['custIsLiftAvailable'] ?? json['is_lift_available'] ?? json['isLiftAvailable'] ?? json['customer_details']?['address']?['is_lift_available'] ?? '').toString()) ?? (json['cust_is_lift_available'] == true || json['is_lift_available'] == true ? 1 : 0),
      cdate: DateTime.tryParse(
        json['cdate'] ?? '',
      ) ??
          DateTime.now(),
      modifiedDate: DateTime.tryParse(
        (json['modified_date'] ?? json['modifiedDate'] ?? '').toString(),
      ) ??
          DateTime.now(),
      customerName: (json['customer_name'] ?? json['customerName'] ?? '').toString(),
      deliveryPartnerName:
          (json['delivery_partner_name'] ?? json['deliveryPartnerName'] ?? '').toString(),
      statusText: (json['status_text'] ?? json['statusText'] ?? '').toString(),
      deliveryPartnerId:
          json['delivery_partner_id'] ?? json['deliveryPartnerId'] ?? 0,
      customerDetails: CustomerDetails.fromJson(
        json['customer_details'] ?? {},
      ),
      deliveryDetails: DeliveryDetails.fromJson(
        json['delivery_details'] ?? {},
      ),
      bottleWeight: (json['bottle_weight'] ?? json['bottel_weight'] ?? json['bottleWeight'] ?? json['bottelWeight'] ?? json['bottleweight'] ?? json['bottelweight'] ?? json['weight'] ?? '').toString(),
      bottleOriginalprice: (json['bottle_originalprice'] ?? json['bottel_originalprice'] ?? json['bottleOriginalprice'] ?? json['bottelOriginalprice'] ?? json['originalprice'] ?? '').toString(),
      bottleDiscountprice: (json['bottle_discountprice'] ?? json['bottel_discountprice'] ?? json['bottleDiscountprice'] ?? json['bottelDiscountprice'] ?? json['discountprice'] ?? json['bottleprice'] ?? json['bottle_price'] ?? json['bottlePrice'] ?? '').toString(),
      totalbottleQuantity: int.tryParse((json['totalbottle_quantity'] ?? json['totalbottel_quantity'] ?? json['totalbottleQuantity'] ?? json['totalbottelQuantity'] ?? json['totalbottlequantity'] ?? json['totalbottelquantity'] ?? '').toString()) ?? 0,
      bottleDescription: (json['bottle_description'] ?? json['bottel_description'] ?? json['bottleDescription'] ?? json['bottelDescription'] ?? json['bottledescription'] ?? json['botteldescription'] ?? json['description'] ?? json['waterbottle_description'] ?? json['waterbottel_description'] ?? json['waterbottle_desc'] ?? json['waterbottel_desc'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerid': customerid,
      'ordernumber': ordernumber,
      'waterbottleid': waterbottleid,
      'price': price,
      'bottleprice': bottleprice,
      'floorprice': floorprice,
      'quickdeliverycharge': quickdeliverycharge,
      'quantity': quantity,
      'deliverydate': deliverydate.toIso8601String(),
      'deliverytime': deliverytime,
      'addressid': addressid,
      'assignedto': assignedto,
      'paymentmode': paymentmode,
      'paymentstatus': paymentstatus,
      'status': status,
      'is_schedule': isSchedule,
      'quick_delivery': quickDelivery,
      'cust_floornumber': custFloornumber,
      'cust_is_lift_available': custIsLiftAvailable,
      'cdate': cdate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
      'customer_name': customerName,
      'delivery_partner_name': deliveryPartnerName,
      'status_text': statusText,
      'delivery_partner_id': deliveryPartnerId,
      'customer_details': customerDetails.toJson(),
      'delivery_details': deliveryDetails.toJson(),
      'waterbottle_name': waterbottleName,
      'bottle_weight': bottleWeight,
      'bottle_originalprice': bottleOriginalprice,
      'bottle_discountprice': bottleDiscountprice,
      'totalbottle_quantity': totalbottleQuantity,
      'bottle_description': bottleDescription,
    };
  }
}

class CustomerDetails {
  int id;
  String fullname;
  String mobile;
  String email;
  String photo;
  int planbottlequantity;
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
    required this.planbottlequantity,
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
      planbottlequantity: json['planbottlequantity'] ?? 0,
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
      'planbottlequantity': planbottlequantity,
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
  int galinumber;          // int (was String)
  String houseFlatFloorNo; // house_flat_floor_no
  String societyGaliBlockNo; // society_gali_block_no
  int localityid;
  String sectornumber;
  int sectorid;
  String landmark;
  int stateid;
  int districtid;
  int subdivisionid;
  String subdivisionname;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;    // key: is_default_address

  Address({
    required this.fulladdress,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.houseFlatFloorNo,
    required this.societyGaliBlockNo,
    required this.localityid,
    required this.sectornumber,
    required this.sectorid,
    required this.landmark,
    required this.stateid,
    required this.districtid,
    required this.subdivisionid,
    required this.subdivisionname,
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
      housenumber: json['housenumber']?.toString() ?? '',
      flatnumber: json['flatnumber']?.toString() ?? '',
      societyname: json['societyname']?.toString() ?? '',
      galinumber: json['galinumber'] ?? 0,
      houseFlatFloorNo: json['house_flat_floor_no']?.toString() ?? '',
      societyGaliBlockNo: json['society_gali_block_no']?.toString() ?? '',
      localityid: json['localityid'] ?? 0,
      sectornumber: json['sectornumber']?.toString() ?? '',
      sectorid: json['sectorid'] ?? 0,
      landmark: json['landmark']?.toString() ?? '',
      stateid: json['stateid'] ?? 0,
      districtid: json['districtid'] ?? 0,
      subdivisionid: json['subdivisionid'] ?? 0,
      subdivisionname: json['subdivisionname'] ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      isDefaultAddress: json['is_default_address'] ?? json['isDefaultAddress'] ?? 0,
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
      'house_flat_floor_no': houseFlatFloorNo,
      'society_gali_block_no': societyGaliBlockNo,
      'localityid': localityid,
      'sectornumber': sectornumber,
      'sectorid': sectorid,
      'landmark': landmark,
      'stateid': stateid,
      'districtid': districtid,
      'subdivisionid': subdivisionid,
      'subdivisionname': subdivisionname,
      'city': city,
      'state': state,
      'pincode': pincode,
      'is_default_address': isDefaultAddress,
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