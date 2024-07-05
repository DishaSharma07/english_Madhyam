import 'package:english_madhyam/src/internet_connectivity/static_index.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'navigation_Service.dart';

class InternetChecker {
  InternetChecker({Widget? page, GlobalKey<NavigatorState>? navigationKey,required BuildContext ctx}) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          if (IndexClass.index == 1) {
            IndexClass.index = 0;
            NavigationService.popScreen(navigationKey: navigationKey,context: ctx);
          }
          break;
        case InternetConnectionStatus.disconnected:
          IndexClass.index = 1;
          NavigationService.navigateTo(
              page: page, navigationKey: navigationKey,ctx: ctx);
          break;
      }
    });
  }
}
