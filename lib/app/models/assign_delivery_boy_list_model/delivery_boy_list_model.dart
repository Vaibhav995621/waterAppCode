class DeliveryBoyListModel {
  String statusCode;
  String message;
  List<Datum> data;

  DeliveryBoyListModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory DeliveryBoyListModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyListModel(
      statusCode: json['statusCode'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Datum.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Datum {
  int id;
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

  Datum({
    required this.id,
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
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      status: json['status'] ?? 0,
      cdate: DateTime.tryParse(json['cdate'] ?? '') ?? DateTime.now(),
      role: json['role'] ?? 0,
      modifiedDate:
      DateTime.tryParse(json['modifiedDate'] ?? '') ?? DateTime.now(),
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'password': password,
      'mobile': mobile,
      'email': email,
      'photo': photo,
      'status': status,
      'cdate': cdate.toIso8601String(),
      'role': role,
      'modifiedDate': modifiedDate.toIso8601String(),
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fulladdress: json['fulladdress'] ?? '',
      floornumber: json['floornumber'] ?? 0,
      housenumber: json['housenumber'] ?? '',
      flatnumber: json['flatnumber'] ?? '',
      societyname: json['societyname'] ?? '',
      galinumber: json['galinumber'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      isDefaultAddress: json['isDefaultAddress'] ?? 0,
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
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'isDefaultAddress': isDefaultAddress,
    };
  }
}