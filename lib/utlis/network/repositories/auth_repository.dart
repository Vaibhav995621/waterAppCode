import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/models/payment_history_model/payment_histroy_model.dart';
import 'package:zourney/app/models/subcription_model/subcription_model.dart';
import 'package:zourney/app/models/bottel_model/botle_model.dart';
import '../../../app/models/Admin/admin_dashboard/admin_dashboard_model.dart';
import '../../../app/models/Admin/admin_order_details/admin_order_details_model.dart';
import '../../../app/models/Admin/admin_order_list/admin_order_model.dart';
import '../../../app/models/Admin/admin_order_list/sector_list_model.dart';
import '../../../app/models/Admin/assign_delivery/assign_to_delivery_model.dart';
import '../../../app/models/address_model/addresss_model.dart';
import '../../../app/models/address_model/delete_address_model.dart';
import '../../../app/models/address_model/add_edit_address_model.dart';
import '../../../app/models/login_model/login_model.dart';
import '../../../app/models/change_password_model.dart';
import '../../../app/models/order_list_model/add_order_model.dart';
import '../../../app/models/order_list_model/order_list.dart';
import '../../../app/models/payment_model/payment_success_model.dart';
import '../../../app/models/profile_model/profile_model.dart';
import '../../../app/models/subcription_model/subscription_history_model.dart';
import '../../../app/models/notification_model.dart';
import '../../../app/models/forgot_password_model.dart';
import '../../../app/models/forgot_password_reset_model.dart';
import '../../../app/models/register_model/state_list_model.dart';
import '../../../app/models/register_model/district_list_model.dart';
import '../../../app/models/register_model/subdivision_list_model.dart';
import '../../../app/models/register_model/register_sector_list_model.dart';
import '../../../app/models/register_model/register_locality_list_model.dart';
import '../../../app/models/wallet_model/wallet_model.dart';
import '../../constants/api_endpoints.dart';
import '../api_provider.dart';


class AuthRepository {
  final ApiProvider _api = ApiProvider(baseUrl: ApiEndpoints.baseUrl);

