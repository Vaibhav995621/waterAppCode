import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_controller/bottomTabBar/main_navigation_screen.dart';
import '../../models/login_model/login_model.dart';
import '../../../utlis/network/repositories/auth_repository.dart';
import '../../../utlis/progress_hud/app_snackbar.dart';
import '../../app_session/app_session.dart';

class SignupVerifyOtpController extends GetxController {
  final FocusNode otp1Focus = FocusNode();
  final FocusNode otp2Focus = FocusNode();
  final FocusNode otp3Focus = FocusNode();
  final FocusNode otp4Focus = FocusNode();

  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();

  final AuthRepository _repo = AuthRepository();
  late final LoginModel user;
  late final String mobile;
  late final String email;
  final RxString currentOtp = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is LoginModel) {
      user = args;
      mobile = user.data.mobile;
      email = user.data.email;
      currentOtp.value = user.data.otp ?? '';
    } else {
      user = LoginModel(
        statusCode: '200',
        message: '',
        data: Data(
          id: 0,
          usertype: 1,
          plantype: 0,
          username: '',
          fullname: '',
          password: '',
          walletamount: 0,
          mobile: '',
          floornumber: 0,
          housenumber: '',
          flatnumber: '',
          societyname: '',
          galinumber: 0,
          email: '',
          photo: '',
          planbottlequantity: 0,
          status: 1,
          cdate: DateTime.now(),
          role: 1,
          modifiedDate: DateTime.now(),
          fcmToken: '',
          address: Address(
            fulladdress: '',
            floornumber: 0,
            housenumber: '',
            flatnumber: '',
            societyname: '',
            galinumber: '',
            landmark: '',
            city: '',
            state: '',
            pincode: '',
            isDefaultAddress: 1,
            houseFlatFloorNo: '',
            societyGaliBlockNo: '',
            localityid: 0,
            sectornumber: '',
            sectorid: 0,
            stateid: 0,
            districtid: 0,
            subdivisionid: 0,
            subdivisionname: '',
            sector: 0,
            block: '',
          ),
          plandetail: Plandetail(
            id: 0,
            planname: '',
            plandetails: '',
            originalprice: '',
            price: '',
            bottlequantity: 0,
            status: 1,
            cdate: DateTime.now(),
            modifiedDate: DateTime.now(),
            totalsave: 0,
            rateperbottle: 0,
          ),
          razorpaykey: '',
        ),
      );
      mobile = '';
      email = '';
    }
  }

  Future<void> verifyOtp() async {
    final enteredOtp = "${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}".trim();

    if (enteredOtp.length < 4) {
      AppSnackbar.error("Please enter the 4-digit OTP.");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.verifyOtpApi(
        email: email,
        mobile: mobile,
        otp: enteredOtp,
        fcmToken: AppSession.fcmToken,
      );

      if (response.statusCode == '200') {
        final verifiedData = response.data.id != 0 ? response.data : user.data;

        // Save user session
        await AppSession.saveUser(
          userId: verifiedData.id.toString(),
          token: AppSession.fcmToken,
          image: verifiedData.photo,
          name: verifiedData.fullname,
          role: verifiedData.role,
          planType: verifiedData.plandetail.id,
          usertype: verifiedData.usertype,
          mobileNo: verifiedData.mobile,
          rozkey: verifiedData.razorpaykey ?? '',
        );

        FocusManager.instance.primaryFocus?.unfocus();
        AppSnackbar.success("Account verified successfully! Welcome to H2O Express.");

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(() => const MainNavigationScreen());
        });
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Invalid OTP. Please try again.",
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (mobile.isEmpty && email.isEmpty) {
      AppSnackbar.error("Invalid mobile number or email.");
      return;
    }

    try {
      isResending.value = true;
      final response = await _repo.resendOtp(
        email: email,
        mobile: mobile,
      );

      if (response.statusCode == '200') {
        final otp = response.data?.otp;
        if (otp != null) {
          currentOtp.value = otp.toString();
        }
        AppSnackbar.success(
          "OTP resent successfully.${otp != null ? ' Verification OTP is $otp.' : ''}",
        );

        // Clear previous input digits
        otp1Controller.clear();
        otp2Controller.clear();
        otp3Controller.clear();
        otp4Controller.clear();
        otp1Focus.requestFocus();
      } else {
        AppSnackbar.error(
          response.message.isNotEmpty ? response.message : "Failed to resend OTP",
        );
      }
    } catch (e) {
      AppSnackbar.error(e.toString().replaceAll("Exception: ", ""));
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();

    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();

    super.onClose();
  }
}
