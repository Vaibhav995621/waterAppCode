import '../app_config.dart';

class ApiEndpoints {
  static String get baseUrl => AppConfig.config.baseUrl;
  static String get baseUrl1 => AppConfig.config.baseUrl1;

  /// Login & OTP
  static const loginApi = "customerlogin";
  static const registerApi = "customerregistration";
  static const addressList = "getaddressbycustomerid";
  static const deleteAddress = "deletecustomeraddressbyid";
  static const setDefaultAddress = "setdefaultaddress";
  static const addAddress = "addaddressbycustomerid";
  static const updateAddress = "updateaddressbyid";





  static const customerGetActiveOrder = "getactiveorderlistbycustomerid";
  static const customerOrderHistory = "getpastorderlistbycustomerid";
  static const getBottleList = "getwaterbottlelist";
  static const getProfile = "getcustomerprofilebyid";
  static const updateProfile = "uploadcustomerphoto";
  static const editProfileData = "updatecustomerprofilebycustomerid";
  static const addOrder = "addorders";


  static const subscriptionList = "getsubscriptionplan";
  static const buySubscription = "savepayentbycustomerid";
  static const paymentHistory = "paymenthistorybycustmerid";

  static const adminDashboard = "dashboard";
  static const subscriptionHistoryList = "getsubscriptionhistorybycustomerid";
  static const adminOrderList = "allorders";
  static const deliverBoyList = "alldeliveryboy";
  static const assignDeliveryBoy = "orderassignedto";
  static const allPaymentHistory = "allpaymenthistory";
  static const deliveryOrderList = "orderactivelistbydeliverypartnerid";
  static const updateorderstatusbyorderid = "updateorderstatusbyorderid";

  static const deliveryPartnerOrderHistory = "getpastorderlistbypartnerid";
  static const getSectorList = "getsectorlist";

}
