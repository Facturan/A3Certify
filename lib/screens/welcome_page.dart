import 'package:flutter/material.dart';
import '../reusesable_widget/reusable_widget.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Image.asset('assets/images/logo.png'),
            const Text(
              "WELCOME to A3Certify",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "The process of requesting CTC's",
            ),
            const Text("Anytime, Anywhere, Any, place!."),
            const SizedBox(
              height: 60,
            ),
            elevatedButton(
              context,
              'Login',
              () {
                Navigator.pushNamed(context, '/login');
              },
              57,
              88,
              134,
              const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(
                  255,
                  57,
                  88,
                  134,
                )),
                color: Color.fromARGB(255, 213, 222, 239),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  'Register',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ).copyWith(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
