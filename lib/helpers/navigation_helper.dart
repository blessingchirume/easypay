import 'package:easypay/modules/authentication/pages/login_page.dart';
import 'package:easypay/modules/dashboard/pages/dashboard.dart';
import 'package:flutter/material.dart';

import '../constants/routing_constants.dart';
import '../modules/payments/pages/payment_page.dart';

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
        return navigateToPage(PaymentPage());

      default:
        return navigateToPage(LoginPage());
    }
  }

  static MaterialPageRoute<dynamic> navigateToPage(dynamic page) =>
      MaterialPageRoute(builder: (_) => page);
}
