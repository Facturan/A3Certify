class RequestConstants {
  static const double defaultAmount = 639.97;
  static const Duration refreshDelay = Duration(milliseconds: 500);
  
  static const Map<String, String> statusMessages = {
    'pending': 'Request is pending approval',
    'cancelled': 'Request has been cancelled',
    'approved': 'Request has been approved',
    'processing': 'Request is being processed',
  };
}
