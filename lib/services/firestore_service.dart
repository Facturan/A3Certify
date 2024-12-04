import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../request_page/constants/title_request.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Create or update user document
  Future<void> createOrUpdateUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set(
            userData,
            SetOptions(merge: true),
          );
    } catch (e) {
      throw 'Failed to create/update user: $e';
    }
  }

  // Get user document
  Future<DocumentSnapshot> getUserDocument(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      throw 'Failed to get user document: $e';
    }
  }

  // Check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      if (currentUserId == null) return false;
      final userDoc = await getUserDocument(currentUserId!);
      return userDoc.exists &&
          (userDoc.data() as Map<String, dynamic>)['isAdmin'] == true;
    } catch (e) {
      return false;
    }
  }

  // Create request document
  Future<void> createRequest(Map<String, dynamic> requestData) async {
    try {
      // Add timestamp and status
      requestData['createdAt'] = FieldValue.serverTimestamp();
      requestData['status'] = 'pending';
      requestData['uid'] = currentUserId;
      requestData['updatedAt'] = FieldValue.serverTimestamp();
      requestData['adminComment'] = ''; // Field for admin comments
      requestData['processedBy'] = ''; // Field for admin who processed
      requestData['processedAt'] = null; // Timestamp when processed
      requestData['paymentStatus'] = 'unpaid'; // Payment status
      requestData['amount'] = calculateAmount(
          requestData['titleType']); // Calculate based on title type

      await _firestore.collection('requests').add(requestData);
    } catch (e) {
      throw 'Failed to create request: $e';
    }
  }

  double calculateAmount(String titleType) {
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

  // Get user's requests
  Stream<QuerySnapshot> getUserRequests() {
    try {
      return _firestore
          .collection('requests')
          .where('uid', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw 'Failed to get user requests: $e';
    }
  }

  // Get all requests (admin only)
  Stream<QuerySnapshot> getAllRequests() {
    try {
      return _firestore
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw 'Failed to get all requests: $e';
    }
  }

  // Update request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update request status: $e';
    }
  }

  // Update request details
  Future<void> updateRequestDetails(
      String requestId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('requests').doc(requestId).update(updates);
    } catch (e) {
      throw 'Failed to update request details: $e';
    }
  }

  // Update request with additional data
  Future<void> updateRequestWithData(
      String docId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('requests').doc(docId).update(updates);
    } catch (e) {
      throw 'Failed to update request: $e';
    }
  }

  // Delete request
  Future<void> deleteRequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).delete();
    } catch (e) {
      throw 'Failed to delete request: $e';
    }
  }
}

class RequestService {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> submitRequest(TitleRequest request) async {
    try {
      await _firestoreService.createRequest({
        'uid': request.uid,
        'registryOfDeeds': request.registryOfDeeds,
        'titleType': request.titleType,
        'titleNumber': request.titleNumber,
        'ownerName': request.ownerName,
        'address': request.address,
        'contactNumber': request.contactNumber,
        'email': request.email,
        'purpose': request.purpose,
        'dateOfTransfer': request.dateOfTransfer,
        'unitNumber': request.unitNumber,
        'floorNumber': request.floorNumber,
        'buildingName': request.buildingName,
      });
    } catch (e) {
      throw 'Failed to submit request: $e';
    }
  }

  Stream<QuerySnapshot> getUserRequests() {
    return _firestoreService.getUserRequests();
  }

  Future<void> updateRequestStatus(String docId, String status) async {
    try {
      await _firestoreService.updateRequestStatus(docId, status);
    } catch (e) {
      throw 'Failed to update request status: $e';
    }
  }

  Future<void> updateRequestWithData(
      String docId, Map<String, dynamic> updates) async {
    try {
      await _firestoreService.updateRequestWithData(docId, updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateRequestDetails(
      String docId, Map<String, dynamic> updates) async {
    try {
      await _firestoreService.updateRequestDetails(docId, updates);
    } catch (e) {
      rethrow;
    }
  }
}
