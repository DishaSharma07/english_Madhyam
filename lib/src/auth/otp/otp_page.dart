import 'dart:async';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/src/auth/sign_up/controller/signup_controller.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:flutter/foundation.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resrc/widgets/boldTextView.dart';
import '../../../resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import '../../../resrc/widgets/rounded_button.dart';

class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({Key? key, required this.mobile}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final SignupController controller = Get.put(SignupController());
  final AuthenticationManager authenticationController = Get.find();
  TextEditingController otp = TextEditingController();
  final ValueNotifier<String> otpErrorNotifier = ValueNotifier<String>("");
  late Timer _timer;
  String otpCode = "";
  int _start = 60;
  var resentMsg = 'Resend OTP';
  var isTimerIsRunning = false;
  var isTimerEmailIsRunning = false;

  final scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),
                  CustomRoboto(
                    text: "Get Better Every Day, Practice",
                    fontSize: 18,color: Colors.black,
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
                    height: size.height * 0.25,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "We have sent verification code to your registered Phone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( widget.mobile,style: const TextStyle(fontSize: 16,color: Colors.black),),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  SizedBox(height: context.height * 0.05),
                  OTPTextField(
                    length: 4,
                    width: context.width,
                    fieldWidth: 55.0,
                    outlineBorderRadius: 7,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (pin) {
                      setState(() {
                        if (pin.length < 2) {
                          otpCode = "";
                        }
                      });
                    },
                    onCompleted: (pin) {
                      setState(() {
                        otpCode = pin;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                      text: "Verify OTP",
                      press: () {
                        if (otpCode.isEmpty) {
                          UiHelper.showSnakbarMsg(context, "Please enter OTP.");
                          return;
                        } else {
                          controller.otpVerify(
                              context: context,
                              mobile: widget.mobile,
                              otp: otpCode);
                        }
                      }),
                  SizedBox(height: context.height * 0.03),
                  Center(
                      child: isTimerIsRunning
                          ? RegularTextDarkMode(
                              text: '${"Resend In"} $_start ${"Seconds"}',
                              textSize: 14)
                          : resentOTPWidget(context)),
                  SizedBox(height: context.height * 0.03),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child:
                Obx(() => controller.loading.value || authenticationController.loading.value ? const Loading() : const SizedBox()),
          )
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isTimerIsRunning = false;
          });
        } else {
          setState(() {
            _start--;
            isTimerIsRunning = true;
          });
        }
      },
    );
  }

  Widget resentOTPWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const RegularTextDarkMode(
          text: "Don’t Receive the Code?",
        ),
        GestureDetector(
          onTap: () async {
            authenticationController.sendOtp(
                context: context, mobile: widget.mobile);
            _start = 60;
            startTimer();
          },
          child: const Text(
            "Resend OTP",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
