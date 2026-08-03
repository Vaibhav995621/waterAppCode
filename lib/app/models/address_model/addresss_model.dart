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
  String landmark;
  String city;
  String state;
  String pincode;
  int status;
  DateTime cdate;
  DateTime modifiedDate;
  int isDefault;

  /// Extended fields from API
  String? houseFlatFloorNo;
  String? societyGaliBlockNo;
  int? localityid;
  List<dynamic>? localityids;
  int? sectorid;
  List<dynamic>? sectorids;
  int? stateid;
  int? districtid;
  int? subdivisionid;
  String? subdivisionname;
  String? sectornumber;
  int? sector;
  String? block;
  int? isLiftAvailable;
  int? assignedstatus;

  AddressData({
    required this.id,
    required this.fullAddress,
    required this.userid,
    required this.floornumber,
    required this.housenumber,
    required this.flatnumber,
    required this.societyname,
    required this.galinumber,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.status,
    required this.cdate,
    required this.modifiedDate,
    required this.isDefault,
    this.houseFlatFloorNo,
    this.societyGaliBlockNo,
    this.localityid,
    this.localityids,
    this.sectorid,
    this.sectorids,
    this.stateid,
    this.districtid,
    this.subdivisionid,
    this.subdivisionname,
    this.sectornumber,
    this.sector,
    this.block,
    this.isLiftAvailable,
    this.assignedstatus,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json["id"] ?? 0,
      fullAddress: json["fulladdress"]?.toString() ?? "",
      userid: json["userid"] ?? 0,
      floornumber: json["floornumber"] is int
          ? json["floornumber"]
          : int.tryParse(json["floornumber"]?.toString() ?? "") ?? 0,
      housenumber: json["housenumber"]?.toString() ?? "",
      flatnumber: json["flatnumber"]?.toString() ?? "",
      societyname: json["societyname"]?.toString() ?? "",
      galinumber: json["galinumber"]?.toString() ?? "",
      landmark: json["landmark"]?.toString() ?? "",
      city: json["city"]?.toString() ?? "",
      state: json["state"]?.toString() ?? "",
      pincode: json["pincode"]?.toString() ?? "",
      status: json["status"] is int
          ? json["status"]
          : int.tryParse(json["status"]?.toString() ?? "") ?? 0,
      cdate: json["cdate"] == null
          ? DateTime.now()
          : DateTime.parse(json["cdate"]),
      modifiedDate: json["modified_date"] == null
          ? DateTime.now()
          : DateTime.parse(json["modified_date"]),
      isDefault: json["is_default_address"] is int
          ? json["is_default_address"]
          : int.tryParse(json["is_default_address"]?.toString() ?? "") ?? 0,
      houseFlatFloorNo: json["house_flat_floor_no"]?.toString(),
      societyGaliBlockNo: json["society_gali_block_no"]?.toString(),
      localityid: json["localityid"] is int
          ? json["localityid"]
          : int.tryParse(json["localityid"]?.toString() ?? ""),
      localityids: json["localityids"] is List ? json["localityids"] : null,
      sectorid: json["sectorid"] is int
          ? json["sectorid"]
          : int.tryParse(json["sectorid"]?.toString() ?? ""),
      sectorids: json["sectorids"] is List ? json["sectorids"] : null,
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
      sectornumber: json["sectornumber"]?.toString(),
      sector: json["sector"] is int
          ? json["sector"]
          : int.tryParse(json["sector"]?.toString() ?? ""),
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
      "landmark": landmark,
      "city": city,
      "state": state,
      "pincode": pincode,
      "status": status,
      "cdate": cdate.toIso8601String(),
      "modified_date": modifiedDate.toIso8601String(),
      "is_default_address": isDefault,
      "house_flat_floor_no": houseFlatFloorNo,
      "society_gali_block_no": societyGaliBlockNo,
      "localityid": localityid,
      "localityids": localityids,
      "sectorid": sectorid,
      "sectorids": sectorids,
      "stateid": stateid,
      "districtid": districtid,
      "subdivisionid": subdivisionid,
      "subdivisionname": subdivisionname,
      "sectornumber": sectornumber,
      "sector": sector,
      "block": block,
      "is_lift_available": isLiftAvailable,
      "assignedstatus": assignedstatus,
    };
  }
}
