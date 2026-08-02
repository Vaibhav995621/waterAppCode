// =============================================================================
// PaymentHistoryModel
// Supports two API endpoints:
//   1. Admin  → GET /all-payment-history  (includes customer_details, uses
//               richer order_details / plan_details schemas)
//   2. Customer → GET /payment-history    (no customer_details; order_details
//               and plan_details use a different schema; empty fields are ""
//               instead of null)
//
// Both APIs use the key "order_details" and "plan_details".
// Absent/empty objects arrive as either null OR "" — both are handled safely.
// =============================================================================

class PaymentHistoryModel {
  String statusCode;
  String message;
  List<PaymentHistoryData> data;

  PaymentHistoryModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      statusCode: json["status_code"]?.toString() ?? "",
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<PaymentHistoryData>.from(
              json["data"].map((x) => PaymentHistoryData.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "message": message,
      "data": data.map((x) => x.toJson()).toList(),
    };
  }
}

// -----------------------------------------------------------------------------
// PaymentHistoryData
// -----------------------------------------------------------------------------

class PaymentHistoryData {
  int id;
  int customerid;
  int orderid;       // 0 when no linked order
  int subscriptionid; // 0 when no linked subscription
  String totalamount;
  int paymentmode;   // 1 = Order, 2 = Subscription/Plan, 3 = Wallet Top-up
  String transId;
  DateTime transDate;
  int status;        // 1 = Success, 0 = Pending/Failed

  /// Present only in the Admin API response.
  CustomerDetails? customerDetails;

  /// Present when paymentmode == 1 (Order payment).
  /// Handles both Admin and Customer API schemas.
  PaymentOrderDetails? orderDetails;

  /// Present when paymentmode == 2 (Plan/Subscription purchase).
  /// Handles both Admin (name/description) and Customer (planname/plandetails) schemas.
  PlanDetails? planDetails;

  /// Present when paymentmode == 3 (Wallet top-up).
  WalletDetails? walletDetails;

  PaymentHistoryData({
    required this.id,
    required this.customerid,
    required this.orderid,
    required this.subscriptionid,
    required this.totalamount,
    required this.paymentmode,
    required this.transId,
    required this.transDate,
    required this.status,
    this.customerDetails,
    this.orderDetails,
    this.planDetails,
    this.walletDetails,
  });

  /// Returns true if this transaction is a wallet top-up (paymentmode == 3)
  bool get isWalletTopUp => paymentmode == 3;

  /// Returns true if this transaction is a plan/subscription purchase (paymentmode == 2)
  bool get isSubscription => paymentmode == 2;

  /// Returns true if this transaction is an order purchase (paymentmode == 1)
  bool get isOrder => paymentmode == 1;

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) {
    // Helper: returns the raw value only when it is a Map (not null / "")
    Map<String, dynamic>? _asMap(dynamic value) =>
        value is Map<String, dynamic> ? value : null;

    return PaymentHistoryData(
      id: json["id"] ?? 0,
      customerid: json["customerid"] ?? 0,
      orderid: json["orderid"] ?? 0,
      subscriptionid: json["subscriptionid"] ?? 0,
      totalamount: json["totalamount"]?.toString() ?? "",
      paymentmode: json["paymentmode"] ?? 0,
      transId: json["trans_id"] ?? "",
      transDate: DateTime.tryParse(json["trans_date"] ?? "") ?? DateTime.now(),
      status: json["status"] ?? 0,
      customerDetails: _asMap(json["customer_details"]) != null
          ? CustomerDetails.fromJson(_asMap(json["customer_details"])!)
          : null,
      orderDetails: _asMap(json["order_details"]) != null
          ? PaymentOrderDetails.fromJson(_asMap(json["order_details"])!)
          : null,
      planDetails: _asMap(json["plan_details"]) != null
          ? PlanDetails.fromJson(_asMap(json["plan_details"])!)
          : null,
      walletDetails: _asMap(json["wallet_details"]) != null
          ? WalletDetails.fromJson(_asMap(json["wallet_details"])!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerid": customerid,
      "orderid": orderid,
      "subscriptionid": subscriptionid,
      "totalamount": totalamount,
      "paymentmode": paymentmode,
      "trans_id": transId,
      "trans_date": transDate.toIso8601String(),
      "status": status,
      "customer_details": customerDetails?.toJson(),
      "order_details": orderDetails?.toJson(),
      "plan_details": planDetails?.toJson(),
      "wallet_details": walletDetails?.toJson(),
    };
  }
}

// =============================================================================
// CustomerDetails  — Admin API only
// =============================================================================

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
  CustomerAddress? address;

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
    this.address,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json["id"] ?? 0,
      fullname: json["fullname"] ?? "",
      mobile: json["mobile"]?.toString() ?? "",
      email: json["email"] ?? "",
      photo: json["photo"] ?? "",
      planbottlequantity: json["planbottlequantity"] ?? 0,
      status: json["status"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      role: json["role"] ?? 0,
      address: json["address"] is Map<String, dynamic>
          ? CustomerAddress.fromJson(json["address"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullname": fullname,
      "mobile": mobile,
      "email": email,
      "photo": photo,
      "planbottlequantity": planbottlequantity,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "role": role,
      "address": address?.toJson(),
    };
  }
}

