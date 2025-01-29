import 'package:easypay/modules/dashboard/pages/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../constants/routing_constants.dart';
import '../../../services/process_notification_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Image.asset(
            //   'assets/images/eazzypay_logo.jpeg', // Replace with your logo path
            //   height: 40,
            // ),
            // SizedBox(width: 10),
            Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Color(0xFF405189),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications action
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Enquiry
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF405189),
                leading: Icon(Icons.account_balance_wallet,
                    color: Color(0xFF405189)),
                title: Text('Balance Enquiry'),
                subtitle: Text('Check your current balance.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                 ProcessNotificationService.startLoading(context);
                  try {
                    Response response = await TransactionController().getAgentBalance();
                    ProcessNotificationService.stopLoading(context);
                    if (response.statusCode == 200) {
                      showDialog(context: context, builder: (BuildContext ctx){
                        return AlertDialog(content: Column(),);
                      });
                      // Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
                    }
                  } on Exception catch (e) {
                    ProcessNotificationService.error(context, '$e');
                  }
                },
              ),
            ),
            const SizedBox(height: 10),

            // Bill Payments
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF405189),
                leading: Icon(Icons.payment, color: Color(0xFF405189)),
                title: Text('Bill Payments'),
                subtitle: Text('Pay your utility bills.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).pushNamed(RoutingConstants.payment);
                },
              ),
            ),
            const SizedBox(height: 10),

            // E-Value Top Up
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF405189),
                leading:
                    Icon(Icons.add_circle_outline, color: Color(0xFF405189)),
                title: Text('E-Value Top Up'),
                subtitle: Text('Top up your E-Value wallet.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
            const SizedBox(height: 10),

            // Day Transactions
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF405189),
                leading: Icon(Icons.calendar_today, color: Color(0xFF405189)),
                title: Text('Day Transactions'),
                subtitle: Text('View today\'s transactions.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
            const SizedBox(height: 10),

            // Latest Transactions
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF405189),
                leading: Icon(Icons.history, color: Color(0xFF405189)),
                title: Text('Latest Transactions'),
                subtitle: Text('Check your recent transactions.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF405189),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
