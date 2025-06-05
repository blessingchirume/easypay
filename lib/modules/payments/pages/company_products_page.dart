import 'package:easypay/modules/payments/pages/payment_page.dart';
import 'package:flutter/material.dart';
import '../../../constants/routing_constants.dart';
import '../../../models/responses/user_response_model.dart';
import '../../authentication/controller/authentication_controller.dart';

class CompanyProductsPage extends StatefulWidget {
  const CompanyProductsPage({super.key});

  @override
  _CompanyProductsPageState createState() => _CompanyProductsPageState();
}

class _CompanyProductsPageState extends State<CompanyProductsPage> {
  List<CompanyProduct>? companyProducts = [];
  String? companyId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      // Retrieve user data from SharedPreferences
      UserModel userData = await AuthenticationController().retrieveUserData();
      setState(() {
        companyProducts = userData.companyProducts
            ?.map((product) => CompanyProduct(
          id: product.id,
          displayName: product.displayName!.toUpperCase(),
          currency: product.currency!.toUpperCase()
          // Convert to uppercase
        ))
            .toList();
        companyId = userData.company?.id.toString();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching products: $e");
    }
  }

  void _showEconetOptions(CompanyProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Text("Select an Option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Airtime"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PaymentPage(product: product)));
                },
              ),
              ListTile(
                title: Text("Bundles"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutingConstants.bundlePurchase);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mapping of company names to their image assets
    Map<String, String> productImages = {
      "ECONET": "assets/images/econet.png",
      "NETONE": "assets/images/netone.png",
      "TELONE": "assets/images/telone.png",
      "ZETDC": "assets/images/zesa.png",
      "EAZZYPAY": "assets/images/eazzypay_logo.png",
    };

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Products',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF290C82),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: companyProducts?.length ?? 0,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            CompanyProduct product = companyProducts![index];
            String displayName = product.displayName!;
            String currency = product.currency!;
            String? imagePath = productImages[displayName];

            return GestureDetector(
              onTap: () {
                if (displayName == "TELONE") {
                  Navigator.pushNamed(context, RoutingConstants.customerInfo);
                } else if (displayName == "ECONET") {
                  _showEconetOptions(product);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PaymentPage(product: product)));
                }
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath != null
                        ? Image.asset(imagePath, height: 60)
                        : const Icon(Icons.business, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      currency,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
