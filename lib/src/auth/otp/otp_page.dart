import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/sign_up/signup_screen.dart';
import 'package:english_madhyam/src/utils/Terms&co.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lottie/lottie.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({Key? key, required this.mobile}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  HttpService _httpService = HttpService();
  TextEditingController otp = TextEditingController();
  bool loading = false;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String deviceTokenn = "";
  // String? _commingSms = 'Unknown';

  // Future<void> initSmsListener() async {
  //   String? commingSms;
  //   try {
  //     commingSms = await AltSmsAutofill().listenForSms;
  //
  //   } on PlatformException {
  //     commingSms = 'Failed to get Sms.';
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _commingSms = commingSms;
  //
  //     otp.text=_commingSms!.substring(0,4);
  //
  //
  //   });
  // }


  deviceToken() async {
    FirebaseMessaging messaging;
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");

    await messaging.getToken().
    then((value)  {
      if (value != null) {
        // setToken(value);
        setState(() {
          deviceTokenn = value;
        });
      }else{
        messaging.onTokenRefresh.listen((event) {  setState(() {
          deviceTokenn = event;
        });});
      }
    });
    return deviceTokenn;
  }

  String? validateOtp(String value) {
    if (value.length < 4) {
      return 'Please enter valid otp';
    }
    return null;
  }
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        // deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo)!;
          debugPrint(_readAndroidBuildData(await deviceInfoPlugin.androidInfo).toString(),wrapWidth: 2200);
          Fluttertoast.showToast(msg: "device data :"+"$deviceData");
          cancel();
        } else if (Platform.isIOS) {
          // deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          // deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          // deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          // deviceData =
          // _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "Failed to get Platform version");
      cancel();
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }
  Map<String, dynamic>? _readAndroidBuildData(AndroidDeviceInfo build) {
    try{
      return <String, dynamic>{
        'version.securityPatch': build.version.securityPatch,
        'version.sdkInt': build.version.sdkInt,
        'version.release': build.version.release,
        'version.previewSdkInt': build.version.previewSdkInt,
        'version.incremental': build.version.incremental,
        'version.codename': build.version.codename,
        'version.baseOS': build.version.baseOS,
        'board': build.board,
        'bootloader': build.bootloader,
        'brand': build.brand,
        'device': build.device,
        'display': build.display,
        'fingerprint': build.fingerprint,
        'hardware': build.hardware,
        'host': build.host,
        'id': build.id,
        'manufacturer': build.manufacturer,
        'model': build.model,
        'product': build.product,
        'supported32BitAbis': build.supported32BitAbis,
        'supported64BitAbis': build.supported64BitAbis,
        'supportedAbis': build.supportedAbis,
        'tags': build.tags,
        'type': build.type,
        'isPhysicalDevice': build.isPhysicalDevice,
        'androidId': build.androidId,
        'systemFeatures': build.systemFeatures,
      };
    }catch(e){
      Fluttertoast.showToast(msg: "Failed to get Platform version"+e.toString());
      cancel();
    }

  }


  otpVerify({required String Mobile, required String Otp}) async {
    deviceToken();
    loading = true;
    String? validate = validateOtp(Otp);
    if (validate != null) {
      return;
    }

    var res = await _httpService.verify_otp(mobile: Mobile, OTP: Otp);
    if (res?.result == "success") {
      /*Fluttertoast.showToast(msg: "Data Successfully Fetched ");
      cancel();*/
      setState(() {
        loading = false;
      });
      if (res?.status == "old")
      {
        callLoginApi(Mobile);

      }
      else {
        try{
          Fluttertoast.showToast(msg: "New User  ${res?.message}");
          setState(() {
            loading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>RegisterScreen(
            mobile: widget.mobile,
          )), (route) => route.isFirst);

        }catch(e){
          Fluttertoast.showToast(msg: "Some thing went wrong"+e.toString());
        }
      }
      } else {
        Fluttertoast.showToast(msg: "${res?.status}  ${res?.message}");

      }
  }

  final scaffoldKey = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    // initSmsListener();
  }
  @override
  void dispose() {
    // AltSmsAutofill().unregisterListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              CustomRoboto(
                text: "Get Better Every Day, Practice",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              CustomRoboto(
                text: "Test Series and Free Daily Quizzes",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: purpleColor,
              ),
              Image.asset(
                "assets/img/two_child.png",
                height: size.height * 0.35,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  enabled: true,
                  controller: otp,
                  maxLength: 4,
                  // onChanged: (otpValue){
                  //   otp.text.length==4?      otpVerify(Mobile: widget.mobile, Otp: otp.text):null;
                  // },
                  keyboardType: TextInputType.numberWithOptions(signed: false),
                  style: GoogleFonts.roboto(fontSize: 16, letterSpacing: 1.0),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      prefixStyle: GoogleFonts.roboto(
                        fontSize: 16,
                        color: blackColor,
                      ),
                      hintText: "Enter your OTP ",
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 16,
                        color: greyColor,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              InkWell(
                onTap: () {
                  otpVerify(Mobile: widget.mobile, Otp: otp.text);
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 35, right: 35, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: purplegrColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: greyColor,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(1, 2))
                      ],
                      gradient: RadialGradient(
                        center: Alignment(0.0, 0.2),
                        colors: [purpleColor, purplegrColor],
                        radius: 2.0,
                      ),
                    ),
                    child: loading == true
                        ? Lottie.asset(
                      "assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.04,
                    )
                        : Text(
                      'Verify',
                      style: GoogleFonts.roboto(
                          color: whiteColor,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 4),
                              blurRadius: 3.0,
                              color: greyColor.withOpacity(0.5),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icon/fb.svg",
                    height: 35,
                  ),
                  SizedBox(width: 30),
                  Image.asset(
                    "assets/img/google.png",
                    scale: 1.8,
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomRoboto(
                    text: "By signing up you agree to our ",
                    fontSize: 12,
                    color: greyColor,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => TermsCond());
                    },
                    child: CustomRoboto(
                      text: "Terms and Condition ",
                      fontSize: 12,
                      color: blackColor,
                      linethrough: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> callLoginApi(String Mobile) async {
    try{
      loading = true;

      var response = await _httpService.Login_api(
          mobile: Mobile,
          deviceT: Platform.isAndroid ? "Android" : "IOS",
          deviceID: _deviceData["id"]!,
          deviceTOK: deviceTokenn);

      setState(() {
        loading = false;
      });
      if (response!.result == 'success') {
        /*Fluttertoast.showToast(msg: "Data Successfully Fetched ");
        cancel();*/
        if (response.user?.loginEnabled == 1) {
          Fluttertoast.showToast(msg: "loginEnabled");
          final prefs = await SharedPreferences.getInstance();
          try{
            prefs.setString('token', response.token.toString());
            prefs.setInt('userID', response.user!.id!.toInt());
            prefs.setString('name', response.user!.name.toString());
            prefs.setString('phone', response.user!.phone.toString());
            prefs.setString('email', response.user!.email.toString());
            prefs.setString('image', response.user!.image.toString());
            prefs.setString('dob', response.user?.dateOfBirth ?? "");
            prefs.setInt('state_id', response.user?.stateId ?? 0);
            prefs.setInt('city_id', response.user!.cityId ?? 0);
            Fluttertoast.showToast(msg: "Login Successfully");
            try{
              prefs.setString('device_id', _deviceData['id']);

            }catch(e){
              Fluttertoast.showToast(msg: "In Device Id catch $e");
            }
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const BottomWidget()), (route) => route.isFirst);
          }
          catch(e){
            Fluttertoast.showToast(msg: e.toString());
          }
        }else{
          Fluttertoast.showToast(msg: "Your account has been disabled.");
        }
      }
    }catch(e){
      Fluttertoast.showToast(msg: "Some thing went wrong"+e.toString());

    }

  }
}

// class SampleStrategy extends OTPStrategy {
//   // final String code;
//   //
//   // SampleStrategy(this.code);
//
//   @override
//   Future<String> listenForCode() {
//     return Future.delayed(
//       const Duration(seconds: 4),
//       () => 'Your code is }',
//     );
//   }
// }
