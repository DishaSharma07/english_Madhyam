import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/birthdayModel.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/helper/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/src/helper/model/secondarywarning_model.dart';
import 'package:english_madhyam/src/helper/model/succes.dart';
import 'package:english_madhyam/src/helper/providers/home_providers/task_provider.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var loading = true.obs;
  var Birthloading = true.obs;
  Rx<BirthDayModel> birthDayModel = BirthDayModel().obs;
  Rx<MandatoryUpdate> mandatoryUpdateRx = MandatoryUpdate().obs;
  Rx<Success> warningPopRx=Success().obs;
  Rx<SecondaryWarningModel> secondaryWarningPopRx=SecondaryWarningModel().obs;

  @override
  void onInit() async {
    super.onInit();
  }

  HttpService _httpService = HttpService();
  List<Banners> banner = <Banners>[].obs;
  List<Quizz> quizs = <Quizz>[].obs;
  List<Achievers> achievers = <Achievers>[].obs;
  List<Editorials> courses = <Editorials>[].obs;
  RxString Mentors = "".obs;
  RxBool is_subscribed = false.obs;
  RxString succesRate = "".obs;
  RxString students = "".obs;


  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
    else {
      throw 'Could not launch $url';
    }
  }


  Future<void> homeApiFetch() async {
    print("HOMEEEE");
    final _prefs = await SharedPreferences.getInstance();
    try {
      loading(true);
      var response = await TaskProvider()
          .HomeApi(DeviceId: _prefs.getString("device_id")!);
      if (response != null) {
        banner = response.homeDetails!.banners!;
        quizs = response.homeDetails!.quizz!;
        achievers = response.homeDetails!.achievers!;
        courses = response.homeDetails!.editorials!;
        is_subscribed.value = response.homeDetails!.isSubscribed!;
        Mentors.value = response.homeDetails!.mentors.toString();
        succesRate.value = response.homeDetails!.successRate.toString();
        students.value = response.homeDetails!.students.toString();
        BirthDayContr();
        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();
    } finally {
      loading(false);
    }
  }

  Future<void> BirthDayContr() async {
    final _prefs = await SharedPreferences.getInstance();

    try {
      Birthloading(true);
      var response = await _httpService.BirthDay();
      if (response != null) {
        birthDayModel.value = response;
        if (response.result == true) {
          _prefs.setBool("Birthday", true);
        } else {
          _prefs.setBool("Birthday", false);
        }

        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();
    } finally {
      Birthloading(false);
    }
  }

  /// Secondary pop
  Future<void> SecWarningPopContr(
      BuildContext context) async {
    try {
      print("WARNING POP UP");
      var response = await _httpService.secondaryWarning();
      if (response != null) {
        secondaryWarningPopRx.value = response;

        print(response.message.toString()+"==========");

        if (response.results!.isActive!="1") {
          _showMaintanceDialog(context: context,title: response.message,show: response.results!.status=="1"?false:true);
        }


        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();
    }
  }
/// Warning Pop Controller
  Future<void> warningPopContr(
     BuildContext context) async {
    try {
      print("WARNING POP UP");
      var response = await _httpService.warningPop();
      if (response != null) {
        warningPopRx.value = response;

        print(response.message.toString()+"==========");

        if (response.message!="") {
          _showMaintanceDialog(context: context,title: response.message);
        }


        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();
    }
  }
  ///warning dialog Box
  _showMaintanceDialog({required BuildContext context, String? title, bool?show}) async {
    showDialog(
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => show==true||show==null?true:false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox1(context,title!),
            ),
          );
        },
        context: context);
  }

  ///warning Pop Content Box
  contentBox1(context,String title) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 10,
              top: 30,
              right: 10,
              bottom: 10),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset("assets/img/warning.jpg"),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: CustomDmSans(
                      text: "Continue",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),
        ), // bottom part
        Positioned(
          left: 10,
          right:10,
          child: CircleAvatar(
            backgroundColor: themeYellowColor,
            radius: 40,
            child: const ClipRRect(
                borderRadius:
                BorderRadius.all(Radius.circular(20)),
                child: Icon(Icons.warning_amber_rounded,color: Colors.white,size: 35,)),
          ),
        ), // top part
      ],
    );
  }
///mandatory update controller
  Future<void> mandatoryUpdateContr(
      int currentAppVersion, String type, BuildContext context) async {
    try {
      var response = await _httpService.mandatoryUpdate();
      if (response != null) {
        mandatoryUpdateRx.value = response;
        if (type == "android" || type == "Android") {
          print("ENTERED -================");
        print(currentAppVersion);

        if (currentAppVersion < response.version!.androidMan!) {
            _showUpdateDialog(context,response.version!.androidMan!,currentAppVersion);
          }
        }

        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();
    }
  }
/// mandatory update dialog
  _showUpdateDialog(BuildContext context,int appVersion,int currappVersion) async {
String url=" https://play.google.com/store/apps/details?id=" + "com.englishmadhyam";
   showDialog(
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context,appVersion,url,currappVersion),
            ),
          );
        },
        context: context);
  }


/// mandatory update content Box
  contentBox(context,int appVersion,String url,int currVersion) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 10,
              top: 30,
              right: 10,
              bottom: 10),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "New Update Available",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w600, color: redColor),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Latest version: ${appVersion.toString()}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Text(
                "Current version: ${currVersion.toString()}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchUrl(url);
                    },
                    child: CustomDmSans(
                      text: "Update Now",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),
        ), // bottom part
        Positioned(
          left: 10,
          right: 10,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  "assets/img/logo_round.png",
                  fit: BoxFit.fill,
                )),
          ),
        ), // top part
      ],
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
