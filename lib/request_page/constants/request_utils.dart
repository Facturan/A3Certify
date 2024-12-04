import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestUtils {
  static Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'approved':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  static String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Date not available';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  static String formatAmount(dynamic amount) {
    if (amount == null) return '0.00';
    return amount.toString();
  }

  static Future<String?> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      return '${date.day}/${date.month}/${date.year}';
    }
    return null;
  }
}
