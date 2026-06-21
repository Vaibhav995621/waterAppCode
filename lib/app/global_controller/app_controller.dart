
import 'package:get/get.dart';

enum UserRole { customer, admin, delivery }

class AppController extends GetxController {
  var role = UserRole.customer.obs;

  void setRole(UserRole newRole) {
    role.value = newRole;
  }
}
