import 'package:flutter/material.dart';
import '../reusesable_widget/reusable_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedGender = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 57, 88, 134),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 57, 88, 134),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final safeHeight = size.height - padding.top - padding.bottom;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
          const  SizedBox(height: 20,),
            Text(
            'Personal Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 57, 88, 134),
              fontSize: size.width * 0.05,
            ),
          ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 15 : 30,
                horizontal: size.width * 0.05,
              ),
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
                  _buildSectionTitle('Basic Details'),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: _buildInputDecoration('First Name', Icons.person_outline),
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  TextFormField(
                    controller: _middleNameController,
                    decoration: _buildInputDecoration('Middle Name', Icons.person_outline),
                  ),
                  SizedBox(height: safeHeight * 0.02),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: _buildInputDecoration('Last Name', Icons.person_outline),
                  ),
                  SizedBox(height: safeHeight * 0.03),
                  _buildSectionTitle('Additional Information'),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
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
                      ),
                      child: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'dd/mm/yyyy',
                      ),
                    ),
                  ),
                 const SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: safeHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          'Gender:',
                          style: TextStyle(fontSize: size.width * 0.04),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 'Female',
                                groupValue: _selectedGender,
                                activeColor: const Color.fromARGB(255, 57, 88, 134),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value.toString();
                                  });
                                },
                              ),
                              Text(
                                'Female',
                                style: TextStyle(fontSize: size.width * 0.035),
                              ),
                              SizedBox(width: size.width * 0.05),
                              Radio(
                                value: 'Male',
                                groupValue: _selectedGender,
                                activeColor: const Color.fromARGB(255, 57, 88, 134),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value.toString();
                                  });
                                },
                              ),
                              Text(
                                'Male',
                                style: TextStyle(fontSize: size.width * 0.035),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: safeHeight * 0.03),
                  TextFormField(
                    controller: _mobileController,
                    decoration: _buildInputDecoration('Mobile Number', Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: safeHeight * 0.03),
                  Center(
                    child: elevatedButton(
                      context,
                      'Next',
                      () {
                        // Validate required fields
                        if (_firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty ||
                            _mobileController.text.isEmpty ||
                            _selectedDate == null ||
                            _selectedGender.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all required fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Create user data map
                        final userData = {
                          'firstName': _firstNameController.text,
                          'middleName': _middleNameController.text,
                          'lastName': _lastNameController.text,
                          'dateOfBirth': _selectedDate,
                          'gender': _selectedGender,
                          'mobile': _mobileController.text,
                        };

                        Navigator.pushNamed(
                          context,
                          '/register',
                          arguments: userData,
                        );
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
                  SizedBox(height: safeHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
