import 'dart:io';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/src/auth/sign_up/controller/signup_controller.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../../../resrc/widgets/rounded_button.dart';
import '../../../resrc/utils/ui_helper.dart';

class RegisterScreen extends StatefulWidget {
  final String? mobile;
  final String? email;

  const RegisterScreen({Key? key, this.mobile, this.email}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var dobController = TextEditingController();

  final AuthenticationManager authenticationController = Get.find();
  final controller = Get.put(SignupController());

  dynamic dropdownvalueCity;
  dynamic dropdownvalueState;

  final _formKey = GlobalKey<FormState>();
  DateTime? dateTime;
  late int _state, _city;
  String boardData = "";
  String classData = "";

  bool state = false;

  @override
  void initState() {
    super.initState();
    //controller.getState(context: context);
    mobileController.text = widget.mobile??"";
    emailController.text = widget.email??"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),

      ),
      backgroundColor: Colors.white,
      body: GetX<SignupController>(builder: (controller) {
        return Form(
          key: _formKey,
          child: SafeArea(
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Welcome to ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 18)),
                                  TextSpan(
                                      text: 'English Madhyam',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff476CFF),
                                          fontSize: 18)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Tell us about yourself",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/img/signup.png",
                          height: 100,
                          alignment: Alignment.center,
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.roboto(color: blackColor, fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty || value.trim() == null) {
                            return "Please enter name.";
                          }
                          if (!UiHelper.isValidName(value.toString())) {
                            return "Please enter valid name.";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: widget.email != null && widget.email!.isNotEmpty ? true : false,
                        controller: emailController,
                        maxLength: 50,
                        enabled: widget.email != null && widget.email!.isNotEmpty  ? false : true,
                        validator: (value) {
                          if (value!.trim().isEmpty || value.trim() == null) {
                            return "Please enter email Id.";
                          }
                          if (!UiHelper.isEmail(value.toString())) {
                            return "Please enter valid email Id.";
                          }
                        },
                        style: GoogleFonts.roboto(color: blackColor, fontSize: 16),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 16, bottom: 8),
                          labelText: "Email Id",
                          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        readOnly: widget.mobile != null && widget.mobile!.isNotEmpty ? true : false,
                        controller: mobileController,
                        maxLength: 10,
                        enabled: widget.mobile != null && widget.mobile!.isNotEmpty? false : true,
                        validator: (value) {
                          if (value!.trim().isEmpty || value.trim() == null) {
                            return "Please enter mobile number.";
                          }
                          if (!UiHelper.isMobileValid(value.toString())) {
                            return "Please enter valid mobile number.";
                          }
                        },
                        style: GoogleFonts.roboto(color: blackColor, fontSize: 16),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 16, bottom: 8),
                          labelText: "Mobile Number",
                          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                   /*   TextFormField(
                        controller: dobController,
                        // enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            color: purplegrColor,
                            onPressed: () async {
                              DateTime? newDateTime = await showRoundedDatePicker(
                                height: MediaQuery.of(context).size.height * 0.3,
                                styleDatePicker: MaterialRoundedDatePickerStyle(
                                  backgroundHeader: themeYellowColor,
                                ),
                                context: context,
                                initialDate: dateTime,
                                firstDate: DateTime(1940),
                                lastDate:
                                DateTime.now().add(const Duration(seconds: 4)),
                                theme: ThemeData(primarySwatch: Colors.pink),
                              );

                              if (newDateTime != null) {
                                setState(() {
                                  dateTime = newDateTime;
                                  dobController.text = "${dateTime!.day}" +
                                      "-${dateTime!.month}" +
                                      "-${dateTime!.year}";
                                });
                              }
                            },
                          ),
                          labelText: "Date of Birth",
                          labelStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                      BorderSide(width: 0.6, color: Colors.black))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: CustomRoboto(
                                    text: "Select State",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  dropdownColor: whiteColor,
                                  // Initial Value
                                  // isExpanded: true,
                                  underline: const Divider(
                                    thickness: 0.5,
                                  ),
                                  value: dropdownvalueState,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  // Array list of items
                                  items: controller.states.map((items) {
                                    return DropdownMenuItem(
                                      value: items.id.toString(),
                                      child: Text(items.name.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownvalueState = value;
                                      dropdownvalueCity = null;
                                    });
                                    controller.getCity(
                                        context: context,
                                        stateId: int.parse(value.toString()));
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                      BorderSide(width: 0.6, color: Colors.black))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: whiteColor,
                                  hint: CustomRoboto(
                                    text: "Select City",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // Initial Value
                                  // isExpanded: true,
                                  underline: const Divider(
                                    thickness: 0.5,
                                  ),
                                  value: dropdownvalueCity,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  // Array list of items
                                  items: controller.cities.map((items) {
                                    return DropdownMenuItem(
                                      value: items.id.toString(),
                                      child: Text(items.name.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownvalueCity = value;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),*/
                      RoundedButton(
                          text: "Signup",
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              /*if(dropdownvalueState==null){
                                Get.snackbar(
                                  "Alert",
                                  "Please select state.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,

                                );
                                return;
                              }*/
                             /* else if(dobController.text.isEmpty){
                                Get.snackbar(
                                  "Alert",
                                  "Please select Date of Birth.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,

                                );
                                return;
                              }
                              else if(dropdownvalueCity==null){
                                Get.snackbar(
                                  "Alert",
                                  "Please select city.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,

                                );
                                return;
                              }*/
                              Map requestBody = {
                                "state_id": /*dropdownvalueState.toString()*/"",
                                "name": nameController.text.trim(),
                                "date_of_birth": /*dobController.text*/"",
                                "city_id": /*dropdownvalueCity.toString()*/"",
                                "phone": widget.mobile != null && widget.mobile!.isNotEmpty
                                    ? widget.mobile!
                                    : mobileController.text.trim(),
                                "email": widget.email != null && widget.email!.isNotEmpty
                                    ? widget.email!
                                    : emailController.text.trim(),
                                "deviceID": (await PlatformDeviceId.getDeviceId),
                                "deviceToken": authenticationController.getFcmToken(),
                                "deviceType": Platform.isAndroid ? "Android" : "IOS",
                              };
                              controller.signup(requestBody);
                            }

                          }),
                      SizedBox(height: 50,)
                    ],
                  ),
                  controller.loading.value?const Loading():const SizedBox()
                ],
              )),
        );
      }),
    );
  }
}
