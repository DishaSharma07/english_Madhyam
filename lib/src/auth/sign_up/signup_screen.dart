import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/sign_up/model/city_model.dart';
import 'package:english_madhyam/src/auth/sign_up/model/state_model.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:lottie/lottie.dart';


class RegisterScreen extends StatefulWidget {
  final String? mobile;
  final String? email;

  const RegisterScreen({Key? key,  this.mobile,this.email}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController dobcontroller = TextEditingController();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String deviceTokenn="";
  deviceToken()async{
    FirebaseMessaging messaging;
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    await messaging.getToken().then((value) {
      if(value!=null){
        // setToken(value);
        setState(() {
          deviceTokenn=value;

        });
      }
    });
    return deviceTokenn ;

  }
  HttpService httpService = HttpService();
  var dropdownvalueCity;
  var dropdownvalueState;
  final _formKey = GlobalKey<FormState>();
  String _dob = "";
  DateTime ?dateTime;
  late int _state, _city;
  String boardData = "";
  String classData = "";
  List<StateList> _states = [];
  List<CityList> _cities = [];

  // List of items in our dropdown menu

//for device info
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        // deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo)!;
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
        'brand': build.brand,
        'device': build.device,
        'id': build.id,
        'type': build.type,
        'androidId': build.androidId,

      };
    }catch(e){
      Fluttertoast.showToast(msg: "Failed to get Platform version"+e.toString());
      cancel();
    }

  }
  _submit_form(String dob) async {
    setState(() {
      isLoading = true;
    });
    if(dropdownvalueState!=null &&dropdownvalueCity !=null){
      if (_formKey.currentState!.validate()) {
        Fluttertoast.showToast(msg: "Form Validated ");
        cancel();
        var response = await httpService.signUpApi(
            State: dropdownvalueState.toString(),
            email: widget.email!=null?widget.email!:null,
            phone: widget.mobile!=null?widget.mobile!:mobilecontroller.text.trim(),
            name: namecontroller.text,
            city_id: dropdownvalueCity.toString(),
            date_of_birth: dobcontroller.text,
            deviceID: _deviceData['id'],
            deviceToken: deviceTokenn,
            deviceType: Platform.isAndroid?"Android":"IOS");
        if (response?.result == 'success') {
          Fluttertoast.showToast(msg: "init");

          final prefs = await SharedPreferences.getInstance();
          try{
            Fluttertoast.showToast(msg: "start try");
            prefs.setString('token', response!.token.toString());
            prefs.setInt('userID', response.user!.id!.toInt());
            prefs.setString('name', response.user!.name.toString());
            prefs.setString('phone', response.user!.phone.toString());
            prefs.setString('email', response.user!.email.toString());
            prefs.setString('image', response.user!.image.toString());
            prefs.setString('dob', response.user!.dateOfBirth.toString());
            prefs.setInt('state_id', response.user!.stateId ?? 0);
            prefs.setInt('city_id', response.user!.cityId??0);
            Fluttertoast.showToast(msg: "end try");
            setState(() {
              isLoading = false;
            });
            try{
              prefs.setString('device_id', _deviceData['id']);

            }catch(e){
              Fluttertoast.showToast(msg: "In Device Id catch $e");

            }
            try{
              cancel();
            }catch(e){
              Fluttertoast.showToast(msg: "cancel");
            }

            Get.offAll(() => const BottomWidget());
          }catch(e){

            Fluttertoast.showToast(msg: e.toString());
          }

        }else{

          Fluttertoast.showToast(msg: response!.message! +'      ${response.result!}');

        }
        setState(() {
          isLoading = false;
        });
      }
    }else{

      cancel();

    }

  }

  String? validateName(String value) {
    value = namecontroller.text;
    if (value == null || value.length == 0) {
      return 'Please enter your name';
    }
    return null;
  }

  _callWebService() async {
    setState(() {
      isLoading = true;
    });

    var res2 = await httpService.state_api();
    setState(() {
      isLoading = false;
    });
    if (res2!.result == 'success') {
      _states = res2.list!;
    }
  }

  getCity({required int stateId}) async {
    _city = 0;
    var res3 = await httpService.cityApi(State: stateId.toString());
    if (res3?.result == 'success') {
      setState(() {
        _cities = res3!.list!;
      });
    }
  }

  bool state = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callWebService();
    initPlatformState();
    deviceToken();
    mobilecontroller.text = (widget.mobile!=null?widget.mobile:"")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SafeArea(
            child: ListView(
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
                        style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/img/signup.png",
                    scale: 1.0,
                    alignment: Alignment.center,
                  ),
                ),
                TextFormField(
                  controller: namecontroller,
                  keyboardType: TextInputType.name,
                  style: GoogleFonts.roboto(color: blackColor, fontSize: 16),
                  decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      suffixIcon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                        size: 18,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  readOnly: widget.mobile!=null?true:false,
                  controller: mobilecontroller,
                  maxLength: 10,
                  enabled: widget.mobile!=null?false:true,
                  validator: (val){
                    if(val!.isNotEmpty&&val.length==10){
                      return null;
                    }else{
                      return "Enter Valid Number";
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
                TextFormField(
                  controller: dobcontroller,
                  // enabled: false,
                  readOnly: true,
                  decoration:  InputDecoration(
                    suffixIcon: IconButton(icon:const Icon(Icons.calendar_today_rounded),color: purplegrColor,onPressed: ()async{
                      DateTime? newDateTime = await showRoundedDatePicker(
                        height: MediaQuery.of(context).size.height * 0.3,
                        styleDatePicker: MaterialRoundedDatePickerStyle(
                          backgroundHeader: themeYellowColor,
                        ),
                        context: context,
                        initialDate: dateTime,

                        firstDate: DateTime(1940),
                        lastDate: DateTime.now().add(const Duration(seconds: 4)),
                        theme: ThemeData(primarySwatch: Colors.pink),
                      );

                      if (newDateTime != null) {

                        setState(() {
                          dateTime = newDateTime;
                          dobcontroller.text = "${dateTime!.day}" +
                              "-${dateTime!.month}" +
                              "-${dateTime!.year}";
                        });
                      }
                    },),
                    labelText: "Date of Birth",
                    labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
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
                            hint:  CustomRoboto(text: "Select State",fontSize: 13,fontWeight: FontWeight.w500,),
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
                            items: _states.map((items) {
                              return DropdownMenuItem(
                                value: items.id.toString(),
                                child: Text(items.name.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownvalueState = value;

                                dropdownvalueCity = null;
                                getCity(stateId: int.parse(value.toString()));
                              });
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
                            hint: CustomRoboto(text: "Select City",fontSize: 13,fontWeight: FontWeight.w500,),
                            // Initial Value
                            // isExpanded: true,
                            underline: const Divider(
                              thickness: 0.5,
                            ),
                            value: dropdownvalueCity,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: _cities.map((items) {
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
                Container(
                  margin:const EdgeInsets.only(left: 100, top: 30, right: 100),

                  child: InkWell(
                    onTap: () {
                      _submit_form(dobcontroller.text.trim());
                    },

                    child:
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                        child:    isLoading == true?Lottie.asset(
                          "assets/animations/loader.json",
                          height: MediaQuery.of(context).size.height * 0.04,
                        ):Text(
                          'Register',
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
                )
              ],
            )),
      ),
    );
  }
}
