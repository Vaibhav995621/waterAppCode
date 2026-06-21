import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utlis/network/repositories/auth_repository.dart';
import '../../../../utlis/progress_hud/app_snackbar.dart';
import '../../../app_session/app_session.dart';
import '../../../models/profile_model/profile_model.dart';

class CustomerHomeController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  Rxn<ProfileModel> profile =
  Rxn<ProfileModel>();


  var userName = "".obs;
  var currentPlan = "".obs;
  var nextDeliveryDate = "".obs;
  var orderId = "".obs;
  var orderStatus = "0".obs;
  var bottleType = "".obs;
  var quantity = "".obs;
  var deliveryTime = "".obs;


  RxString bottles = "".obs;
  RxInt originalPrice = 0.obs;
  RxInt discountedPrice = 0.obs;

  double get perBottlePrice =>
      discountedPrice.value / 15;
  int get savedAmount =>
      originalPrice.value - discountedPrice.value;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
  }

  void bookWater() {
    // API call or navigation
    Get.toNamed(AppRoutes.bookingWaterScreen);

    //Get.snackbar("Booked", "Water booked successfully");
  }

  void viewAllOrders() {
    Get.snackbar("Orders", "Opening all orders");
  }


  Future<bool> getProfile() async {
    try {
      var custId = AppSession.userId;
      final user =
      await _repo.getUserProfile(custId);

      if (user.statusCode == '201') {
        AppSnackbar.error(user.message);
        return false;
      }

      if (user.statusCode == '200') {
        AppSession.saveUser(
          userId: AppSession.userId,
          token: '',
          image: user.data.photo,
          name: user.data.fullname ?? '',
          role: user.data.role,
          planType: user.data.plandetail.id
        );
        profile.value = user;
      }
      update();
      return true;
    } catch (e) {
      AppSnackbar.error(
        e.toString().replaceAll("Exception: ", ""),
      );
      return false;
    } finally {
    }
  }

}