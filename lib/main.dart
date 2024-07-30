import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:planlistapp/controller/auth_controller.dart';
import 'screens/reminder/reminder_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/authentication/signin_screen.dart';
import 'screens/authentication/signup_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBohvgaUl6L4uOgH00zTPJ9gajFT5kH06Q',
          appId: '1:1061340510225:android:66f3d2f9dd1d9a415299b0',
          messagingSenderId: 'sendid',
          projectId: 'planlistapp',
          storageBucket: 'planlistapp.appspot.com'));

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => Obx(() {
                  return authController.isLoggedIn.value
                      ? ReminderScreen()
                      : WelcomeScreen();
                })),
        GetPage(name: '/signin', page: () => const SignInPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
      ],
    );
  }
}
