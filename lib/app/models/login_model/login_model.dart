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
    return LoginModel(
      statusCode: json["status_code"] ?? "",
      message: json["message"] ?? "",
      data: Data.fromJson(json["data"] ?? {}),
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
  int plantype;
  String username;
  String fullname;
  String password;
  String mobile;
  String email;
  String photo;
  int status;
  DateTime cdate;
  int role;
  DateTime modifiedDate;
  Address address;
  Plandetail plandetail;

  Data({
    required this.id,
    required this.plantype,
    required this.username,
    required this.fullname,
    required this.password,
    required this.mobile,
    required this.email,
    required this.photo,
    required this.status,
    required this.cdate,
    required this.role,
    required this.modifiedDate,
    required this.address,
    required this.plandetail,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"] ?? 0,
      plantype: json["plantype"] ?? 0,
      username: json["username"] ?? "",
      fullname: json["fullname"] ?? "",
      password: json["password"] ?? "",
      mobile: json["mobile"] ?? "",
      email: json["email"] ?? "",
      photo: json["photo"] ?? "",
      status: json["status"] ?? 0,
      cdate: DateTime.tryParse(json["cdate"] ?? "") ?? DateTime.now(),
      role: json["role"] ?? 0,
      modifiedDate: DateTime.tryParse(
          json["modified_date"] ?? "")
          ?? DateTime.now(),
      address: Address.fromJson(
          json["address"] ?? {}),
      plandetail: Plandetail.fromJson(
          json["plandetail"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "plantype": plantype,
      "username": username,
      "fullname": fullname,
      "password": password,
      "mobile": mobile,
      "email": email,
      "photo": photo,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "role": role,
      "modified_date":
      modifiedDate.toIso8601String(),
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
  });

  factory Address.fromJson(
      Map<String, dynamic> json) {
    return Address(
      fulladdress:
      json["fulladdress"] ?? "",
      floornumber:
      json["floornumber"] ?? 0,
      housenumber:
      json["housenumber"] ?? "",
      flatnumber:
      json["flatnumber"] ?? "",
      societyname:
      json["societyname"] ?? "",
      galinumber:
      json["galinumber"] ?? "",
      landmark:
      json["landmark"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode:
      json["pincode"] ?? "",
      isDefaultAddress:
      json["isDefaultAddress"] ?? 0,
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
      "isDefaultAddress":
      isDefaultAddress,
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
  });

  factory Plandetail.fromJson(
      Map<String, dynamic> json) {
    return Plandetail(
      id: json["id"] ?? 0,
      planname:
      json["planname"] ?? "",
      plandetails:
      json["plandetails"] ?? "",
      originalprice:
      json["originalprice"] ?? "",
      price: json["price"] ?? "",
      bottlequantity:
      json["bottlequantity"] ?? 0,
      status:
      json["status"] ?? 0,
      cdate: DateTime.tryParse(
          json["cdate"] ?? "")
          ?? DateTime.now(),
      modifiedDate:
      DateTime.tryParse(
          json["modified_date"] ??
              "")
          ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "planname": planname,
      "plandetails": plandetails,
      "originalprice": originalprice,
      "price": price,
      "bottlequantity":
      bottlequantity,
      "status": status,
      "cdate":
      cdate.toIso8601String(),
      "modified_date":
      modifiedDate
          .toIso8601String(),
    };
  }
}