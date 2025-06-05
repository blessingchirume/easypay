import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/responses/transaction_model.dart';

class LastTransactionPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  const LastTransactionPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    TransactionModel? lastTransaction =
    transactions.isNotEmpty ? transactions.last : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Transaction', style: TextStyle(color: Colors.white)),
        // backgroundColor: const Color(0xFF405189),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: lastTransaction == null
          ? const Center(child: Text("No transactions available"))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Transaction Type", lastTransaction.txnType.toString(), isBold: true),
                const Divider(),
                _buildDetailRow("Account", lastTransaction.account.toString().isEmpty ? 'N/A' : lastTransaction.account.toString()),
                _buildDetailRow("Amount", "${lastTransaction.currency} ${lastTransaction.amount}"),
                _buildDetailRow("Date", DateFormat('yyyy-MM-dd').format(DateTime.parse(lastTransaction.createdAt.toString()))),
                const SizedBox(height: 20),
                Center(
                  child: Icon(
                    lastTransaction.txnType == "TOP-UP" ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 50,
                    color: lastTransaction.txnType == "TOP-UP" ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
