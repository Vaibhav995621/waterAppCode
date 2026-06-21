import 'dart:io';
import 'package:dio/dio.dart';
import 'package:zourney/app/app_session/app_session.dart';
import 'package:zourney/app/models/payment_history_model/payment_histroy_model.dart';
import 'package:zourney/app/models/subcription_model/subcription_model.dart';
import 'package:zourney/app/models/bottel_model/botle_model.dart';
import '../../../app/models/Admin/admin_dashboard/admin_dashboard_model.dart';
import '../../../app/models/Admin/admin_order_details/admin_order_details_model.dart';
import '../../../app/models/Admin/admin_order_list/admin_order_model.dart';
import '../../../app/models/Admin/assign_delivery/assign_to_delivery_model.dart';
import '../../../app/models/address_model/addresss_model.dart';
import '../../../app/models/address_model/delete_address_model.dart';
import '../../../app/models/address_model/add_edit_address_model.dart';
import '../../../app/models/login_model/login_model.dart';
import '../../../app/models/order_list_model/add_order_model.dart';
import '../../../app/models/order_list_model/order_list.dart';
import '../../../app/models/payment_model/payment_success_model.dart';
import '../../../app/models/profile_model/profile_model.dart';
import '../../../app/models/subcription_model/subscription_history_model.dart';
import '../../constants/api_endpoints.dart';
import '../api_provider.dart';


class AuthRepository {
  final ApiProvider _api = ApiProvider(baseUrl: ApiEndpoints.baseUrl);
  final ApiProvider _apiPublic = ApiProvider(baseUrl: ApiEndpoints.baseUrl1);
  final ApiProvider _apiRozarPay = ApiProvider(baseUrl: '');

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
    required String flatNumber,
    required String societyName,
    required String galiNumber,
    required String landmark,
    required String city,
    required String state,
    required String email,
    required String photo,
    required String pinCode,
    required String role,

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
          "housenumber": houseNumber,
          "flatnumber": flatNumber,
          "societyname": societyName,
          "galinumber": galiNumber,
          "landmark": landmark,
          "city": city,
          "state": state,
          "email": email,
          "photo": photo,
          "pincode": pinCode,
          "role": role,
          "status": 0,
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
      String subscriptionId
  ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.buySubscription, // change endpoint if needed
        {
          "customerid": AppSession.userId,
          "orderid": 0,
          "subscriptionid" :subscriptionId,
          "totalamount": totalAmount,
          "trans_id": transId
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
      String orderId
      ) async {
    try {
      final response = await _api.post(
        ApiEndpoints.buySubscription, // change endpoint if needed
        {
          "customerid": AppSession.userId,
          "orderid": orderId,
          "subscriptionid" :0,
          "totalamount": totalAmount,
          "trans_id": transId
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

  Future<AdminOrderListModel> adminOrderApi() async {
    try {
      final response = await _api.post(
        ApiEndpoints.adminOrderList, // change endpoint if needed
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
}
