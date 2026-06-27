import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app_session/app_session.dart';
import 'app/services/firebase_notification_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await FirebaseNotificationService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zourney App',
      initialRoute: AppSession.userId.isNotEmpty
          ? AppRoutes.mainNavigation
          : AppRoutes.welcomeScreen,
      getPages: AppPages.routes,
    );
  }
}
