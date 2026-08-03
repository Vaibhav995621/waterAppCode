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
      data: json["data"] != null
          ? AddEditAddressData.fromJson(json["data"])
          : null,
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
  int sector;
  String? sectornumber;
  String landmark;
  String city;
  String state;
  String pincode;
  int isDefaultAddress;
  int status;
  String cdate;
  String modifiedDate;

  /// Extended fields
  String? houseFlatFloorNo;
  String? societyGaliBlockNo;
  int? localityid;
  int? sectorid;
  int? stateid;
  int? districtid;
  int? subdivisionid;
  String? subdivisionname;
  String? block;
  int? isLiftAvailable;
  int? assignedstatus;

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
    this.sectornumber,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isDefaultAddress,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
    this.houseFlatFloorNo,
    this.societyGaliBlockNo,
    this.localityid,
    this.sectorid,
    this.stateid,
    this.districtid,
    this.subdivisionid,
    this.subdivisionname,
    this.block,
    this.isLiftAvailable,
    this.assignedstatus,
  });

  factory AddEditAddressData.fromJson(Map<String, dynamic> json) {
    return AddEditAddressData(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"]?.toString() ?? "") ?? 0,
      userid: json["userid"] is int
          ? json["userid"]
          : int.tryParse(json["userid"]?.toString() ?? "") ?? 0,
      fullAddress: json["fulladdress"]?.toString() ?? "",
      floornumber: json["floornumber"] is int
          ? json["floornumber"]
          : int.tryParse(json["floornumber"]?.toString() ?? "") ?? 0,
      housenumber: json["housenumber"]?.toString() ?? "",
      flatnumber: json["flatnumber"]?.toString() ?? "",
      societyname: json["societyname"]?.toString() ?? "",
      galinumber: json["galinumber"]?.toString() ?? "",
      sector: json["sector"] is int
          ? json["sector"]
          : int.tryParse(json["sector"]?.toString() ?? "") ?? 0,
      sectornumber: json["sectornumber"]?.toString(),
      landmark: json["landmark"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      pincode: json["pincode"]?.toString() ?? "",
      isDefaultAddress: json["is_default_address"] is int
          ? json["is_default_address"]
          : int.tryParse(json["is_default_address"]?.toString() ?? "") ?? 0,
      status: json["status"] is int
          ? json["status"]
          : int.tryParse(json["status"]?.toString() ?? "") ?? 0,
      cdate: json["cdate"]?.toString() ?? "",
      modifiedDate: json["modified_date"]?.toString() ?? "",
      houseFlatFloorNo: json["house_flat_floor_no"]?.toString(),
      societyGaliBlockNo: json["society_gali_block_no"]?.toString(),
      localityid: json["localityid"] is int
          ? json["localityid"]
          : int.tryParse(json["localityid"]?.toString() ?? ""),
      sectorid: json["sectorid"] is int
          ? json["sectorid"]
          : int.tryParse(json["sectorid"]?.toString() ?? ""),
      stateid: json["stateid"] is int
          ? json["stateid"]
          : int.tryParse(json["stateid"]?.toString() ?? ""),
      districtid: json["districtid"] is int
          ? json["districtid"]
          : int.tryParse(json["districtid"]?.toString() ?? ""),
      subdivisionid: json["subdivisionid"] is int
          ? json["subdivisionid"]
          : int.tryParse(json["subdivisionid"]?.toString() ?? ""),
      subdivisionname: json["subdivisionname"]?.toString(),
      block: json["block"]?.toString(),
      isLiftAvailable: json["is_lift_available"] is int
          ? json["is_lift_available"]
          : int.tryParse(json["is_lift_available"]?.toString() ?? ""),
      assignedstatus: json["assignedstatus"] is int
          ? json["assignedstatus"]
          : int.tryParse(json["assignedstatus"]?.toString() ?? ""),
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
      "sectornumber": sectornumber,
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "is_default_address": isDefaultAddress,
      "status": status,
      "cdate": cdate,
      "modified_date": modifiedDate,
      "house_flat_floor_no": houseFlatFloorNo,
      "society_gali_block_no": societyGaliBlockNo,
      "localityid": localityid,
      "sectorid": sectorid,
      "stateid": stateid,
      "districtid": districtid,
      "subdivisionid": subdivisionid,
      "subdivisionname": subdivisionname,
      "block": block,
      "is_lift_available": isLiftAvailable,
      "assignedstatus": assignedstatus,
    };
  }
}
