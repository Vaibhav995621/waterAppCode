class ScheduleListModel {
  final bool status;
  final String message;
  final List<ScheduleData> data;

  ScheduleListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) {
    return ScheduleListModel(
      status: json['status'] == true || json['status'].toString() == '1' || json['status'].toString().toLowerCase() == 'true',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is List
          ? List<ScheduleData>.from(
              json['data'].map((x) => ScheduleData.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class ScheduleData {
  final int id;
  final int customerid;
  final int waterbottleid;
  final int orderquantity;
  final int totalquantity;
  final double unitprice;
  final double totalamount;
  final int subscriptiontype;
  final String? substypevalue;
  final String? startdate;
  final String? enddate;
  final int addressid;
  final int paymentmode;
  final int paymentstatus;
  final int status;
  final int subscriptionduration;
  final String? createdAt;
  final WaterbottleDetails? waterbottleDetails;
  final ScheduleCustomer? customer;
  final ScheduleAddress? address;

  ScheduleData({
    required this.id,
    required this.customerid,
    required this.waterbottleid,
    required this.orderquantity,
    required this.totalquantity,
    required this.unitprice,
    required this.totalamount,
    required this.subscriptiontype,
    this.substypevalue,
    this.startdate,
    this.enddate,
    required this.addressid,
    required this.paymentmode,
    required this.paymentstatus,
    required this.status,
    required this.subscriptionduration,
    this.createdAt,
    this.waterbottleDetails,
    this.customer,
    this.address,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      customerid: int.tryParse(json['customerid']?.toString() ?? '0') ?? 0,
      waterbottleid: int.tryParse(json['waterbottleid']?.toString() ?? '0') ?? 0,
      orderquantity: int.tryParse(json['orderquantity']?.toString() ?? '0') ?? 0,
      totalquantity: int.tryParse(json['totalquantity']?.toString() ?? '0') ?? 0,
      unitprice: double.tryParse(json['unitprice']?.toString() ?? '0') ?? 0.0,
      totalamount: double.tryParse(json['totalamount']?.toString() ?? '0') ?? 0.0,
      subscriptiontype: int.tryParse(json['subscriptiontype']?.toString() ?? '0') ?? 0,
      substypevalue: json['substypevalue']?.toString(),
      startdate: json['startdate']?.toString(),
      enddate: json['enddate']?.toString(),
      addressid: int.tryParse(json['addressid']?.toString() ?? '0') ?? 0,
      paymentmode: int.tryParse(json['paymentmode']?.toString() ?? '0') ?? 0,
      paymentstatus: int.tryParse(json['paymentstatus']?.toString() ?? '0') ?? 0,
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      subscriptionduration: int.tryParse(json['subscriptionduration']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at']?.toString(),
      waterbottleDetails: json['waterbottle_details'] != null
          ? WaterbottleDetails.fromJson(json['waterbottle_details'])
          : null,
      customer: json['customer'] != null
          ? ScheduleCustomer.fromJson(json['customer'])
          : null,
      address: json['address'] != null
          ? ScheduleAddress.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerid': customerid,
        'waterbottleid': waterbottleid,
        'orderquantity': orderquantity,
        'totalquantity': totalquantity,
        'unitprice': unitprice,
        'totalamount': totalamount,
        'subscriptiontype': subscriptiontype,
        'substypevalue': substypevalue,
        'startdate': startdate,
        'enddate': enddate,
        'addressid': addressid,
        'paymentmode': paymentmode,
        'paymentstatus': paymentstatus,
        'status': status,
        'subscriptionduration': subscriptionduration,
        'created_at': createdAt,
        'waterbottle_details': waterbottleDetails?.toJson(),
        'customer': customer?.toJson(),
        'address': address?.toJson(),
      };

  String get subscriptionTypeLabel {
    switch (subscriptiontype) {
      case 1:
        return 'Daily';
      case 2:
        return 'Weekly';
      case 3:
        return 'Custom';
      default:
        return 'Schedule';
    }
  }

  String get paymentModeLabel {
    switch (paymentmode) {
      case 0:
        return 'COD';
      case 1:
        return 'Online';
      case 2:
        return 'Subscription';
      case 3:
        return 'Wallet';
      default:
        return 'Online';
    }
  }

  String get paymentStatusLabel {
    return paymentstatus == 1 ? 'Paid' : 'Pending';
  }

  String get statusLabel {
    switch (status) {
      case 1:
        return 'Active';
      case 2:
        return 'Completed';
      default:
        return 'Pending';
    }
  }
}

class WaterbottleDetails {
  final int id;
  final int plantype;
  final int usertype;
  final String? bottlename;
  final String? weight;
  final String? originalprice;
  final String? discountprice;
  final int quantity;
  final String? description;
  final String? photo;
  final int? floorChanges;
  final int status;
  final String? cdate;
  final String? modifiedDate;

  WaterbottleDetails({
    required this.id,
    required this.plantype,
    required this.usertype,
    this.bottlename,
    this.weight,
    this.originalprice,
    this.discountprice,
    required this.quantity,
    this.description,
    this.photo,
    this.floorChanges,
    required this.status,
    this.cdate,
    this.modifiedDate,
  });

  factory WaterbottleDetails.fromJson(Map<String, dynamic> json) {
    return WaterbottleDetails(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      plantype: int.tryParse(json['plantype']?.toString() ?? '0') ?? 0,
      usertype: int.tryParse(json['usertype']?.toString() ?? '0') ?? 0,
      bottlename: json['bottlename']?.toString(),
      weight: json['weight']?.toString(),
      originalprice: json['originalprice']?.toString(),
      discountprice: json['discountprice']?.toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      photo: json['photo']?.toString(),
      floorChanges: json['floorChanges'] != null
          ? int.tryParse(json['floorChanges'].toString())
          : null,
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      cdate: json['cdate']?.toString(),
      modifiedDate: json['modified_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plantype': plantype,
        'usertype': usertype,
        'bottlename': bottlename,
        'weight': weight,
        'originalprice': originalprice,
        'discountprice': discountprice,
        'quantity': quantity,
        'description': description,
        'photo': photo,
        'floorChanges': floorChanges,
        'status': status,
        'cdate': cdate,
        'modified_date': modifiedDate,
      };
}

class ScheduleCustomer {
  final int id;
  final int usertype;
  final int plantype;
  final String? username;
  final String? fullname;
  final double walletamount;
  final String? mobile;
  final String? fulladdress;
  final int? floornumber;
  final String? housenumber;
  final String? flatnumber;
  final String? societyname;
  final int? galinumber;
  final String? houseFlatFloorNo;
  final String? societyGaliBlockNo;
  final int? isLiftAvailable;
  final String? sectornumber;
  final String? landmark;
  final String? city;
  final String? state;
  final String? email;
  final String? pincode;
  final int? planbottlequantity;
  final int? status;
  final String? cdate;
  final int? role;
  final String? modifiedDate;

  ScheduleCustomer({
    required this.id,
    required this.usertype,
    required this.plantype,
    this.username,
    this.fullname,
    required this.walletamount,
    this.mobile,
    this.fulladdress,
    this.floornumber,
    this.housenumber,
    this.flatnumber,
    this.societyname,
    this.galinumber,
    this.houseFlatFloorNo,
    this.societyGaliBlockNo,
    this.isLiftAvailable,
    this.sectornumber,
    this.landmark,
    this.city,
    this.state,
    this.email,
    this.pincode,
    this.planbottlequantity,
    this.status,
    this.cdate,
    this.role,
    this.modifiedDate,
  });

  factory ScheduleCustomer.fromJson(Map<String, dynamic> json) {
    return ScheduleCustomer(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      usertype: int.tryParse(json['usertype']?.toString() ?? '0') ?? 0,
      plantype: int.tryParse(json['plantype']?.toString() ?? '0') ?? 0,
      username: json['username']?.toString(),
      fullname: json['fullname']?.toString(),
      walletamount: double.tryParse(json['walletamount']?.toString() ?? '0') ?? 0.0,
      mobile: json['mobile']?.toString(),
      fulladdress: json['fulladdress']?.toString(),
      floornumber: json['floornumber'] != null ? int.tryParse(json['floornumber'].toString()) : null,
      housenumber: json['housenumber']?.toString(),
      flatnumber: json['flatnumber']?.toString(),
      societyname: json['societyname']?.toString(),
      galinumber: json['galinumber'] != null ? int.tryParse(json['galinumber'].toString()) : null,
      houseFlatFloorNo: json['house_flat_floor_no']?.toString(),
      societyGaliBlockNo: json['society_gali_block_no']?.toString(),
      isLiftAvailable: json['is_lift_available'] != null ? int.tryParse(json['is_lift_available'].toString()) : null,
      sectornumber: json['sectornumber']?.toString(),
      landmark: json['landmark']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      email: json['email']?.toString(),
      pincode: json['pincode']?.toString(),
      planbottlequantity: json['planbottlequantity'] != null ? int.tryParse(json['planbottlequantity'].toString()) : null,
      status: json['status'] != null ? int.tryParse(json['status'].toString()) : null,
      cdate: json['cdate']?.toString(),
      role: json['role'] != null ? int.tryParse(json['role'].toString()) : null,
      modifiedDate: json['modified_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usertype': usertype,
        'plantype': plantype,
        'username': username,
        'fullname': fullname,
        'walletamount': walletamount,
        'mobile': mobile,
        'fulladdress': fulladdress,
        'floornumber': floornumber,
        'housenumber': housenumber,
        'flatnumber': flatnumber,
        'societyname': societyname,
        'galinumber': galinumber,
        'house_flat_floor_no': houseFlatFloorNo,
        'society_gali_block_no': societyGaliBlockNo,
        'is_lift_available': isLiftAvailable,
        'sectornumber': sectornumber,
        'landmark': landmark,
        'city': city,
        'state': state,
        'email': email,
        'pincode': pincode,
        'planbottlequantity': planbottlequantity,
        'status': status,
        'cdate': cdate,
        'role': role,
        'modified_date': modifiedDate,
      };
}

class ScheduleAddress {
  final int id;
  final int userid;
  final String? fulladdress;
  final int? floornumber;
  final String? housenumber;
  final String? flatnumber;
  final String? societyname;
  final int? galinumber;
  final int? isLiftAvailable;
  final String? houseFlatFloorNo;
  final String? societyGaliBlockNo;
  final int? localityid;
  final String? localityids;
  final String? sectornumber;
  final int? sectorid;
  final String? sectorids;
  final String? landmark;
  final int? stateid;
  final int? districtid;
  final int? subdivisionid;
  final String? subdivisionname;
  final int? sector;
  final String? block;
  final String? city;
  final String? state;
  final String? pincode;
  final int? isDefaultAddress;
  final int? assignedstatus;
  final int? status;
  final String? cdate;
  final String? modifiedDate;

  ScheduleAddress({
    required this.id,
    required this.userid,
    this.fulladdress,
    this.floornumber,
    this.housenumber,
    this.flatnumber,
    this.societyname,
    this.galinumber,
    this.isLiftAvailable,
    this.houseFlatFloorNo,
    this.societyGaliBlockNo,
    this.localityid,
    this.localityids,
    this.sectornumber,
    this.sectorid,
    this.sectorids,
    this.landmark,
    this.stateid,
    this.districtid,
    this.subdivisionid,
    this.subdivisionname,
    this.sector,
    this.block,
    this.city,
    this.state,
    this.pincode,
    this.isDefaultAddress,
    this.assignedstatus,
    this.status,
    this.cdate,
    this.modifiedDate,
  });

  factory ScheduleAddress.fromJson(Map<String, dynamic> json) {
    return ScheduleAddress(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userid: int.tryParse(json['userid']?.toString() ?? '0') ?? 0,
      fulladdress: json['fulladdress']?.toString(),
      floornumber: json['floornumber'] != null ? int.tryParse(json['floornumber'].toString()) : null,
      housenumber: json['housenumber']?.toString(),
      flatnumber: json['flatnumber']?.toString(),
      societyname: json['societyname']?.toString(),
      galinumber: json['galinumber'] != null ? int.tryParse(json['galinumber'].toString()) : null,
      isLiftAvailable: json['is_lift_available'] != null ? int.tryParse(json['is_lift_available'].toString()) : null,
      houseFlatFloorNo: json['house_flat_floor_no']?.toString(),
      societyGaliBlockNo: json['society_gali_block_no']?.toString(),
      localityid: json['localityid'] != null ? int.tryParse(json['localityid'].toString()) : null,
      localityids: json['localityids']?.toString(),
      sectornumber: json['sectornumber']?.toString(),
      sectorid: json['sectorid'] != null ? int.tryParse(json['sectorid'].toString()) : null,
      sectorids: json['sectorids']?.toString(),
      landmark: json['landmark']?.toString(),
      stateid: json['stateid'] != null ? int.tryParse(json['stateid'].toString()) : null,
      districtid: json['districtid'] != null ? int.tryParse(json['districtid'].toString()) : null,
      subdivisionid: json['subdivisionid'] != null ? int.tryParse(json['subdivisionid'].toString()) : null,
      subdivisionname: json['subdivisionname']?.toString(),
      sector: json['sector'] != null ? int.tryParse(json['sector'].toString()) : null,
      block: json['block']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      pincode: json['pincode']?.toString(),
      isDefaultAddress: json['is_default_address'] != null ? int.tryParse(json['is_default_address'].toString()) : null,
      assignedstatus: json['assignedstatus'] != null ? int.tryParse(json['assignedstatus'].toString()) : null,
      status: json['status'] != null ? int.tryParse(json['status'].toString()) : null,
      cdate: json['cdate']?.toString(),
      modifiedDate: json['modified_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userid': userid,
        'fulladdress': fulladdress,
        'floornumber': floornumber,
        'housenumber': housenumber,
        'flatnumber': flatnumber,
        'societyname': societyname,
        'galinumber': galinumber,
        'is_lift_available': isLiftAvailable,
        'house_flat_floor_no': houseFlatFloorNo,
        'society_gali_block_no': societyGaliBlockNo,
        'localityid': localityid,
        'localityids': localityids,
        'sectornumber': sectornumber,
        'sectorid': sectorid,
        'sectorids': sectorids,
        'landmark': landmark,
        'stateid': stateid,
        'districtid': districtid,
        'subdivisionid': subdivisionid,
        'subdivisionname': subdivisionname,
        'sector': sector,
        'block': block,
        'city': city,
        'state': state,
        'pincode': pincode,
        'is_default_address': isDefaultAddress,
        'assignedstatus': assignedstatus,
        'status': status,
        'cdate': cdate,
        'modified_date': modifiedDate,
      };
}
