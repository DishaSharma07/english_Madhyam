
import 'package:flutter/material.dart';

import 'connectivty_Screen.dart';

class NavigationService {
  static GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static void pop() {
    return _navigationKey.currentState!.pop();
  }

  static Future<dynamic> navigateTo(
      {Widget? page, GlobalKey<NavigatorState>? navigationKey,required BuildContext ctx}) {
    if (navigationKey == null) {
      return Navigator.of(ctx).push(MaterialPageRoute(
          builder: (context) => page ?? ConnectivityScreen()));
    } else
      return navigationKey.currentState!.push(MaterialPageRoute(
          builder: (context) => page ?? ConnectivityScreen()));
  }

  static void popScreen({GlobalKey<NavigatorState>? navigationKey,required BuildContext context}) {
    if (navigationKey == null) {
      // _navigationKey.currentState!.pop();
      Navigator.of(context).pop();
    } else{
      Navigator.of(context).pop();

      // navigationKey.currentState!.pop();
    }

  }
}
