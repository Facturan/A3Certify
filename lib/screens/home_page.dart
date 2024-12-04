import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusesable_widget/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.15,
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: width * 0.8,
                        maxWidth: width * 0.9,
                        minHeight: height * 0.25,
                        maxHeight: height * 0.5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 50),
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                
                                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                                final firstName = userData?['firstName'] as String? ?? '';
                                final lastName = userData?['lastName'] as String? ?? '';
                                
                                return Column(
                                  children: [
                                    Text(
                                      '${firstName.trim()} ${lastName.trim()}'.trim(),
                                      style: TextStyle(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.01),
                                  const  Text(
                                      'Welcome to A3Certify',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -(height * 0.12), // Responsive top position
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Calculate responsive dimensions
                        final size = MediaQuery.of(context).size;
                        final profileSize = size.width * 0.3; // 30% of screen width
                        final borderRadius = profileSize / 2; // Half of width for circle

                        if (!snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.asset(
                              'assets/images/pfp4.png',
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        final userData = snapshot.data!.data() as Map<String, dynamic>?;
                        final profileImage = userData?['profileImage'] as String?;

                        if (profileImage == null || profileImage.isEmpty) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.asset(
                              'assets/images/pfp4.png',
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                            ),
                          );
                        }

                        try {
                          final imageBytes = base64Decode(profileImage);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.memory(
                              imageBytes,
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/pfp4.png',
                                  width: profileSize,
                                  height: profileSize,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          );
                        } catch (e) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.asset(
                              'assets/images/pfp4.png',
                              width: profileSize,
                              height: profileSize,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: elevatedButton3(
                          context,
                          'Request Now',
                          () {
                            Navigator.pushNamed(context, '/requestpage');
                          },
                          255,
                          255,
                          255,
                          TextStyle(
                            fontSize: width * 0.030,
                            fontWeight: FontWeight.bold,
                          ),
                          'assets/images/request_now.png',
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: elevatedButton3(
                          context,
                          'Request Status',
                          () {
                            Navigator.pushNamed(context, '/requeststatus');
                          },
                          255,
                          255,
                          255,
                          TextStyle(
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                          'assets/images/status.png',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        elevatedButton3(
                          context,
                          'My Request',
                          () {
                            Navigator.pushNamed(context, '/myrequestpage');
                          },
                          255,
                          255,
                          255,
                          TextStyle(
                            fontSize: width * 0.030,
                            fontWeight: FontWeight.bold,
                          ),
                          'assets/images/my_request.png',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        elevatedButton4(
                          context,
                          'History',
                          () {
                            Navigator.pushNamed(context, '/history');
                          },
                          255,
                          255,
                          255,
                          TextStyle(
                            fontSize: width * 0.030,
                            fontWeight: FontWeight.bold,
                          ),
                          const Icon(Icons.history,
                            size: 85,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
