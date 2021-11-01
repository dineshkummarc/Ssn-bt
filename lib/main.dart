import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:ssnbt/controllers/auth_controller.dart';
import 'package:ssnbt/controllers/storage_controller.dart';
import 'package:ssnbt/screens/home.dart';
import 'package:ssnbt/screens/select_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  Get.put(StorageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ssn Bus Tracking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  AuthWrapper({Key? key}) : super(key: key);
  final _controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_controller.user == null) {
          return SelectMode();
        } else {
          return Home();
        }
      },
    );
  }
}
