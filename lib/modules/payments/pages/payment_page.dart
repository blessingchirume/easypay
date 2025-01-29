import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../constants/routing_constants.dart';
import '../../../models/responses/user_response_model.dart';
import '../../../services/process_notification_service.dart';
import '../controller/payment_controller.dart';

class PaymentPage extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController mobilePinController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const SizedBox(height: 20),
              // Tagline
              Text(
                'Make Payment',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email Field
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: currencyController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Currency',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 30),

             TextField(
                controller: targetController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Target',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 30),
             TextField(
                controller: mobilePinController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Pin',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  ProcessNotificationService.startLoading(context);
                  try {
                    Response response = await PaymentController()
                        .makepayment({
                          "product_id": "1",
                          "amount": amountController.text,
                          "currency": currencyController.text,
                          "target": targetController.text,
                          "company_id": "31",
                          "mobile_id": "0000",
                          "type": "AIRTIME" 
                        });
                    ProcessNotificationService.stopLoading(context);
                    if (response.statusCode == 200) {
                      Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
                    }
                  } on Exception catch (e) {
                    ProcessNotificationService.error(context, '$e');
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Color(0xFF405189)),
                child: Text(
                  'Make Payment',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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

  //  Widget _buildCategoryDropdown() async {
  //   // if (isLoadingCategories) {
  //   //   return const Center(child: CircularProgressIndicator());
  //   // }

  //   categories  = await AuthenticationController().re

  //   if (categories == null || categories!.isEmpty) {
  //     return const Text("No categories available");
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 0),
  //     child: Container(
  //       width: SizeConfig.screenWidth,
  //       padding: const EdgeInsets.all(defaultPadding / 3),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         border: Border.all(
  //           color: Theme.of(context).primaryColor,
  //           width: 1.0,
  //         ),
  //         color: Colors.white,
  //       ),
  //       child: DropdownButtonFormField<ProductCategoryModel>(
  //         value: selectedCategory,
  //         hint: const Text('Select a category'),
  //         isExpanded: true,
  //         icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
  //         iconSize: 30.0,
  //         elevation: 16,
  //         style: const TextStyle(
  //           color: Colors.black,
  //           fontSize: 16.0,
  //         ),
  //         onChanged: (value) {
  //           setState(() {
  //             selectedCategory = value;
  //           });
  //         },
  //         items: categories!.map((category) {
  //           return DropdownMenuItem<CompanyProducts>(
  //             value: category,
  //             child: Text(category.name ?? "Unknown"),
  //           );
  //         }).toList(),
  //         validator: (value) {
  //           if (value == null) {
  //             return 'Please select a category';
  //           }
  //           return null;
  //         },
  //         decoration: const InputDecoration(border: InputBorder.none),
  //       ),
  //     ),
  //   );
  // }
}
