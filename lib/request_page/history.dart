import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Stream<QuerySnapshot> _historyStream;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeHistoryStream();
  }

  void _initializeHistoryStream() {
    _historyStream = FirebaseFirestore.instance
        .collection('requests')
        .where('status', whereIn: ['completed', 'cancelled'])
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> _refreshHistory() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistory,
        child: StreamBuilder<QuerySnapshot>(
          stream: _historyStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting || _isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            
            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  'No history found.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => HistoryCard(doc: docs[index]),
            );
          },
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final DocumentSnapshot doc;

  const HistoryCard({
    super.key,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final status = data['status'] as String? ?? 'Unknown';
    final statusColor = status.toLowerCase() == 'completed' 
        ? Colors.green 
        : Colors.red;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['titleType'] ?? 'Unknown Type',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.numbers,
              'Title Number:',
              data['titleNumber'] ?? 'N/A',
            ),
            _buildInfoRow(
              Icons.location_city,
              'Registry:',
              data['registryOfDeeds'] ?? 'N/A',
            ),
            _buildInfoRow(
              Icons.calendar_today,
              'Date Submitted:',
              _formatTimestamp(data['createdAt'] as Timestamp?),
            ),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Date Completed:',
              _formatTimestamp(data['processedAt'] as Timestamp?),
            ),
            _buildInfoRow(
              Icons.payments,
              'Amount:',
              '₱${data['amount'] ?? 0}',
            ),
            _buildInfoRow(
              Icons.payment,
              'Payment Status:',
              (data['paymentStatus'] ?? 'unpaid').toUpperCase(),
              valueColor: (data['paymentStatus'] ?? '').toLowerCase() == 'paid' 
                  ? Colors.green 
                  : Colors.blue,
            ),
            
            if (data['adminComment'] != null && data['adminComment'].toString().isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.comment, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Admin Comment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(data['adminComment'].toString()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    return timestamp.toDate().toString().split('.').first;
  }
}