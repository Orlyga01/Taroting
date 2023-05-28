import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BeRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args;
    if (settings.arguments != null) {
      args = settings.arguments as Map<String, dynamic>;
    }
    switch (settings.name) {
      default:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
