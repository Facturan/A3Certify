import 'package:a3certify/screens/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AvatarCard extends StatefulWidget {
  const AvatarCard({super.key});

  @override
  State<AvatarCard> createState() => _AvatarCardState();
}

class _AvatarCardState extends State<AvatarCard> {
  final user = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;
  final _imagePicker = ImagePicker();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _imageBase64 = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String _formatName(String? email) {
    if (email == null) return '';
    final parts = email.split('@')[0].split('.');
    if (parts.length >= 2) {
      return '${_capitalizeFirst(parts[0])} ${_capitalizeFirst(parts[1])}';
    }
    return _capitalizeFirst(parts[0]);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user!.uid).get();

        // Parse name from auth data
        String firstName = '', lastName = '';
        if (user!.displayName != null) {
          final nameParts = user!.displayName!.split(' ');
          firstName = nameParts[0];
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        } else if (user!.email != null) {
          final formattedName = _formatName(user!.email);
          final nameParts = formattedName.split(' ');
          firstName = nameParts[0];
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        }

        if (!doc.exists) {
          // Create new user document if it doesn't exist
          await _firestore.collection('users').doc(user!.uid).set({
            'firstName': firstName,
            'lastName': lastName,
            'email': user!.email ?? '',
            'profileImage': '',
            'createdAt': FieldValue.serverTimestamp(),
            'lastUpdated': FieldValue.serverTimestamp(),
          });

          setState(() {
            _firstName = firstName;
            _lastName = lastName;
            _email = user!.email ?? '';
            _imageBase64 = '';
          });
        } else {
          // Update existing user document with auth data if needed
          final userData = doc.data()!;
          final needsUpdate = userData['firstName'] == null || 
                            userData['lastName'] == null ||
                            userData['email'] != user!.email;

          if (needsUpdate) {
            await _firestore.collection('users').doc(user!.uid).update({
              'firstName': userData['firstName'] ?? firstName,
              'lastName': userData['lastName'] ?? lastName,
              'email': user!.email ?? '',
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          }

          setState(() {
            _firstName = userData['firstName'] ?? firstName;
            _lastName = userData['lastName'] ?? lastName;
            _email = userData['email'] ?? user!.email ?? '';
            _imageBase64 = userData['profileImage'] ?? '';
          });
        }
      } catch (e) {
        // Fallback to Firebase Auth data if Firestore fails
        final formattedName = _formatName(user!.email);
        final nameParts = formattedName.split(' ');
        
        setState(() {
          _firstName = nameParts[0];
          _lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          _email = user!.email ?? '';
          _imageBase64 = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString().split('] ').last}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (user == null) return;

    final firstNameController = TextEditingController(text: _firstName);
    final lastNameController = TextEditingController(text: _lastName);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
              ),
            ),
            const SizedBox(height: 16),
            Text('Email: $_email',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _firestore.collection('users').doc(user!.uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      setState(() {
        _firstName = firstNameController.text.trim();
        _lastName = lastNameController.text.trim();
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    if (user == null) return;

    try {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (_imageBase64.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.pop(context, null),
                ),
            ],
          ),
        ),
      );

      if (source == null && _imageBase64.isNotEmpty) {
        if (!mounted) return;
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Profile Picture'),
            content: const Text(
                'Are you sure you want to remove your profile picture?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remove'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await _removeProfilePicture();
        }
        return;
      }

      if (source == null) return;

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90, // Higher quality
      );

      if (image == null) return;

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Read image bytes and handle large files
      final bytes = await image.readAsBytes();
      String base64Image;
      
      if (bytes.length > 1024 * 1024) { // If larger than 1MB
        // Compress image
        final quality = (1024 * 1024 / bytes.length * 100).round();
        final compressedImage = await _imagePicker.pickImage(
          source: source,
          imageQuality: quality.clamp(1, 100),
        );
        
        if (compressedImage == null) {
          if (!mounted) return;
          Navigator.pop(context);
          return;
        }
        
        final compressedBytes = await compressedImage.readAsBytes();
        base64Image = base64Encode(compressedBytes);
      } else {
        base64Image = base64Encode(bytes);
      }

      // Update Firestore with base64 image
      await _firestore.collection('users').doc(user!.uid).update({
        'profileImage': base64Image,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _imageBase64 = base64Image;
      });

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture updated successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      
      String errorMessage = 'Error updating profile picture';
      if (e.toString().contains('storage/unauthorized')) {
        errorMessage = 'Image size too large or format not supported';
      } else if (e.toString().contains('permission-denied')) {
        errorMessage = 'Permission denied to access camera or gallery';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeProfilePicture() async {
    try {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await _firestore.collection('users').doc(user!.uid).update({
        'profileImage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _imageBase64 = '';
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture removed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().split('] ').last}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ImageProvider _getProfileImage() {
    if (_imageBase64.isEmpty) {
      return const AssetImage("assets/images/pfp4.png");
    }
    try {
      final imageBytes = base64Decode(_imageBase64);
      return MemoryImage(imageBytes);
    } catch (e) {
      print('Error loading profile image: $e');
      return const AssetImage("assets/images/pfp4.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _updateProfilePicture,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _getProfileImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: _updateProfile,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_firstName.trim()} ${_lastName.trim()}'.trim(),
                  style: const TextStyle(
                    fontSize: kbigFontSize,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                  ),
                ),
                Text(
                  _email,
                  style: TextStyle(
                    fontSize: ksmallFontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
