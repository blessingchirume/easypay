import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../constants/routing_constants.dart';
import '../../../services/process_notification_service.dart';
import '../controller/payment_controller.dart';

class AgentFloatTopupPage extends StatefulWidget {
  @override
  _AgentFloatTopupPageState createState() => _AgentFloatTopupPageState();
}

class _AgentFloatTopupPageState extends State<AgentFloatTopupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileMoneyController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCurrency;

  final List<String> _currencies = ["USD", "ZWL"];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _makePayment();
    }
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) return;

    ProcessNotificationService.startLoading(context);
    try {
      Map<String, dynamic> userInteraction = {
        "mobile_money_number": _mobileMoneyController.text,
        "amount": double.parse(_amountController.text),
        "currency": _selectedCurrency,
      };

      Response response = await PaymentController().addAgentFloat(userInteraction);

      ProcessNotificationService.stopLoading(context);

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
      } else {
        ProcessNotificationService.error(context, "Error: ${response.body}");
      }
    } catch (e) {
      ProcessNotificationService.stopLoading(context);
      ProcessNotificationService.error(context, "Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agent Float Top-up", style: TextStyle(color: Colors.white)),
        // backgroundColor: Theme.of(context).primaryColor, // Change to match your theme
        iconTheme: IconThemeData(color: Colors.white), // Ensures back button is white
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _mobileMoneyController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Mobile Money Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your mobile money number";
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an amount";
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return "Enter a valid amount";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: InputDecoration(labelText: "Currency"),
                items: _currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
                validator: (value) => value == null ? "Please select a currency" : null,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(Icons.send, color: Colors.white), // Icon in white
                  label: Text("Confirm Transaction", style: TextStyle(color: Colors.white)), // Text in white
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Theme.of(context).primaryColor, // Change to match your theme
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileMoneyController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
