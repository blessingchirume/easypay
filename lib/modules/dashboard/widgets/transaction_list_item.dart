import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final String txnType;
  final String account;
  final String amount;
  final String currency;
  final String createdAt;

  const TransactionListItem({
    super.key,
    required this.txnType,
    required this.account,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          txnType == 'TOP-UP' ? Icons.add_circle : Icons.remove_circle,
          color: txnType == 'TOP-UP' ? Colors.green : Colors.red,
          size: 32,
        ),
        title: Text(
          txnType,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (account.isNotEmpty) Text("Account: $account"),
            Text("Amount: $amount $currency"),
            Text("Date: ${DateTime.parse(createdAt).toLocal()}"),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
