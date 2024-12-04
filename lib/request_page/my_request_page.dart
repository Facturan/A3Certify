import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/request_constants.dart';
import '../services/firestore_service.dart';
import 'constants/request_utils.dart';
import 'request_widgets.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({super.key});

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  final RequestService _requestService = RequestService();
  final user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _requestsStream;
  bool _isLoading = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _initializeRequestsStream();
    _initializeAdminStatus();
  }

  void _initializeRequestsStream() {
    if (user != null) {
      _requestsStream = FirebaseFirestore.instance
          .collection('requests')
          .where('uid', isEqualTo: user!.uid)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
  }

  void _initializeAdminStatus() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((doc) {
        if (mounted && doc.exists) {
          setState(() {
            _isAdmin = doc.data()?['isAdmin'] == true;
          });
        }
      });
    }
  }

  Future<void> _refreshRequests() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      _initializeRequestsStream();
      await Future.delayed(RequestConstants.refreshDelay);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error refreshing requests: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
// showErrorSnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.45,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.45,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please login to view your requests',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Requests',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshRequests,
      child: StreamBuilder<QuerySnapshot>(
        stream: _requestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error.toString(),
              onRetry: _refreshRequests,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          
          if (docs.isEmpty) {
            return const EmptyRequestsView();
          }

          return _buildRequestsList(docs);
        },
      ),
    );
  }

  Widget _buildRequestsList(List<QueryDocumentSnapshot> docs) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildRequestItem(docs[index]),
    );
  }

  Widget _buildRequestItem(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'] ?? 'Pending';
    final statusColor = RequestUtils.getStatusColor(status);
    final adminComment = data['adminComment'] as String? ?? '';
    final processedAt = data['processedAt'] as Timestamp?;
    final paymentStatus = data['paymentStatus'] as String? ?? 'unpaid';
    final requestUserId = data['uid'] as String?;

    // Only allow editing if:
    // 1. Request is pending
    // 2. User is the owner of the request or is an admin
    final canEdit = status.toLowerCase() == 'pending' && 
                   (requestUserId == user?.uid || _isAdmin);

    return RequestCard(
      status: status,
      statusColor: statusColor,
      titleType: data['titleType'] ?? '',
      titleNumber: data['titleNumber'] ?? '',
      registryOfDeeds: data['registryOfDeeds'] ?? '',
      dateSubmitted: RequestUtils.formatTimestamp(data['createdAt'] as Timestamp?),
      amount: RequestUtils.formatAmount(data['amount']),
      email: data['email'] ?? 'lennongwapo123@gmail.com',
      adminComment: adminComment.isNotEmpty ? adminComment : null,
      processedDate: processedAt != null ? RequestUtils.formatTimestamp(processedAt) : null,
      paymentStatus: paymentStatus,
      onEdit: canEdit ? () => _showEditDialog(doc.id, data) : null,
      onCancel: (status.toLowerCase() == 'pending' && requestUserId == user?.uid)
          ? () => _handleStatusChange(doc.id, 'cancelled')
          : null,
      onApprove: (_isAdmin && status.toLowerCase() == 'pending')
          ? () => _handleStatusChange(doc.id, 'approved')
          : null,
    );
  }

  Future<void> _handleStatusChange(String docId, String status) async {
    if (!mounted) return;
    
    try {
      final updates = {
        'status': status,
        'processedAt': FieldValue.serverTimestamp(),
      };
      
      await _requestService.updateRequestWithData(docId, updates);
      
      if (mounted) {
        if (status.toLowerCase() == 'cancelled') {
          _showSuccessSnackBar('Request cancelled.');
        } else if (status.toLowerCase() == 'approved') {
          _showSuccessSnackBar('Request approved.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error updating request: $e');
      }
    }
  }

  Future<void> _showEditDialog(String docId, Map<String, dynamic> currentData) async {
    if (!mounted) return;

    // Double check permissions before showing dialog
    final status = currentData['status']?.toLowerCase() ?? 'pending';
    final requestUserId = currentData['uid'] as String?;
    if (status != 'pending' || (requestUserId != user?.uid && !_isAdmin)) {
      _showErrorSnackBar('You do not have permission to edit this request.');
      return;
    }

    final controllers = _initializeControllers(currentData);
    bool? savePressed;

    try {
      savePressed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit ${currentData['titleType']} Details'),
          content: SingleChildScrollView(
            child: _buildEditForm(currentData, controllers),
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

      if (savePressed == true && mounted) {
        await _updateRequest(docId, currentData, controllers);
      }
    } finally {
      // Dispose controllers
      for (var controller in controllers.values) {
        controller.dispose();
      }
    }
  }

  Map<String, TextEditingController> _initializeControllers(Map<String, dynamic> data) {
    return {
      'titleNumber': TextEditingController(text: data['titleNumber']),
      'registryOfDeeds': TextEditingController(text: data['registryOfDeeds']),
      'ownerName': TextEditingController(text: data['ownerName']),
      'address': TextEditingController(text: data['address']),
      'contactNumber': TextEditingController(text: data['contactNumber']),
      'purpose': TextEditingController(text: data['purpose']),
      'dateOfTransfer': TextEditingController(text: data['dateOfTransfer']),
      'unitNumber': TextEditingController(text: data['unitNumber']),
      'floorNumber': TextEditingController(text: data['floorNumber']),
      'buildingName': TextEditingController(text: data['buildingName']),
    };
  }

  Widget _buildEditForm(
    Map<String, dynamic> currentData,
    Map<String, TextEditingController> controllers,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(controllers['titleNumber']!, 'Title Number'),
        _buildTextField(controllers['registryOfDeeds']!, 'Registry of Deeds'),
        _buildTextField(controllers['ownerName']!, 'Owner Name'),
        _buildTextField(controllers['address']!, 'Address', maxLines: 2),
        _buildTextField(controllers['contactNumber']!, 'Contact Number',
            keyboardType: TextInputType.phone),
        _buildTextField(controllers['purpose']!, 'Purpose'),
        if (currentData['titleType'] == 'Condominium Certificate of Title') ...[
          _buildTextField(controllers['unitNumber']!, 'Unit Number'),
          _buildTextField(controllers['floorNumber']!, 'Floor Number'),
          _buildTextField(controllers['buildingName']!, 'Building Name'),
        ],
        _buildDateField(controllers['dateOfTransfer']!),
        // Display amount as read-only text
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Amount',
              enabled: false,
            ),
            child: Text(
              '₱${RequestUtils.formatAmount(currentData['amount'])}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Date of Transfer'),
        readOnly: true,
        onTap: () async {
          final date = await RequestUtils.pickDate(context);
          if (date != null) {
            controller.text = date;
          }
        },
      ),
    );
  }

  Future<void> _updateRequest(
    String docId,
    Map<String, dynamic> currentData,
    Map<String, TextEditingController> controllers,
  ) async {
    try {
      final updates = <String, dynamic>{};
      
      // Only add fields that have changed
      for (var entry in controllers.entries) {
        final newValue = entry.value.text.trim();
        final currentValue = currentData[entry.key]?.toString().trim() ?? '';
        
        if (newValue != currentValue) {
          updates[entry.key] = newValue;
        }
      }

      // Only update if there are changes
      if (updates.isNotEmpty) {
        await _requestService.updateRequestDetails(docId, updates);
        if (mounted) {
          _showSuccessSnackBar('Request updated successfully');
          _initializeRequestsStream(); // Refresh the stream
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error updating request: $e');
      }
    }
  }
}
