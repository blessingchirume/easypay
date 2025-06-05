import 'dart:convert';

import 'package:easypay/models/responses/transaction_model.dart';
import 'package:easypay/models/responses/wallet_balance_model.dart';
import 'package:easypay/modules/dashboard/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../constants/routing_constants.dart';
import '../../../services/process_notification_service.dart';
import '../../payments/controller/payment_controller.dart';
import '../../transactions/last_transaction.dart';
import '../../transactions/transaction_history.dart';

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
            const SizedBox(height: 10),

            // Bill Payments
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF290C82),
                leading: Icon(Icons.payment, color: Color(0xFF290C82)),
                title: Text('Eazzypay Products'),
                subtitle: Text('Explore digital payments.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RoutingConstants.companyProducts);
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
                iconColor: Color(0xFF290C82),
                leading:
                    Icon(Icons.add_circle_outline, color: Color(0xFF290C82)),
                title: Text('E-Value Top Up'),
                subtitle: Text('Top up your E-Value wallet.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.of(context)
                    .pushNamed(RoutingConstants.agentFloat),
              ),
            ),
            const SizedBox(height: 10),

            // Day Transactions
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF290C82),
                leading: Icon(Icons.calendar_today, color: Color(0xFF290C82)),
                title: Text('Today\'s Transactions'),
                subtitle: Text('View today\'s transactions.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  ProcessNotificationService.startLoading(context);
                  try {
                    Response response =
                        await TransactionController().getDayTransactions();
                    ProcessNotificationService.stopLoading(context);
                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body)["transactions"];
                      List<TransactionModel> transactions = [];
                      data.forEach((item) {
                        transactions.add(TransactionModel.fromJson(item));
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionListPage(transactions: transactions),
                        ),
                      );
                    }
                  } on Exception catch (e) {
                    ProcessNotificationService.error(context, '$e');
                  }
                },
              ),
            ),
            const SizedBox(height: 10),

            // Latest Transactions
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: ListTile(
                iconColor: Color(0xFF290C82),
                leading: Icon(Icons.history, color: Color(0xFF290C82)),
                title: Text('Statement'),
                subtitle: Text('Access transaction history.'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  // Show custom date range picker dialog
                  final DateTimeRange? pickedRange =
                      await _showCustomDateRangePicker(context);

                  if (pickedRange != null) {
                    ProcessNotificationService.startLoading(context);
                    try {
                      // Format dates to Y-m-d
                      String startDate =
                          DateFormat('y-MM-dd').format(pickedRange.start);
                      String endDate =
                          DateFormat('y-MM-dd').format(pickedRange.end);

                      Response response = await TransactionController()
                          .getTransactionHistory(startDate, endDate);

                      ProcessNotificationService.stopLoading(context);

                      if (response.statusCode == 200) {
                        var data = jsonDecode(response.body)["transactions"];
                        List<TransactionModel> transactions = [];
                        data.forEach((item) {
                          transactions.add(TransactionModel.fromJson(item));
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransactionListPage(transactions: transactions),
                          ),
                        );
                      }
                    } on Exception catch (e) {
                      ProcessNotificationService.stopLoading(context);
                      ProcessNotificationService.error(
                          context, 'Failed to load transactions: $e');
                    }
                  }
                },
              ),
            ),
          ],
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

  Future<void> _makePayment(BuildContext context) async {
    // if (!_formKey.currentState!.validate()) return;
    ProcessNotificationService.startLoading(context);
    try {
      Response response = await PaymentController().addAgentFloat(
          {"mobile_money_number": "", "amount": 10, "currency": "USD"});
      ProcessNotificationService.stopLoading(context);
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
      } else {
        ProcessNotificationService.error(context, response.body);
      }
    } catch (e) {
      ProcessNotificationService.error(context, '$e');
    }
  }

  // Add this helper function to your widget class
  Future<DateTimeRange?> _showCustomDateRangePicker(BuildContext context) async {
    DateTimeRange? selectedRange;
    bool isConfirmed = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        // title: Text("Select Date Range", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            minDate: DateTime(2000),
            maxDate: DateTime.now(),
            initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(Duration(days: 7)),
              DateTime.now(),
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              todayTextStyle: TextStyle(color: Color(0xFF290C82)),
              todayCellDecoration: BoxDecoration(
                border: Border.all(color: Color(0xFF290C82)),
                shape: BoxShape.circle,
              ),
              selectionTextStyle: TextStyle(color: Colors.white),
              selectionColor: Color(0xFF290C82),
              rangeSelectionColor: Color(0xFF290C82).withOpacity(0.2),
              startRangeSelectionColor: Color(0xFF290C82),
              endRangeSelectionColor: Color(0xFF290C82),
            ),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is PickerDateRange) {
                final range = args.value as PickerDateRange;
                if (range.startDate != null && range.endDate != null) {
                  selectedRange = DateTimeRange(
                    start: range.startDate!,
                    end: range.endDate!,
                  );
                }
              }
            },
          ),
        ),
        actions: [
          TextButton(
            // style: ElevatedButton.styleFrom(
            //   backgroundColor: Color(0xFF290C82),
            // ),
            onPressed: () {
              if (selectedRange != null) {
                isConfirmed = true;
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a date range")),
                );
              }
            },
            child: Text("CONFIRM", style: TextStyle(color: Color(0xFF290C82))),
          ),
         
        ],
      ),
    );

    return isConfirmed ? selectedRange : null;
  }
}
