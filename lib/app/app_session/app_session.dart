import 'package:get_storage/get_storage.dart';

class AppSession {
  static final GetStorage _box = GetStorage();

  /// Save login data in ONE write
  static Future<void> saveUser({
    required String userId,
    required String token,
    required String name,
    required String image,
    required int role,
    required int planType,
    required int usertype
  }) async {
    await _box.write('user', {
      'userId': userId,
      'token': token,
      'name': name,
      'image' : image,
      'role': role,
      'planType' : planType,
      'usertype': usertype
    });

    await _box.save(); // force flush
  }

  static Map<String, dynamic> get user =>
      Map<String, dynamic>.from(
        _box.read('user') ?? {},
      );

  static String get userId =>
      user['userId']?.toString() ?? '';
  static int get usertype =>
      user['usertype'] ?? 0;
  static String get token =>
      _box.read('fcmToken')?.toString() ?? '';

  static String get name =>
      user['name']?.toString() ?? '';

  static String get image =>
      user['image']?.toString() ?? '';

  static int get role =>
      int.tryParse(user['role'].toString()) ?? 0;

  static int get planType =>
      user['planType'] ?? 0;

  static bool get isLoggedIn =>
      userId.isNotEmpty;

  static Future<void> clear() async {
    await _box.erase();
  }

  static Future<void> saveFcmToken(String token) async {
    await _box.write('fcmToken', token);
    await _box.save();
  }

  static String get fcmToken =>
      _box.read('fcmToken')?.toString() ?? '';
}