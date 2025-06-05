import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/routing_constants.dart';
import '../../../models/responses/user_response_model.dart';
import '../../../services/api_pipeline_service.dart';
import '../../../services/process_notification_service.dart';
import '../../authentication/controller/authentication_controller.dart';
import '../controller/payment_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.product});

  final CompanyProduct product;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController mobilePinController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  List<CompanyProduct>? companyProducts = [];
  CompanyProduct? selectedCategory;
  String? selectedCurrency;
  String? companyId;

  List<String> netoneStocks = [];
  final List<String> currencies = ["USD", "ZWG"]; // Sample currencies

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _getNetoneStocks();
    selectedCategory = widget.product;
    currencyController.text = widget.product.currency!;
    productController.text = selectedCategory!.displayName!;
  }

  Future<void> _getNetoneStocks() async {
    try {
      final response = await ApiPipelineService()
          .get('${ApiConstants.netoneProductStocks}/${widget.product.id}');

      if (response.statusCode == 200) {
        setState(() {
          netoneStocks = (json.decode(response.body) as List)
              .map((item) => item.toString()) // Adjust based on API response
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        // isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  Future<void> _fetchCategories() async {
    UserModel userData = await AuthenticationController().retrieveUserData();
    setState(() {
      companyProducts = userData.companyProducts;
      companyId = userData.company?.id.toString();
    });
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) return;
    ProcessNotificationService.startLoading(context);
    try {
      Response response = await PaymentController().makePayment({
        "product_id": selectedCategory?.id.toString() ?? "",
        "amount": amountController.text.trim(),
        "currency": currencyController.text.trim(),
        "target": targetController.text.trim(),
        "company_id": companyId ?? "",
        "mobile_pin": mobilePinController.text.trim(),
        "type": "AIRTIME",
      });
      ProcessNotificationService.stopLoading(context);
      if (response.statusCode == 200) {
        ProcessNotificationService.success(context, response.body);
        Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
      } else {
        ProcessNotificationService.error(context, response.body);
      }
    } catch (e) {
      ProcessNotificationService.error(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments', style: TextStyle(color: Colors.white)),
        // backgroundColor: const Color(0xFF405189),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                InputField(
                  controller: productController,
                  label: "Product",
                  enabled: false,
                ),
                // const SizedBox(height: 20),
                // _buildCategoryDropdown(),
                const SizedBox(height: 20),
                // _buildCurrencyDropdown(),
                InputField(

                  controller: currencyController,
                  label: "Currency",
                  enabled: false,
                ),
                const SizedBox(height: 20),
                InputField(controller: amountController, label: "Amount", keyboardType: TextInputType.number,),
                const SizedBox(height: 20),
                InputField(controller: targetController, label: "Recipient Number", keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                InputField(
                    controller: mobilePinController,
                    label: "Pin",
                    obscureText: true, keyboardType: TextInputType.number,),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _makePayment,
                  child: const Text('Confirm Transaction',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<CompanyProduct>(
      value: selectedCategory,
      hint: const Text('Select a category'),
      isExpanded: true,
      items: companyProducts?.map((product) {
        return DropdownMenuItem<CompanyProduct>(
          value: product,
          child: Text(product.displayName ?? "Unknown"),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedCategory = value),
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      hint: const Text('Select currency'),
      isExpanded: true,
      items: currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedCurrency = value),
      validator: (value) => value == null ? 'Please select a currency' : null,
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;

  const InputField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'This field is required' : null,
    );
  }
}
