import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/sign_up/signup_screen.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignInDemo extends StatefulWidget {
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;

  // String _contactText = '';
  HttpService _httpService = HttpService();
  String deviceTokenn = "";

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact(_currentUser!);
      // }
    });
    googleSignIn.signInSilently();
  }

  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   // setState(() {
  //   //   _contactText = 'Loading contact info...';
  //   // });
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     // setState(() {
  //     //   _contactText="Something went wrong";
  //     //   // _contactText = 'People API gave a ${response.statusCode} '
  //     //   //     'response. Check logs for details.';
  //     // });
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data =
  //   json.decode(response.body) as Map<String, dynamic>;
  //   // final String? namedContact = _pickFirstNamedContact(data);
  //   // setState(() {
  //   //   if (namedContact != null) {
  //   //     _contactText = 'I see you know $namedContact!';
  //   //   } else {
  //   //     _contactText = 'No contacts to display.';
  //   //   }
  //   // });
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'] as List<dynamic>?;
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //         (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   ) as Map<String, dynamic>?;
  //   if (contact != null) {
  //     final Map<String, dynamic>? name = contact['names'].firstWhere(
  //           (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     ) as Map<String, dynamic>?;
  //     if (name != null) {
  //       return name['displayName'] as String?;
  //     }
  //   }
  //   return null;
  // }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error.toString()+"hjhj");
    }
  }

  deviceToken() async {
    FirebaseMessaging messaging;
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    await messaging.getToken().then((value) {
      if (value != null) {
        // setToken(value);
        setState(() {
          deviceTokenn = value;
        });
      }
    });
    return deviceTokenn;
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  void _userResponse(String email) async {
    var res = await _httpService.isNewUser(email, context);
    deviceToken();
    if (res!.status == "old") {
      print("old");
      var response = await _httpService.Login_api(
          email: email,
          deviceT: Platform.isAndroid ? "Android" : "IOS",
          deviceID: (await PlatformDeviceId.getDeviceId)!,
          deviceTOK: deviceTokenn);

      if (response!.result == 'success') {
        print("success");
        if (response.user?.loginEnabled == 1) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setInt('userID', response.user!.id!.toInt());
          prefs.setString('name', response.user!.name.toString());
          prefs.setString('phone', response.user!.phone.toString());
          prefs.setString('email', response.user!.email.toString());
          prefs.setString('image', response.user!.image.toString());
          prefs.setString('dob', response.user?.dateOfBirth ?? "");
          prefs.setInt('state_id', response.user?.stateId ?? 0);
          prefs.setInt('city_id', response.user!.cityId ?? 0);
          prefs.setString('slug', response.user!.slug.toString());
          prefs.setString(
              'device_id',
              (await PlatformDeviceId.getDeviceId) == null
                  ? ""
                  : (await PlatformDeviceId.getDeviceId)!);
          prefs.setString("device_token", deviceTokenn);
          // prefs.setInt('board_id', response.user?.boardId! ?? 0);
          prefs.setString('token', response.token.toString());
          Fluttertoast.showToast(msg: "Login Successfully");
          cancel();
          Get.offAll(() => const BottomWidget());

          return;
        }
        Fluttertoast.showToast(msg: "Your account has been disabled.");
        cancel();

        return;
      }
    } else {
      Fluttertoast.showToast(msg: "New User");
      cancel();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => RegisterScreen(
                    email: email,
                  )),
          (route) => false);
    }
  }

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      _userResponse(user.email);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          // const Text('Signed in successfully.'),
          // const SizedBox(height: 50,),
          //
          // ElevatedButton(style: ButtonStyle(
          //
          //   backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
          // ),
          //
          //   onPressed: _handleSignOut,
          //   child: const Padding(
          //     padding:  EdgeInsets.all(8.0),
          //     child:  Text('SIGN OUT'),
          //   ),
          // ),
          // const SizedBox(width: 20,)
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          SizedBox(height: 30,),
          ElevatedButton(
          style: ButtonStyle(

            backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
          ),
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Google Sign In',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
