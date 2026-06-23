class AddressList {
  String statusCode;
  String message;
  List<AddressData> data;

  AddressList({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AddressList.fromJson(Map<String, dynamic> json) {
    return AddressList(
      statusCode: json["status_code"] ?? "",
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<AddressData>.from(
              json["data"].map((x) => AddressData.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "message": message,
      "data": data.map((x) => x.toJson()).toList(),
    };
  }
}

class AddressData {
  int id;
  int userid;
  String fullAddress;
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
  int status;
  DateTime cdate;
  DateTime modifiedDate;
  int isDefault;

  AddressData({
    required this.id,
    required this.fullAddress,
    required this.userid,
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
    required this.status,
    required this.cdate,
    required this.modifiedDate,
    required this.isDefault,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json["id"] ?? 0,
      fullAddress: json["fulladdress"]?.toString() ?? "",
      userid: json["userid"] ?? 0,
      floornumber: json["floornumber"] is int ? json["floornumber"] : int.tryParse(json["floornumber"]?.toString() ?? "") ?? 0,
      housenumber: json["housenumber"] ?? "",
      flatnumber: json["flatnumber"] ?? "",
      societyname: json["societyname"] ?? "",
      galinumber: json["galinumber"] ?? "",
      sector: json["sector"] ?? "",
      landmark: json["landmark"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      pincode: json["pincode"] ?? "",
      status: json["status"] ?? 0,
      cdate: json["cdate"] == null
          ? DateTime.now()
          : DateTime.parse(json["cdate"]),
      modifiedDate: json["modified_date"] == null
          ? DateTime.now()
          : DateTime.parse(json["modified_date"]),
      isDefault: json["is_default_address"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userid,
      "fulladdress": fullAddress,
      "floornumber": floornumber,
      "housenumber": housenumber,
      "flatnumber": flatnumber,
      "societyname": societyname,
      "galinumber": galinumber,
      "sector": sector,
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "modified_date": modifiedDate.toIso8601String(),
      "is_default_address": isDefault,
    };
  }
}
