import 'package:easypay/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants/routing_constants.dart';
import '../../../models/responses/telone_product_model.dart';
import '../../../models/responses/telone_product_stock_model.dart';
import '../../../models/responses/user_response_model.dart';
import '../../../services/api_pipeline_service.dart';
import '../../../services/process_notification_service.dart';
import '../../authentication/controller/authentication_controller.dart';
import '../controller/payment_controller.dart';

class MakeSaleScreen extends StatefulWidget {
  @override
  _MakeSaleScreenState createState() => _MakeSaleScreenState();
}

class _MakeSaleScreenState extends State<MakeSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  TeloneProductModel? selectedCategory;
  TeloneProductStockModel? selectedProduct;

  List<TeloneProductModel> categories = [];
  List<TeloneProductStockModel> products = [];

  TextEditingController tagertController = TextEditingController();

  bool isLoadingCategories = true;
  bool isLoadingProducts = false;

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

    final response =
        await ApiPipelineService().get(ApiConstants.teloneProducts);

    if (response.statusCode == 200) {
      setState(() {
        categories = (json.decode(response.body) as List)
            .map((item) => TeloneProductModel.fromJson(item))
            .toList();
        isLoadingCategories = false;
      });
    } else {
      setState(() {
        isLoadingCategories = false;
      });
      // Handle error
    }
  }

  Future<void> fetchProducts(String categoryId) async {
    setState(() {
      isLoadingProducts = true;
    });

    final response = await ApiPipelineService()
        .get('${ApiConstants.teloneProductStocks}/$categoryId');

    if (response.statusCode == 200) {
      setState(() {
        products = (json.decode(response.body) as List)
            .map((item) => TeloneProductStockModel.fromJson(
                item)) // Adjust based on API response
            .toList();
        selectedProduct = null;
        isLoadingProducts = false;
      });
    } else {
      setState(() {
        isLoadingProducts = false;
      });
      // Handle error
    }
  }

  Widget buildLoadingIndicator(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(width: 12),
          Text(text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            // Image.asset(
            //   'assets/images/eazzypay_logo.jpeg', // Replace with your logo path
            //   height: 40,
            // ),
            // SizedBox(width: 10),
            Text(
              'Payment',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: tagertController,
                  decoration: InputDecoration(labelText: 'Recipient Number')),
              TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount')),

              // Category Dropdown (Voice Bundles, LTE Bundles, etc.)
              isLoadingCategories
                  ? buildLoadingIndicator("Loading Products...")
                  : DropdownButtonFormField<TeloneProductModel>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: 'Select Category'),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toString()));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          fetchProducts(value!.productId.toString());
                        });
                      },
                    ),

              // Product Dropdown (Available products based on selected category)
              if (isLoadingProducts)
                buildLoadingIndicator("Fetching Product Stocks...")
              else if (products.isNotEmpty)
                DropdownButtonFormField<TeloneProductStockModel>(
                  value: selectedProduct,
                  decoration: InputDecoration(labelText: 'Select Product'),
                  items: products.map((product) {
                    return DropdownMenuItem(
                        value: product, child: Text(product.name!));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value;
                    });
                  },
                ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _makePayment,
                child: Text(
                  'Confirm Transaction',
                  style: TextStyle(color: Colors.white),
                ),
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
        "productCode": selectedProduct!.productCode,
        // "target": "0242437785",
        "target": tagertController.text.trim(),
        "notifyNumber": "0783457344",
        "source": "eazzypay",
        "userName": "pchikumba",
        "paymentMethod": "CASH",
        // "product_id": selectedProduct?.productId.toString() ?? "",
        "amount": selectedProduct?.amount! ?? 0,
        "currency": selectedProduct!.currency ?? 'USD',

        "company_id": companyId ?? 5,
        "mobile_pin": "0000",
      };
      http.Response response =
          await PaymentController().teloneDirectPurchase(payload);
      ProcessNotificationService.stopLoading(context);
      if (response.statusCode == 200) {
        ProcessNotificationService.success(context, 'Success');
        Navigator.of(context).pushReplacementNamed(RoutingConstants.dashboard);
      } else {
        ProcessNotificationService.error(context, response.body);
      }
    } catch (e) {
      ProcessNotificationService.error(context, '$e');
    }
  }
}
