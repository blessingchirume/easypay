import 'package:easypay/models/responses/user_response_model.dart';
import 'package:easypay/modules/authentication/pages/login_page.dart';
import 'package:easypay/modules/dashboard/pages/dashboard.dart';
import 'package:easypay/modules/payments/pages/company_products_page.dart';
import 'package:flutter/material.dart';

import '../constants/routing_constants.dart';
import '../modules/payments/pages/agent_float_topup.dart';
import '../modules/payments/pages/econet_bundles_page.dart';
import '../modules/payments/pages/payment_page.dart';
import '../modules/payments/pages/telone_products.dart';

class NavigationHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Convenience and navigation

      // App settings
      case RoutingConstants.login:
        return navigateToPage(LoginPage());

      case RoutingConstants.dashboard:
        return navigateToPage(DashboardPage());
        
      case RoutingConstants.payment:
        return navigateToPage(PaymentPage(product: settings.arguments as CompanyProduct,));

      case RoutingConstants.companyProducts:
        return navigateToPage(CompanyProductsPage());

      case RoutingConstants.customerInfo:
        return navigateToPage(MakeSaleScreen());
      case RoutingConstants.agentFloat:
        return navigateToPage(AgentFloatTopupPage());
      case RoutingConstants.bundlePurchase:
        return navigateToPage(MakeEconetSaleScreen());

      default:
        return navigateToPage(LoginPage());
    }
  }

  static MaterialPageRoute<dynamic> navigateToPage(dynamic page) =>
      MaterialPageRoute(builder: (_) => page);
}
