import 'package:a3certify/services/authentication.dart';
import 'package:a3certify/settingnav/logout_helper.dart';
import 'package:a3certify/settingnav/personal_data.dart';
import 'package:a3certify/screens/login_page.dart';
import 'package:a3certify/request_page/my_request_page.dart';
import 'package:a3certify/request_page/request_page.dart';
import 'package:a3certify/request_page/request_status.dart';
import 'package:a3certify/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'user_registration/personal_information_page.dart';
import 'user_registration/register_page.dart';
import 'screens/home_page.dart';
import 'package:a3certify/request_page/history.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const A3Certify());
}

class A3Certify extends StatelessWidget {
  const A3Certify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A3Certify',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 57, 88, 134),
        scaffoldBackgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Authentication(),
        '/welcome': (context) => const Welcome(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const Login(),
        '/requestpage': (context) => const RequestPage(),
        '/myrequestpage': (context) => const MyRequestPage(),
        '/personaldata' : (context) => const PersonalData(),
        '/requeststatus' : (context) => const RequestStatus(),
        '/signup' : (context) => const SignupPage(),
        '/register' : (context) => const RegisterPage(),
        '/history' : (context) => const HistoryPage(),
        '/homescreen': (context) => const HomeScreen(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