class CustomerAddress {
  String fulladdress;
  int floornumber;
  String housenumber;
  String flatnumber;
  String societyname;
  int galinumber;
  String houseFlatFloorNo;
  String societyGaliBlockNo;
  int localityid;
  String sectornumber;
  int sectorid;
  int sector;
  String landmark;
  int stateid;
  int districtid;
  int subdivisionid;
  String subdivisionname;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;

  CustomerAddress({
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
    required this.sector,
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

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      fulladdress: json["fulladdress"] ?? "",
      floornumber: json["floornumber"] ?? 0,
      housenumber: json["housenumber"] ?? "",
      flatnumber: json["flatnumber"] ?? "",
      societyname: json["societyname"] ?? "",
      galinumber: json["galinumber"] ?? 0,
      houseFlatFloorNo: json["house_flat_floor_no"] ?? "",
      societyGaliBlockNo: json["society_gali_block_no"] ?? "",
      localityid: json["localityid"] ?? 0,
      sectornumber: json["sectornumber"] ?? "",
      sectorid: json["sectorid"] ?? 0,
      sector: json["sector"] ?? 0,
      landmark: json["landmark"] ?? "",
      stateid: json["stateid"] ?? 0,
      districtid: json["districtid"] ?? 0,
      subdivisionid: json["subdivisionid"] ?? 0,
      subdivisionname: json["subdivisionname"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      isDefaultAddress: json["is_default_address"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fulladdress": fulladdress,
      "floornumber": floornumber,
      "housenumber": housenumber,
      "flatnumber": flatnumber,
      "societyname": societyname,
      "galinumber": galinumber,
      "house_flat_floor_no": houseFlatFloorNo,
      "society_gali_block_no": societyGaliBlockNo,
      "localityid": localityid,
      "sectornumber": sectornumber,
      "sectorid": sectorid,
      "sector": sector,
      "landmark": landmark,
      "stateid": stateid,
      "districtid": districtid,
      "subdivisionid": subdivisionid,
      "subdivisionname": subdivisionname,
      "city": city,
      "state": state,
      "pincode": pincode,
      "is_default_address": isDefaultAddress,
    };
  }
}

// =============================================================================
// PlanDetails  — maps "plan_details" key
// Merges both API schemas:
//   Admin API:    name, description, validity
//   Customer API: planname, plandetails, originalprice, bottlequantity, modified_date
// All non-common fields are nullable.
// =============================================================================

class PlanDetails {
  int id;
  int status;
  String price;
  DateTime cdate;

  // Admin API fields
  String name;         // "name" key
  String description;  // "description" key
  String validity;     // "validity" key

  // Customer API fields
  String planname;     // "planname" key (same display value as name)
  String plandetails;  // "plandetails" key
  String originalprice;// "originalprice" key
  int bottlequantity;  // "bottlequantity" key
  String modifiedDate; // "modified_date" key

  PlanDetails({
    required this.id,
    required this.status,
    required this.price,
    required this.cdate,
    this.name = "",
    this.description = "",
    this.validity = "",
    this.planname = "",
    this.plandetails = "",
    this.originalprice = "",
    this.bottlequantity = 0,
    this.modifiedDate = "",
  });

  /// Resolved display name — works for both Admin and Customer API
  String get displayName => planname.isNotEmpty ? planname : name;

  /// Resolved display description — works for both Admin and Customer API
  String get displayDetails => plandetails.isNotEmpty ? plandetails : description;

  /// Discount amount (only available from Customer API)
  double get discountAmount =>
      (double.tryParse(originalprice) ?? 0) - (double.tryParse(price) ?? 0);

  bool get hasDiscount => discountAmount > 0;

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      id: json["id"] ?? 0,
      status: json["status"] ?? 0,
      price: json["price"]?.toString() ?? "",
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      // Admin API
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      validity: json["validity"] ?? "",
      // Customer API
      planname: json["planname"] ?? "",
      plandetails: json["plandetails"] ?? "",
      originalprice: json["originalprice"]?.toString() ?? "",
      bottlequantity: json["bottlequantity"] ?? 0,
      modifiedDate: json["modified_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "price": price,
      "cdate": cdate.toIso8601String(),
      "name": name,
      "description": description,
      "validity": validity,
      "planname": planname,
      "plandetails": plandetails,
      "originalprice": originalprice,
      "bottlequantity": bottlequantity,
      "modified_date": modifiedDate,
    };
  }
}

// =============================================================================
// WalletDetails  — same structure in both APIs
// =============================================================================

class WalletDetails {
  int id;
  int userid;
  int totalamount;
  int orderamount;
  DateTime cdate;
  int newamount; // Wallet balance after this transaction

