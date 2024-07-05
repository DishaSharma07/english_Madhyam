import 'package:english_madhyam/resrc/widgets/regularTextView.dart';



import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';


import '../widgets/boldTextView.dart';

class UiHelper {

  static bool isNumber(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }
  static Future<bool> showConfirmDialog({title, content}) async {
    var result = await Get.dialog(AlertDialog(
      title: BoldTextView(
        text: title,
        color: primaryColor,
        textAlign: TextAlign.start,
        textSize: 16,
      ),
      content: Text(content),
      actions: [
        TextButton(
          child: const RegularTextView(
            text: "OK",
            color: primaryColor,
          ),
          onPressed: () => Get.back(result: true),
        ),
      ],
    ));
    return result;
  }


  static bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return true;
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static showDialog() {
    Get.dialog(CupertinoAlertDialog(
      title: const Text('English Madhyam'),
      content: const Text('Please manage your account setting from website'),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }
  static showINfoDialog(dynamic content) {
    Get.dialog(CupertinoAlertDialog(
      title: const Text('English Madhyam'),
      content: Html(
        data: content ?? "",style: {
        "p": Style(fontSize: FontSize(14.0),textAlign: TextAlign.justify,maxLines: 4)
      },
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }

  static Future<bool> showInfoDialog() async {
    String title = "New Update Available";
    String message =
        "There is a newer version of app available please update it now.";
    String btnLabel = "Update Now";
    String btnLabelCancel = "Later";

    var result =await Get.dialog(
        AlertDialog(
        title: BoldTextView(
          text: title,
          color: primaryColor,
          textAlign: TextAlign.start,
          textSize: 16,
        ),
        content: Text(message),
        actions: [
          OutlinedButton(
            child: Text(btnLabel),
            onPressed: (){
              Get.back(result: true);
            },
          ),
          OutlinedButton(
            child: Text(btnLabelCancel),
            onPressed: (){
              Get.back(result: false);
            },
          ),
        ],
      ));
    return result;
  }



  static Future<bool> showAlertDialog({title, message, yes, no}) async {
    var response = await Get.dialog(AlertDialog(
      title: BoldTextView(text: "",textSize: 28,),
      content: RegularTextView(text: message,),
      actions: [
        TextButton(
          child: RegularTextView(text: no,),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        TextButton(
          child: RegularTextView(text: yes,),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ],
    ));
    return response;
  }



  static void showFailureMsg(BuildContext? context, String message) {
    Get.snackbar(
      "Alert", message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showSuccessMsg(BuildContext? context, String message) {
    Get.snackbar(
      "Alert", message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ));*/
  }

  static String getFormattedChatDate({date}) {
    print(date);
    if (date.isEmpty) {
      return "";
    }

    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date, true);

    var outputFormat = DateFormat("dd-MMM-yyyy");

    //var outputFormat = DateFormat('dd MMM, yyyy');
    var outputDate = outputFormat.format(parseDate);
    //print("selected timezone-:$outputDate");
    return outputDate;
  }



  static Widget getLoadingImage({imageUrl}) {
    print("image url-> $imageUrl");
    return imageUrl==null || imageUrl.toString().isEmpty?SizedBox():Image.network(
      imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );

  }

  static bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 7) {
      return false;
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }


  static bool isValidName(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 2) {
      return false;
    }
    return true;
  }

  static bool isValidPasswords(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool isValidPassword(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 8) {
      return false;
    }
    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v

    return true;
  }

  static void showSnakbarMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }

  static void showSnakbarSucess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ));
  }

  static String formatedAmount(dynamic amount) {
    return double.parse(amount.toString()).toStringAsFixed(1).toString();
  }

  static bool isMobileValid(String phone) {
    if (phone.isEmpty || phone == null) {
      return false;
    } else if (!isValidPhoneNumber(phone)) {
      return false;
    } else {
      return true;
    }
  }
}
