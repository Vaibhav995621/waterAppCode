class LoginModel {
  String statusCode;
  String message;
  Data data;

  LoginModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final dataVal = json["data"];
    return LoginModel(
      statusCode: (json["status_code"] ?? json["statusCode"] ?? "").toString(),
      message: json["message"] ?? "",
      data: Data.fromJson(dataVal is Map<String, dynamic> ? dataVal : const {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class Data {
  int id;
  int usertype;
  int plantype;
  String username;
  String fullname;
  String password;
  num walletamount;
  String mobile;
  int floornumber;
  String housenumber;
  String flatnumber;
  String societyname;
  int galinumber;
  String email;
  String photo;
  int planbottlequantity;
  int status;
  DateTime cdate;
  int role;
  DateTime modifiedDate;
  String fcmToken;
  String? otp;
  Address address;
  Plandetail plandetail;

  Data({
    required this.id,
    required this.usertype,
    required this.plantype,
    required this.username,
    required this.fullname,
    required this.password,
    required this.walletamount,
    required this.mobile,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.email,
    required this.photo,
    required this.planbottlequantity,
    required this.status,
    required this.cdate,
    required this.role,
    required this.modifiedDate,
    required this.fcmToken,
    this.otp,
    required this.address,
    required this.plandetail,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      usertype: json["usertype"] ?? 0,
      plantype: json["plantype"] ?? 0,
      username: json["username"]?.toString() ?? "",
      fullname: json["fullname"]?.toString() ?? "",
      password: json["password"]?.toString() ?? "",
      walletamount: json["walletamount"] ?? 0,
      mobile: json["mobile"]?.toString() ?? "",
      floornumber: json["floornumber"] ?? 0,
      housenumber: json["housenumber"]?.toString() ?? "",
      flatnumber: json["flatnumber"]?.toString() ?? "",
      societyname: json["societyname"]?.toString() ?? "",
      galinumber: json["galinumber"] is int ? json["galinumber"] : (int.tryParse(json["galinumber"]?.toString() ?? "") ?? 0),
      email: json["email"]?.toString() ?? "",
      photo: json["photo"]?.toString() ?? "",
      planbottlequantity: json["planbottlequantity"] ?? 0,
      status: json["status"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      role: json["role"] ?? 0,
      modifiedDate: DateTime.tryParse(json["modified_date"] ?? "") ?? DateTime.now(),
      fcmToken: json["fcm_token"]?.toString() ?? "",
      otp: json["otp"]?.toString(),
      address: Address.fromJson(json["address"] ?? {}),
      plandetail: Plandetail.fromJson(json["plandetail"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "usertype": usertype,
      "plantype": plantype,
      "username": username,
      "fullname": fullname,
      "password": password,
      "walletamount": walletamount,
      "mobile": mobile,
      "floornumber": floornumber,
      "housenumber": housenumber,
      "flatnumber": flatnumber,
      "societyname": societyname,
      "galinumber": galinumber,
      "email": email,
      "photo": photo,
      "planbottlequantity": planbottlequantity,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "role": role,
      "modified_date": modifiedDate.toIso8601String(),
      "fcm_token": fcmToken,
      "otp": otp,
      "address": address.toJson(),
      "plandetail": plandetail.toJson(),
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
  String landmark;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;
  String houseFlatFloorNo;
  String societyGaliBlockNo;
  int localityid;
  String sectornumber;
  int sectorid;
  int stateid;
  int districtid;
  int subdivisionid;
  String subdivisionname;
  int sector;
  String block;

  Address({
    required this.fulladdress,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefaultAddress,
    required this.houseFlatFloorNo,
    required this.societyGaliBlockNo,
    required this.localityid,
    required this.sectornumber,
    required this.sectorid,
    required this.stateid,
    required this.districtid,
    required this.subdivisionid,
    required this.subdivisionname,
    required this.sector,
    required this.block,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fulladdress: json["fulladdress"]?.toString() ?? "",
      floornumber: json["floornumber"] is int ? json["floornumber"] : (int.tryParse(json["floornumber"]?.toString() ?? "") ?? 0),
      housenumber: json["housenumber"]?.toString() ?? "",
      flatnumber: json["flatnumber"]?.toString() ?? "",
      societyname: json["societyname"]?.toString() ?? "",
      galinumber: json["galinumber"]?.toString() ?? "",
      landmark: json["landmark"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      pincode: json["pincode"]?.toString() ?? "",
      isDefaultAddress: json["is_default_address"] is int 
          ? json["is_default_address"] 
          : (json["isDefaultAddress"] is int 
              ? json["isDefaultAddress"] 
              : (int.tryParse(json["is_default_address"]?.toString() ?? "") ?? int.tryParse(json["isDefaultAddress"]?.toString() ?? "") ?? 0)),
      houseFlatFloorNo: json["house_flat_floor_no"]?.toString() ?? "",
      societyGaliBlockNo: json["society_gali_block_no"]?.toString() ?? "",
      localityid: json["localityid"] is int ? json["localityid"] : (int.tryParse(json["localityid"]?.toString() ?? "") ?? 0),
      sectornumber: json["sectornumber"]?.toString() ?? "",
      sectorid: json["sectorid"] is int ? json["sectorid"] : (int.tryParse(json["sectorid"]?.toString() ?? "") ?? 0),
      stateid: json["stateid"] is int ? json["stateid"] : (int.tryParse(json["stateid"]?.toString() ?? "") ?? 0),
      districtid: json["districtid"] is int ? json["districtid"] : (int.tryParse(json["districtid"]?.toString() ?? "") ?? 0),
      subdivisionid: json["subdivisionid"] is int ? json["subdivisionid"] : (int.tryParse(json["subdivisionid"]?.toString() ?? "") ?? 0),
      subdivisionname: json["subdivisionname"]?.toString() ?? "",
      sector: json["sector"] is int ? json["sector"] : (int.tryParse(json["sector"]?.toString() ?? "") ?? 0),
      block: json["block"]?.toString() ?? "",
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
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "isDefaultAddress": isDefaultAddress,
      "is_default_address": isDefaultAddress,
      "house_flat_floor_no": houseFlatFloorNo,
      "society_gali_block_no": societyGaliBlockNo,
      "localityid": localityid,
      "sectornumber": sectornumber,
      "sectorid": sectorid,
      "stateid": stateid,
      "districtid": districtid,
      "subdivisionid": subdivisionid,
      "subdivisionname": subdivisionname,
      "sector": sector,
      "block": block,
    };
  }
}

class Plandetail {
  int id;
  String planname;
  String plandetails;
  String originalprice;
  String price;
  int bottlequantity;
  int status;
  DateTime cdate;
  DateTime modifiedDate;
  num totalsave;
  num rateperbottle;

  Plandetail({
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

  factory Plandetail.fromJson(Map<String, dynamic> json) {
    return Plandetail(
      id: json["id"] ?? 0,
      planname: json["planname"]?.toString() ?? "",
      plandetails: json["plandetails"]?.toString() ?? "",
      originalprice: json["originalprice"]?.toString() ?? "",
      price: json["price"]?.toString() ?? "",
      bottlequantity: json["bottlequantity"] ?? 0,
      status: json["status"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      modifiedDate: DateTime.tryParse(json["modified_date"] ?? "") ?? DateTime.now(),
      totalsave: json["totalsave"] ?? 0,
      rateperbottle: json["rateperbottle"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "planname": planname,
      "plandetails": plandetails,
      "originalprice": originalprice,
      "price": price,
      "bottlequantity": bottlequantity,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "modified_date": modifiedDate.toIso8601String(),
      "totalsave": totalsave,
      "rateperbottle": rateperbottle,
    };
  }
}