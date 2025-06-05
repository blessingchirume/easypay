import 'package:flutter/material.dart';
import '../../models/responses/transaction_model.dart';

class TransactionListPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionListPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions', style: TextStyle(color: Colors.white)),
        // backgroundColor: const Color(0xFF405189),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions available"))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final txn = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: Icon(
                txn.txnType == "TOP-UP" ? Icons.arrow_upward : Icons.arrow_downward,
                color: txn.txnType == "TOP-UP" ? Colors.green : Colors.red,
              ),
              title: Text(
                "${txn.txnType} - ${txn.currency} ${txn.amount}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Account: ${txn.account.toString().isEmpty ? 'N/A' : txn.account}"),
              trailing: Text(
                txn.createdAt.toString().split('T')[0],
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
