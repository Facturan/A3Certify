import 'package:a3certify/request_page/constants/title_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'constants/title_types.dart';
import 'package:a3certify/reusesable_widget/reusable_widget.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _requestService = RequestService();
  bool _isSubmitting = false;

  final List<String> _titleTypes = [
    'Original Certificate of Title',
    'Transfer Certificate of Title',
    'Condominium Certificate of Title',
  ];

  final _formKey = GlobalKey<FormState>();

  final _titleNumberController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _purposeController = TextEditingController();
  final _registryOfDeedsController = TextEditingController();
  String? _selectedTitleType;
  final _dateOfTransferController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _buildingNameController = TextEditingController();

  Future<bool?> _showConfirmationDialog() async {
    return showConfirmationDialog(context: context);
  }

  void _showProcessingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Request...')),
    );
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error submitting request: $errorMessage')),
    );
  }

  void _disposeAndClear() {
    _titleNumberController.clear();
    _ownerNameController.clear();
    _addressController.clear();
    _contactNumberController.clear();
    _emailController.clear();
    _purposeController.clear();
    _registryOfDeedsController.clear();
    _dateOfTransferController.clear();
    _unitNumberController.clear();
    _floorNumberController.clear();
    _buildingNameController.clear();

    _selectedTitleType = null;
    if (_formKey.currentState != null) {
      _formKey.currentState!.reset();
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTitleType == null) {
      _showErrorSnackBar('Please select a title type');
      return;
    }

    bool? shouldSubmit = await _showConfirmationDialog();
    if (shouldSubmit != true || !mounted) {
      return;
    }

    try {
      setState(() => _isSubmitting = true);
      _showProcessingSnackBar();

      final sanitizedEmail = _emailController.text.trim().toLowerCase();
      final sanitizedPhone = _contactNumberController.text.replaceAll(RegExp(r'\s+'), '');

      TitleRequest request;
      
      switch (_selectedTitleType) {
        case 'Original Certificate of Title':
          request = TitleRequest(
            uid: user.uid,
            email: sanitizedEmail,
            titleType: _selectedTitleType!,
            registryOfDeeds: _registryOfDeedsController.text.trim(),
            titleNumber: _titleNumberController.text.trim(),
            ownerName: _ownerNameController.text.trim(),
            address: _addressController.text.trim(),
            contactNumber: sanitizedPhone,
            purpose: _purposeController.text.trim(),
            dateOfTransfer: _dateOfTransferController.text.trim(),
          );
          break;

        case 'Transfer Certificate of Title':
          request = TitleRequest(
            uid: user.uid,
            email: sanitizedEmail,
            titleType: _selectedTitleType!,
            registryOfDeeds: _registryOfDeedsController.text.trim(),
            titleNumber: _titleNumberController.text.trim(),
            ownerName: _ownerNameController.text.trim(),
            address: _addressController.text.trim(),
            contactNumber: sanitizedPhone,
            purpose: _purposeController.text.trim(),
            dateOfTransfer: _dateOfTransferController.text.trim(),
            previousOwner: _ownerNameController.text.trim(),
            transferDate: _dateOfTransferController.text.trim(),
            transferPurpose: _purposeController.text.trim(),
          );
          break;

        case 'Condominium Certificate of Title':
          if (_unitNumberController.text.isEmpty || 
              _floorNumberController.text.isEmpty || 
              _buildingNameController.text.isEmpty) {
            throw Exception('Please fill in all condominium details');
          }
          request = TitleRequest(
            uid: user.uid,
            email: sanitizedEmail,
            titleType: _selectedTitleType!,
            registryOfDeeds: _registryOfDeedsController.text.trim(),
            titleNumber: _titleNumberController.text.trim(),
            ownerName: _ownerNameController.text.trim(),
            address: _addressController.text.trim(),
            contactNumber: sanitizedPhone,
            purpose: _purposeController.text.trim(),
            dateOfTransfer: _dateOfTransferController.text.trim(),
            unitNumber: _unitNumberController.text.trim(),
            floorNumber: _floorNumberController.text.trim(),
            buildingName: _buildingNameController.text.trim(),
            condoName: _buildingNameController.text.trim(),
          );
          break;

        default:
          throw Exception('Invalid title type selected');
      }

      await _requestService.submitRequest(request);
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      _disposeAndClear();
      
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'An unexpected error occurred';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'You do not have permission to submit requests';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Please check your internet connection';
      } else if (e.toString().contains('condominium details')) {
        errorMessage = e.toString();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Request Certified True Copy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _registryOfDeedsController,
                decoration: const InputDecoration(
                  labelText: 'Registry of Deeds *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Registry of Deeds';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTitleType,
                decoration: const InputDecoration(
                  labelText: 'Title Type *',
                  border: OutlineInputBorder(),
                ),
                items: _titleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTitleType = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the title type';
                  }
                  return null;
                },
              ),
              TitleTypeFields(
                titleType: _selectedTitleType ?? '',
                dateOfTransferController: _dateOfTransferController,
                unitNumberController: _unitNumberController,
                floorNumberController: _floorNumberController,
                buildingNameController: _buildingNameController,
                context: context,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Title Number *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Property Address *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the property address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactNumberController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number *',
                  border: OutlineInputBorder(),
                  hintText: '+63 XXX XXX XXXX',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose of Request *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purpose of your request';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: elevatedButton(
                  context,
                  'Submit',
                  _isSubmitting ? () {} : _submitRequest,
                  57,
                  88,
                  134,
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleNumberController.dispose();
    _ownerNameController.dispose();
    _addressController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _purposeController.dispose();
    _registryOfDeedsController.dispose();
    _dateOfTransferController.dispose();
    _unitNumberController.dispose();
    _floorNumberController.dispose();
    _buildingNameController.dispose();
    super.dispose();
  }
}