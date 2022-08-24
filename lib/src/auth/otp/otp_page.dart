import 'dart:io';
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
// import 'package:otp_autofill/otp_autofill.dart';
// import 'package:alt_sms_autofill/alt_sms_autofill.dart';
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

  String? validateOtp(String value) {
    if (value.length < 4) {
      return 'Please enter valid otp';
    }
    return null;
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
      setState(() {
        loading = false;
      });
      if (res?.status == "old") {
        loading = true;
        var response = await _httpService.Login_api(
            mobile: Mobile,
            deviceT: Platform.isAndroid ? "Android" : "IOS",
            deviceID: (await PlatformDeviceId.getDeviceId)!,
            deviceTOK: deviceTokenn);

        setState(() {
          loading = false;
        });
        if (response!.result == 'success') {
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
      }
      else {
        Fluttertoast.showToast(msg: "${res?.message}");
        cancel();

        if (res?.result == 'success') {
          setState(() {
            loading = false;
          });
          Get.to(() => RegisterScreen(
                mobile: widget.mobile,
              ));
        }
      }
      Fluttertoast.showToast(msg: "${res?.message}");
      cancel();
    } else {
      Fluttertoast.showToast(msg: "${res?.message}");
      cancel();
    }
  }

  final scaffoldKey = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