  Future<LoginModel> login(
      String email,
      String password,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.loginApi,
        {
          "mobile": email,
          "password": password,
          "fcm_token" : AppSession.token,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return LoginModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<ChangePasswordModel> changePassword({
    required String customerId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.changePassword,
        {
          "customer_id": customerId,
          "old_password": oldPassword,
          "new_password": newPassword,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return ChangePasswordModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }


  Future<OrderList> getActiveOrderList(
      String customerId,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.customerGetActiveOrder,
        {
          'customerid' : customerId
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return OrderList.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<OrderList> getDeliveryActiveOrderList(
      String customerId,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.deliveryOrderList,
        {
          'partnerid' : customerId
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return OrderList.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<OrderList> getOrderHistoryList(
      String customerId,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.customerOrderHistory,
        {
          "customerid": customerId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return OrderList.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<LoginModel> registerApi({
    required String userName,
    required String fullName,
    required String password,
    required String mobile,
    required String fullAddress,
    required String houseNumber,
    required String societyName,
    required String landmark,
    required String city,
    required String state,
    required String email,
    required String photo,
    required String pinCode,
    required String role,
    required String userType,
    required String stateId,
    required String districtId,
    required String subdivisionId,
    required String subdivisionName,
    required String floorNumber,
    required String isLiftAvailable,

    String sectorId = '',
    String localityId = '',
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.registerApi, // change endpoint if needed
        {
          "username": userName,
          "fullname": fullName,
          "password": password,
          "mobile": mobile,
          "fulladdress": fullAddress,
          "house_flat_floor_no": houseNumber,
          "society_gali_block_no": societyName,
          "landmark": landmark,
          "city": city,
          "state": state,
          "email": email,
          "photo": photo,
          "pincode": pinCode,
          "role": role,
          "status": 1,
          "usertype": userType,
          "stateid": stateId,
          "districtid": districtId,
          "subdivisionid": subdivisionId,
          "subdivisionname": subdivisionName,
          "sectorid": sectorId,
          "localityid": localityId,
          "fcm_token" : AppSession.token,
          "floornumber": floorNumber,
          "is_lift_available": isLiftAvailable,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return LoginModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }


  Future<AddressList> getAddressList({
    required String customerId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.addressList, // change endpoint if needed
        {
          'customerid' : customerId
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return AddressList.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }



  }



  Future<DeleteAddressModel> deleteAddress({
    required String customerId,
    required String addressId,

  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.deleteAddress, // change endpoint if needed
        {
          'customerid' : customerId,
          'id' : addressId

        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return DeleteAddressModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }




  Future<BottleModel> getBottleList(
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getBottleList,
        {
          "usertype" : AppSession.usertype
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return BottleModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }




  Future<AddOrderModel> addOrder( {
    required Map<String, dynamic> body,
  }) async {
    final response = await _api.post(
      ApiEndpoints.addOrder,
      body,
      headers: {
        "Accept": "application/json",
        "Authorization": "abcshsh",
      },
    );

    return AddOrderModel.fromJson(response);
  }




  Future<ProfileModel> getUserProfile(
      String customerId
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getProfile,
        {
          'customerId' : customerId

        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return ProfileModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<ProfileModel> updateProfile({
    required String custId,
    File? image,
  }) async {

    final response = await _api.uploadMultipart(
      ApiEndpoints.updateProfile,
      data: {
        "customerid": custId,
      },
      images: image != null ? [image] : [],
      imageKey: "photo",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "abcshsh"
      },
    );

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateCustomerProfileName({
    required String custId,
    required String fullName,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.editProfileData,
        {
          "customerid": custId,
          "fullname": fullName,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return ProfileModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }


  Future<AddEditAddressModel> addAddress({
    required Map<String, dynamic> body,
  }) async {
    final response = await _api.post(
      ApiEndpoints.addAddress,
      body,
      headers: {
        "Accept": "application/json",
        "Authorization": "abcshsh",
      },
    );

    return AddEditAddressModel.fromJson(response);
  }

  Future<AddEditAddressModel> updateAddress({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.updateAddress,
        body,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );
      return AddEditAddressModel.fromJson(response);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Network error";
      throw Exception(message);
    }
  }


Future<DeleteAddressModel> setAsDefaultAddress({
required String customerId,
required String addressId,

}) async {
  try {
    final response = await _api.post(
      ApiEndpoints.setDefaultAddress, // change endpoint if needed
      {
        'customerid': customerId,
        'id': addressId
      },
      tokenRequired: false,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "abcshsh",
      },
    );

    /// ✅ SUCCESS
    return DeleteAddressModel.fromJson(response);
  } on DioException catch (e) {
    final message =
        e.response?.data?['message'] ?? "Network error";

    throw Exception(message);
  }
}



Future<SubscriptionModel> getSubscriptionList() async {
  try {
    final response = await _api.post(
      ApiEndpoints.subscriptionList, // change endpoint if needed
      {
      },
      tokenRequired: false,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "abcshsh",
      },
    );

    /// ✅ SUCCESS
    return SubscriptionModel.fromJson(response);
  } on DioException catch (e) {
    final message =
        e.response?.data?['message'] ?? "Network error";

    throw Exception(message);
  }
}


  Future<PaymentSuccessModel> buySubscription(
      String totalAmount,
      String transId,
      String subscriptionId,
      String paymentmode

  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.savePaymentByCustomerId, // change endpoint if needed
        {
          "customerid": AppSession.userId,
          "orderid": 0,
          "subscriptionid" :subscriptionId,
          "totalamount": totalAmount,
          "trans_id": transId,
          "paymentmode" : paymentmode
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return PaymentSuccessModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<PaymentSuccessModel> orderPayment(
      String totalAmount,
      String transId,
      String orderId,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.savePaymentByCustomerId, // change endpoint if needed
        {
          "customerid": AppSession.userId,
          "orderid": orderId,
          "subscriptionid" :0,
          "totalamount": totalAmount,
          "trans_id": transId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return PaymentSuccessModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<dynamic> saveSchedule(Map<String, dynamic> body) async {
    try {
      final response = await _api.post(
        ApiEndpoints.saveSchedule,
        body,
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );
      return response;
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";
      throw Exception(message);
    }
  }



  Future<PaymentHistoryModel> getPaymentHistory() async {
    try {
      if(AppSession.role == 3) {
        final response = await _api.post(
          ApiEndpoints.allPaymentHistory, // change endpoint if needed
          {
            "customerid": AppSession.userId,
          },
          tokenRequired: false,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "abcshsh",
          },
        );
        return PaymentHistoryModel.fromJson(response);

      } else{
        final response = await _api.post(
          ApiEndpoints.paymentHistory, // change endpoint if needed
          {
            "customerid": AppSession.userId,
          },
          tokenRequired: false,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "abcshsh",
          },
        );
        return PaymentHistoryModel.fromJson(response);

      }

      /// ✅ SUCCESS
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }


  Future<AdminDashboardModel> adminDashboardApi() async {
    try {
      final response = await _api.post(
        ApiEndpoints.adminDashboard, // change endpoint if needed
        {
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return AdminDashboardModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<AdminOrderListModel> adminOrderApi(String sector) async {
    try {
      final response = await _api.post(
        ApiEndpoints.adminOrderList, // change endpoint if needed
        {
          "sector": sector,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return AdminOrderListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<SubscriptionHistoryModel> getSubscriptionHistoryList() async {
    try {
      final response = await _api.post(
        ApiEndpoints.subscriptionHistoryList, // change endpoint if needed
        {

            "customerid":AppSession.userId

        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return SubscriptionHistoryModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<DeliveryBoyListModel> deliveryBoyList() async {
    try {
      final response = await _api.post(
        ApiEndpoints.deliverBoyList, // change endpoint if needed
        {
          "customerid":AppSession.userId
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return DeliveryBoyListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }


  Future<AssignToDeliveryModel> assignDeliveryBoy(String orderId,String deliveryBoyId) async {
    try {
      final response = await _api.post(
        ApiEndpoints.assignDeliveryBoy, // change endpoint if needed
        {
          "order_id": orderId,
          "customer_id": deliveryBoyId
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return AssignToDeliveryModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<AssignToDeliveryModel> updateOrderStatus(String orderId,String status) async {
    try {
      final response = await _api.post(
        ApiEndpoints.updateorderstatusbyorderid, // change endpoint if needed
        {
          "orderid": orderId,
          "customer_id" : AppSession.userId,
          "status": status
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh",
        },
      );

      /// ✅ SUCCESS
      return AssignToDeliveryModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



  Future<OrderList> getDeliveryHistoryList(
      String customerId,
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.deliveryPartnerOrderHistory,
        {
          "customerid": customerId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      /// ✅ SUCCESS
      return OrderList.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<SectorListModel> getSectorList() async {
    try {
      final response = await _api.post(
        ApiEndpoints.getSectorList,
        {},
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return SectorListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<NotificationModel> getNotifications({
    required String customerId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getNotifications,
        {
          "customerid": customerId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return NotificationModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<ForgotPasswordModel> sendOtpForgotPassword({
    required String mobile,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.sendOtpForgotPassword,
        {
          "mobile": mobile,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return ForgotPasswordModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<ForgotPasswordResetModel> forgotPasswordReset({
    required String mobile,
    required String newPassword,
    required String otp,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.forgotPasswordReset,
        {
          "mobile": mobile,
          "new_password": newPassword,
          "otp": otp,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return ForgotPasswordResetModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<ForgotPasswordModel> resendOtp({
    required String mobile,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.resendOtp,
        {
          "mobile": mobile,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return ForgotPasswordModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<StateListModel> getStateList() async {
    try {
      final response = await _api.post(
        ApiEndpoints.getStateList,
        {},
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return StateListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<DistrictListModel> getDistrictList({required String stateId}) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getDistrictList,
        {
          "stateid": stateId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return DistrictListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<SubdivisionListModel> getSubdivisionList({
    required String stateId,
    required String districtId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getSubdivisionList,
        {
          "stateid": stateId,
          "districtid": districtId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return SubdivisionListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<RegisterSectorListModel> getSectorsList({
    required String stateId,
    required String districtId,
    required String subdivisionId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getSectorsList,
        {
          "stateid": stateId,
          "districtid": districtId,
          "subdivisionid": subdivisionId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return RegisterSectorListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<RegisterLocalityListModel> getLocalityList({
    required String stateId,
    required String districtId,
    required String subdivisionId,
    required String sectorsId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getLocalityList,
        {
          "stateid": stateId,
          "districtid": districtId,
          "subdivisionid": subdivisionId,
          "sectorsid": sectorsId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return RegisterLocalityListModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<GetWalletModel> getWalletDetails(String customerId) async {
    try {
      final response = await _api.post(
        ApiEndpoints.getWalletByCustomerId,
        {
          "customerid": customerId,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return GetWalletModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }

  Future<UpdateWalletModel> updateWalletAmount({
    required String customerId,
    required String walletAmount,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.updateWalletByCustomerId,
        {
          "customerid": customerId,
          "walletamount": walletAmount,
        },
        tokenRequired: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "abcshsh"
        },
      );

      return UpdateWalletModel.fromJson(response);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Network error";

      throw Exception(message);
    }
  }



}

