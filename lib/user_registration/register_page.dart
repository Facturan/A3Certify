import 'package:flutter/material.dart';
import '../reusesable_widget/reusable_widget.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  InputDecoration _buildInputDecoration(String label, IconData icon,
      {bool isPassword = false, bool? obscureText, VoidCallback? onToggle}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 57, 88, 134),
          width: 2,
        ),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureText! ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final safeHeight = size.height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
        title: Text(
          'Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 57, 88, 134),
            fontSize: size.width * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 30,
                horizontal: size.width * 0.05,
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/a3certify.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 57, 88, 134),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration:
                        _buildInputDecoration('Email', Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _buildInputDecoration(
                      'Password',
                      Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onToggle: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    obscureText: _obscurePassword,
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: _buildInputDecoration(
                      'Confirm Password',
                      Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    obscureText: _obscureConfirmPassword,
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value!;
                          });
                        },
                        activeColor: const Color.fromARGB(255, 57, 88, 134),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Terms & Conditions'),
                                content: SingleChildScrollView(
                                  child: Text(
                                    'By using A3Certify, you agree to our Terms & Conditions...\n\n'
                                    '1. Your use of the service is subject to these Terms.\n'
                                    '2. You must provide accurate information during registration.\n'
                                    '3. You are responsible for maintaining the security of your account.\n'
                                    '4. We reserve the right to modify or terminate the service.\n'
                                    '5. You agree to use the service in compliance with all applicable laws.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            'I accept the Terms & Conditions',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 57, 88, 134),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.8,
                      child: _isLoading
                          ? Column(
                              children: [
                                const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 57, 88, 134),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Creating your account...',
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 57, 88, 134),
                                    fontSize: size.width * 0.04,
                                  ),
                                ),
                              ],
                            )
                          : elevatedButton(
                              context,
                              'Register',
                              () async {
                                if (!_acceptedTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please accept the Terms & Conditions'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Passwords do not match'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                // Get user data from previous screen
                                final userData = ModalRoute.of(context)!
                                    .settings
                                    .arguments as Map<String, dynamic>;

                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // Register user
                                  final error = await _authService.registerUser(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    userData: userData,
                                  );

                                  if (error != null) {
                                    throw Exception(error);
                                  }

                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    // Show verification email sent message
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        // Start waiting for email verification
                                        _waitForVerification(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                        );

                                        return AlertDialog(
                                          title: const Text('Verify Your Email'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                'A verification email has been sent to your email address.',
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Please verify your email to continue.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 16),
                                              CircularProgressIndicator(),
                                              SizedBox(height: 16),
                                              Text(
                                                'Waiting for verification...',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              57,
                              88,
                              134,
                              TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _waitForVerification({
    required String email,
    required String password,
  }) async {
    try {
      final verified = await _authService.waitForEmailVerification(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close the verification dialog

        if (verified) {
          // Show success message and navigate to login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully! Please login.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate to login page and clear stack
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        } else {
          // Show timeout message and stay on current page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email verification timed out. Please try registering again.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close the verification dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during verification: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
