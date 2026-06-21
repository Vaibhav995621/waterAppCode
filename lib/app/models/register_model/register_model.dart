// class RegisterModel {
//   String statusCode;
//   String message;
//   RegisterData data;
//
//   RegisterModel({
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//
//   factory RegisterModel.fromJson(Map<String, dynamic> json) {
//     return RegisterModel(
//       statusCode: json['status_code'] ?? '',
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? RegisterData.fromJson(json['data'])
//           : RegisterData.empty(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "statusCode": statusCode,
//       "message": message,
//       "data": data.toJson(),
//     };
//   }
// }
//
// class RegisterData {
//   int id;
//   String username;
//   String fullname;
//   String password;
//   String mobile;
//   String fulladdress;
//   String housenumber;
//   String flatnumber;
//   String societyname;
//   String galinumber;
//   String landmark;
//   String city;
//   String state;
//   String email;
//   String photo;
//   String pincode;
//   int status;
//   DateTime cdate;
//   DateTime modifiedDate;
//
//   RegisterData({
//     required this.id,
//     required this.username,
//     required this.fullname,
//     required this.password,
//     required this.mobile,
//     required this.fulladdress,
//     required this.housenumber,
//     required this.flatnumber,
//     required this.societyname,
//     required this.galinumber,
//     required this.landmark,
//     required this.city,
//     required this.state,
//     required this.email,
//     required this.photo,
//     required this.pincode,
//     required this.status,
//     required this.cdate,
//     required this.modifiedDate,
//   });
//
//   /// ✅ Empty Constructor
//   factory RegisterData.empty() {
//     return RegisterData(
//       id: 0,
//       username: '',
//       fullname: '',
//       password: '',
//       mobile: '',
//       fulladdress: '',
//       housenumber: '',
//       flatnumber: '',
//       societyname: '',
//       galinumber: '',
//       landmark: '',
//       city: '',
//       state: '',
//       email: '',
//       photo: '',
//       pincode: '',
//       status: 0,
//       cdate: DateTime.now(),
//       modifiedDate: DateTime.now(),
//     );
//   }
//
//   factory RegisterData.fromJson(Map<String, dynamic> json) {
//     return RegisterData(
//       id: json['id'] ?? 0,
//       username: json['username'] ?? '',
//       fullname: json['fullname'] ?? '',
//       password: json['password'] ?? '',
//       mobile: json['mobile'] ?? '',
//       fulladdress: json['fulladdress'] ?? '',
//       housenumber: json['housenumber'] ?? '',
//       flatnumber: json['flatnumber'] ?? '',
//       societyname: json['societyname'] ?? '',
//       galinumber: json['galinumber'] ?? '',
//       landmark: json['landmark'] ?? '',
//       city: json['city'] ?? '',
//       state: json['state'] ?? '',
//       email: json['email'] ?? '',
//       photo: json['photo'] ?? '',
//       pincode: json['pincode'] ?? '',
//       status: json['status'] ?? 0,
//       cdate: json['cdate'] != null
//           ? DateTime.parse(json['cdate'])
//           : DateTime.now(),
//       modifiedDate: json['modifiedDate'] != null
//           ? DateTime.parse(json['modifiedDate'])
//           : DateTime.now(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "username": username,
//       "fullname": fullname,
//       "password": password,
//       "mobile": mobile,
//       "fulladdress": fulladdress,
//       "housenumber": housenumber,
//       "flatnumber": flatnumber,
//       "societyname": societyname,
//       "galinumber": galinumber,
//       "landmark": landmark,
//       "city": city,
//       "state": state,
//       "email": email,
//       "photo": photo,
//       "pincode": pincode,
//       "status": status,
//       "cdate": cdate.toIso8601String(),
//       "modifiedDate": modifiedDate.toIso8601String(),
//     };
//   }
// }