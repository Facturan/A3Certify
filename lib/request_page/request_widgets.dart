import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final String titleType;
  final String titleNumber;
  final String registryOfDeeds;
  final String dateSubmitted;
  final String amount;
  final String? adminComment;
  final String? processedDate;
  final String paymentStatus;
  final String email;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onApprove;

  const RequestCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.titleType,
    required this.titleNumber,
    required this.registryOfDeeds,
    required this.dateSubmitted,
    required this.amount,
    required this.email,
    this.adminComment,
    this.processedDate,
    required this.paymentStatus,
    this.onEdit,
    this.onCancel,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Document Icon
            Container(
              width: 80,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.blue,
                size: 80,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == 'pending'
                              ? const Color(0xFF34495E)
                              : status.toLowerCase() == 'cancelled'
                                  ? Colors.red
                                  : Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Amount: $amount',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // More Options
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 40,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit?.call();
                    break;
                  case 'cancel':
                    onCancel?.call();
                    break;
                  case 'approve':
                    onApprove?.call();
                    break;
                }
              },
              itemBuilder: (context) {
                final items = <PopupMenuItem<String>>[];
                if (onEdit != null) {
                  items.add(const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ));
                }
                if (onCancel != null) {
                  items.add(const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Cancel'),
                  ));
                }
                if (onApprove != null) {
                  items.add(const PopupMenuItem(
                    value: 'approve',
                    child: Text('Approve'),
                  ));
                }
                return items;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyRequestsView extends StatelessWidget {
  const EmptyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No requests found.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading requests\n$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
