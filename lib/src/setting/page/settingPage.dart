import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SettingPage extends StatelessWidget {
  final AuthenticationManager authManger =
      Get.put(AuthenticationManager());
   SettingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Mode Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Light'),
                const SizedBox(width: 10),
                Switch(
                  value: AdaptiveTheme.of(context).mode.isDark,
                  onChanged: (value) {
                    if (value) {
                      AdaptiveTheme.of(context).setDark();
                      authManger.darkTheme=true;
                    } else {
                      AdaptiveTheme.of(context).setLight();
                      authManger.darkTheme=false;
                    }
                  },
                ),
                const SizedBox(width: 10),
                const Text('Dark'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