  WalletDetails({
    required this.id,
    required this.userid,
    required this.totalamount,
    required this.orderamount,
    required this.cdate,
    required this.newamount,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      id: json["id"] ?? 0,
      userid: json["userid"] ?? 0,
      totalamount: json["totalamount"] ?? 0,
      orderamount: json["orderamount"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      newamount: json["newamount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userid,
      "totalamount": totalamount,
      "orderamount": orderamount,
      "cdate": cdate.toIso8601String(),
      "newamount": newamount,
    };
  }
}

// =============================================================================
// PaymentOrderDetails  — maps "order_details" key
// Merges both API schemas:
//   Admin API:    orderdate, totalbottle, totalprice, paymenttype(String),
//                paymentstatus(String), deliveredbottle, emptybottle, mdate
//   Customer API: waterbottleid, quantity, deliverytime, addressid,
//                paymentstatus(int), paymentmode, modified_date
// Non-common fields are nullable / defaulted.
// =============================================================================

class PaymentOrderDetails {
  int id;
  int customerid;
  String ordernumber;
  String price;
  String deliverydate;
  int status;
  int assignedto;
  DateTime cdate;

  // Admin API fields
  DateTime? orderdate;    // "orderdate" key
  int totalbottle;        // "totalbottle" key
  String totalprice;      // "totalprice" key
  String paymenttype;     // "paymenttype" key
  String paymentstatusStr;// "paymentstatus" when String (Admin)
  int deliveredbottle;    // "deliveredbottle" key
  int emptybottle;        // "emptybottle" key
  String mdate;           // "mdate" key

  // Customer API fields
  int waterbottleid;      // "waterbottleid" key
  int quantity;           // "quantity" key
  String deliverytime;    // "deliverytime" key
  int addressid;          // "addressid" key
  int paymentstatusInt;   // "paymentstatus" when int (Customer)
  int paymentmode;        // "paymentmode" key
  String modifiedDate;    // "modified_date" key

  PaymentOrderDetails({
    required this.id,
    required this.customerid,
    required this.ordernumber,
    required this.price,
    required this.deliverydate,
    required this.status,
    required this.assignedto,
    required this.cdate,
    this.orderdate,
    this.totalbottle = 0,
    this.totalprice = "",
    this.paymenttype = "",
    this.paymentstatusStr = "",
    this.deliveredbottle = 0,
    this.emptybottle = 0,
    this.mdate = "",
    this.waterbottleid = 0,
    this.quantity = 0,
    this.deliverytime = "",
    this.addressid = 0,
    this.paymentstatusInt = 0,
    this.paymentmode = 0,
    this.modifiedDate = "",
  });

  factory PaymentOrderDetails.fromJson(Map<String, dynamic> json) {
    // "paymentstatus" can be a String (Admin) or int (Customer)
    final dynamic ps = json["paymentstatus"];
    final String psStr = ps is String ? ps : "";
    final int psInt = ps is int ? ps : 0;

    return PaymentOrderDetails(
      id: json["id"] ?? 0,
      customerid: json["customerid"] ?? 0,
      ordernumber: json["ordernumber"] ?? "",
      price: json["price"]?.toString() ?? "",
      deliverydate: json["deliverydate"] ?? "",
      status: json["status"] ?? 0,
      assignedto: json["assignedto"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      // Admin API
      orderdate: DateTime.tryParse(json["orderdate"] ?? ""),
      totalbottle: json["totalbottle"] ?? 0,
      totalprice: json["totalprice"]?.toString() ?? "",
      paymenttype: json["paymenttype"] ?? "",
      paymentstatusStr: psStr,
      deliveredbottle: json["deliveredbottle"] ?? 0,
      emptybottle: json["emptybottle"] ?? 0,
      mdate: json["mdate"] ?? "",
      // Customer API
      waterbottleid: json["waterbottleid"] ?? 0,
      quantity: json["quantity"] ?? 0,
      deliverytime: json["deliverytime"] ?? "",
      addressid: json["addressid"] ?? 0,
      paymentstatusInt: psInt,
      paymentmode: json["paymentmode"] ?? 0,
      modifiedDate: json["modified_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerid": customerid,
      "ordernumber": ordernumber,
      "price": price,
      "deliverydate": deliverydate,
      "status": status,
      "assignedto": assignedto,
      "cdate": cdate.toIso8601String(),
      "orderdate": orderdate?.toIso8601String(),
      "totalbottle": totalbottle,
      "totalprice": totalprice,
      "paymenttype": paymenttype,
      "paymentstatus": paymentstatusStr.isNotEmpty ? paymentstatusStr : paymentstatusInt,
      "deliveredbottle": deliveredbottle,
      "emptybottle": emptybottle,
      "mdate": mdate,
      "waterbottleid": waterbottleid,
      "quantity": quantity,
      "deliverytime": deliverytime,
      "addressid": addressid,
      "paymentmode": paymentmode,
      "modified_date": modifiedDate,
    };
  }
}