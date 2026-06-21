class AddEditAddressModel {
  String statusCode;
  String message;
  AddEditAddressData? data;

  AddEditAddressModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory AddEditAddressModel.fromJson(Map<String, dynamic> json) {
    return AddEditAddressModel(
      statusCode: json["status_code"]?.toString() ?? "",
      message: json["message"]?.toString() ?? "",
      data: json["data"] != null ? AddEditAddressData.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status_code": statusCode,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class AddEditAddressData {
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
  int isDefaultAddress;
  int status;
  String cdate;
  String modifiedDate;

  AddEditAddressData({
    required this.id,
    required this.userid,
    required this.fullAddress,
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
    required this.status,
    required this.cdate,
    required this.modifiedDate,
  });

  factory AddEditAddressData.fromJson(Map<String, dynamic> json) {
    return AddEditAddressData(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? "") ?? 0,
      userid: json["userid"] is int ? json["userid"] : int.tryParse(json["userid"]?.toString() ?? "") ?? 0,
      fullAddress: json["fulladdress"]?.toString() ?? "",
      floornumber: json["floornumber"] is int ? json["floornumber"] : int.tryParse(json["floornumber"]?.toString() ?? "") ?? 0,
      housenumber: json["housenumber"]?.toString() ?? "",
      flatnumber: json["flatnumber"]?.toString() ?? "",
      societyname: json["societyname"]?.toString() ?? "",
      galinumber: json["galinumber"]?.toString() ?? "",
      sector: json["sector"]?.toString() ?? "",
      landmark: json["landmark"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      pincode: json["pincode"]?.toString() ?? "",
      isDefaultAddress: json["is_default_address"] is int ? json["is_default_address"] : int.tryParse(json["is_default_address"]?.toString() ?? "") ?? 0,
      status: json["status"] is int ? json["status"] : int.tryParse(json["status"]?.toString() ?? "") ?? 0,
      cdate: json["cdate"]?.toString() ?? "",
      modifiedDate: json["modified_date"]?.toString() ?? "",
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
      "is_default_address": isDefaultAddress,
      "status": status,
      "cdate": cdate,
      "modified_date": modifiedDate,
    };
  }
}
