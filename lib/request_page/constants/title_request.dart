import 'package:cloud_firestore/cloud_firestore.dart';

class TitleRequest {
  final String uid;
  final String email;
  final String titleType;
  final String registryOfDeeds;
  final String titleNumber;
  final String ownerName;
  final String address;
  final String contactNumber;
  final String purpose;
  final String dateOfTransfer;

  // Fields for Transfer Certificate of Title
  final String? previousOwner;
  final String? transferDate;
  final String? transferPurpose;

  // Fields for Condominium Certificate of Title
  final String? unitNumber;
  final String? floorNumber;
  final String? buildingName;
  final String? condoName;

  TitleRequest({
    required this.uid,
    required this.email,
    required this.titleType,
    required this.registryOfDeeds,
    required this.titleNumber,
    required this.ownerName,
    required this.address,
    required this.contactNumber,
    required this.purpose,
    required this.dateOfTransfer,
    this.previousOwner,
    this.transferDate,
    this.transferPurpose,
    this.unitNumber,
    this.floorNumber,
    this.buildingName,
    this.condoName,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'uid': uid,
      'email': email,
      'titleType': titleType,
      'registryOfDeeds': registryOfDeeds,
      'titleNumber': titleNumber,
      'ownerName': ownerName,
      'address': address,
      'contactNumber': contactNumber,
      'purpose': purpose,
      'dateOfTransfer': dateOfTransfer,
      'status': 'pending',
      'adminComment': '',
      'processedBy': '',
      'processedAt': null,
      'paymentStatus': 'unpaid',
      'amount': _calculateAmount(titleType),
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Add conditional fields based on title type
    if (titleType == 'Transfer Certificate of Title') {
      data.addAll({
        'previousOwner': previousOwner,
        'transferDate': transferDate,
        'transferPurpose': transferPurpose,
      });
    } else if (titleType == 'Condominium Certificate of Title') {
      data.addAll({
        'unitNumber': unitNumber,
        'floorNumber': floorNumber,
        'buildingName': buildingName,
        'condoName': condoName,
      });
    }

    return data;
  }

  double _calculateAmount(String titleType) {
    switch (titleType) {
      case 'Original Certificate of Title':
        return 500.00;
      case 'Transfer Certificate of Title':
        return 750.00;
      case 'Condominium Certificate of Title':
        return 1000.00;
      default:
        return 500.00;
    }
  }
}
