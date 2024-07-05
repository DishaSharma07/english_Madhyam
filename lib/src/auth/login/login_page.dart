import 'dart:io';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/rounded_button.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../resrc/widgets/already_have_an_account_acheck.dart';
import '../../../resrc/widgets/or_divider.dart';
import '../../../resrc/utils/ui_helper.dart';
import '../../commonController/authenticationController.dart';
import '../../screen/pages/page/Terms&co.dart';
import '../sign_up/signup_screen.dart';

class LoginPage extends GetView<AuthenticationManager> {
  static const routeName = "/login";
  LoginPage({Key? key}) : super(key: key);

  TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        body: GetX<AuthenticationManager>(
          builder: (controller) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.07),
                        CustomRoboto(
                          text: "Get Better Every Day, Practice",
                          fontSize: 18,color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        CustomRoboto(
                          text: "Test Series and Free Daily Quizzes",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: purpleColor,
                        ),
                        Image.asset(
                          "assets/img/two_child.png",
                          height: size.height * 0.25,
                        ),
                        ListTile(
                          title: CustomRoboto(
                            text: "Sign In",
                            fontSize: 18,color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: CustomRoboto(
                            text: "Welcome back to login.",
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              enabled: true,
                              controller: number,
                              maxLength: 10,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false),
                              style: GoogleFonts.roboto(
                                  fontSize: 16, letterSpacing: 1.0,color: Colors.black),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomRoboto(text: "+91",color: Colors.black,),
                                      Container(
                                        height: 25,
                                        width: 1,
                                        color: blackColor,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      )
                                    ],
                                  ),
                                  prefixStyle: GoogleFonts.roboto(
                                    fontSize: 16,
                                    /*color: blackColor,*/
                                  ),
                                  hintText: "Enter your mobile number ",
                                  hintStyle: GoogleFonts.roboto(
                                    fontSize: 16,
                                    color: greyColor,
                                  )),
                              validator: (String? value) {
                                if (value!.trim().isEmpty ||
                                    value.trim() == null) {
                                  return 'Please enter mobile';
                                } else if (UiHelper.isNumber(value)) {
                                  if (!UiHelper.isValidPhoneNumber(value)) {
                                    return 'Please enter valid mobile number';
                                  }
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RoundedButton(
                            text: "Login",
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                controller.sendOtp(
                                    context: context,
                                    mobile: number.text.trim());
                              }
                            }),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        const OrDivider(),
                        Platform.isAndroid
                            ? InkWell(
                                onTap: () async {
                                  controller.handleSignIn(context);
                                },
                                child: Image.asset(
                                  "assets/img/google.png",
                                  scale: 1.8,
                                ),
                              )
                            : const SizedBox(),
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
                Align(
                  alignment: Alignment.center,
                  child: controller.loading.value
                      ? const Loading()
                      : const SizedBox(),
                )
              ],
            );
          },
        ));
  }
}
