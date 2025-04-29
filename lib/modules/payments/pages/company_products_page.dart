import 'dart:convert';

import 'package:easypay/models/responses/transaction_model.dart';
import 'package:easypay/models/responses/user_response_model.dart';
import 'package:easypay/models/responses/wallet_balance_model.dart';
import 'package:easypay/modules/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../constants/routing_constants.dart';
import '../../../services/process_notification_service.dart';
import '../../transactions/last_transaction.dart';
import '../../transactions/transaction_history.dart';

class CompanyProductsPage extends StatelessWidget {
  const CompanyProductsPage({super.key});



  @override
  Widget build(BuildContext context) {

    List<CompanyProduct> products = [];

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
          children: products.map((product) =>             Column(children: [            Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: ListTile(
              iconColor: Color(0xFF290C82),
              leading: Icon(Icons.account_balance_wallet,
                  color: Color(0xFF290C82)),
              title: Text('Balance Enquiry'),
              subtitle: Text('Check your current balance.'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                ProcessNotificationService.startLoading(context);
                try {
                  Response response =
                  await TransactionController().getAgentBalance();
                  ProcessNotificationService.stopLoading(context);
                  if (response.statusCode == 200) {
                    WalletBalanceModel wallet = WalletBalanceModel.fromJson(
                        jsonDecode(response.body));
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "Wallet Balances",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("USD Balance:"),
                                      Text("${wallet.usdBalance}"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("ZWG Balance:"),
                                      Text("${wallet.zwgBalance}")
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                    // Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
                  }
                } on Exception catch (e) {
                  ProcessNotificationService.error(context, '$e');
                }
              },
            ),
          ),
            const SizedBox(height: 10),],)).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF290C82),
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
