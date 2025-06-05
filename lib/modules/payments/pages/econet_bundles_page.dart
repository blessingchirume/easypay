import 'package:easypay/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants/routing_constants.dart';
import '../../../models/responses/econet_bundle_category_model.dart';
import '../../../models/responses/user_response_model.dart';
import '../../../services/api_pipeline_service.dart';
import '../../../services/process_notification_service.dart';
import '../../authentication/controller/authentication_controller.dart';
import '../controller/payment_controller.dart';

class MakeEconetSaleScreen extends StatefulWidget {
  @override
  _MakeEconetSaleScreenState createState() => _MakeEconetSaleScreenState();
}

class _MakeEconetSaleScreenState extends State<MakeEconetSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  EconetBundleCategoryModel? selectedCategory;
  EconetBundleModel? selectedBundle;

  List<EconetBundleCategoryModel> categories = [];

  TextEditingController phoneNumberController = TextEditingController();
  bool isLoadingCategories = true;
  String? companyId;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    UserModel userData = await AuthenticationController().retrieveUserData();
    setState(() {
      companyId = userData.company?.id.toString();
    });
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoadingCategories = true;
    });

    final response = await ApiPipelineService().get(ApiConstants.econetBundles);

    if (response.statusCode == 200) {
      setState(() {
        categories = (json.decode(response.body) as List)
            .map((item) => EconetBundleCategoryModel.fromJson(item))
            .toList();
        isLoadingCategories = false;
      });
    } else {
      setState(() {
        isLoadingCategories = false;
      });
      ProcessNotificationService.error(context, "Failed to load categories");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Econet Bundles',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Recipient Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              isLoadingCategories
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<EconetBundleCategoryModel>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: 'Select Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          selectedBundle = null;
                        });
                      },
                    ),
              if (selectedCategory != null)
                DropdownButtonFormField<EconetBundleModel>(
                  value: selectedBundle,
                  decoration: InputDecoration(labelText: 'Select Bundle'),
                  items: selectedCategory!.econetBundleModel!.map((bundle) {
                    return DropdownMenuItem(
                      value: bundle,
                      child: Text(bundle.bundle!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBundle = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a bundle' : null,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _makePayment,
                child: Text('Confirm Transaction',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) return;
    ProcessNotificationService.startLoading(context);
    try {
      var payload = {
        "pricePlanCode": selectedBundle!.pricePlanCode,
        "target": phoneNumberController.text.trim(),
        "amount": selectedBundle?.price ?? 0,
        "currency": selectedBundle!.currency ?? 'USD',
      };

      http.Response response =
          await PaymentController().econetBundlePurchase(payload);

      ProcessNotificationService.stopLoading(context);

      if (response.statusCode == 201) {
        ProcessNotificationService.success(
            context, '${jsonDecode(response.body)['message']}');
        Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
      } else {
        ProcessNotificationService.error(context, response.body);
      }
    } catch (e) {
      ProcessNotificationService.error(context, 'Error: $e');
    }
  }
}
