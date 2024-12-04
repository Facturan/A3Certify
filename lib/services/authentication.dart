import '../screens/main_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_page.dart';

class Authentication extends StatelessWidget {
  const Authentication ({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapsot){
      if(snapsot.hasData){
        return const MainNav();
      }else{
        return const Login();
      }
    });
  }
}
