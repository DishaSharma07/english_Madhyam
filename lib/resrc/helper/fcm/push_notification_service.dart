import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    } else {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
    }
    //_fcm.subscribeToTopic(MyConstant.topicName);

    ///when app is terminated
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'test_channel',
            title: message.notification!.title.toString(),
            body: message.notification!.body.toString(),
            bigPicture: message.data.isNotEmpty ? message.data[0] : null,
            notificationLayout: message.data.isEmpty
                ? NotificationLayout.Default
                : NotificationLayout.BigPicture,
          ),
        );
      }
    });

    ///when app is open and foreground.
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null && Platform.isAndroid) {
        createNotification(message, "foreground");
      }
    });


    ///when app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {}
    });
    //only working for foreground
    // AwesomeNotifications().ac.listen((ReceivedAction receivedAction) {
    //   /*handleMessage(
    //       page: receivedAction.payload?["page"]??"",
    //       notificationId: receivedAction.payload?["id"] ?? "",
    //       appStatus: "background");
    //
    //   if (receivedAction.buttonKeyPressed == 'open') {
    //     handleMessage(
    //         page: receivedAction.payload?["page"]??"",
    //         notificationId: receivedAction.payload?["id"] ?? "",
    //         appStatus: "background");
    //   }*/
    // });
  }

  //only working for foreground
  createNotification(RemoteMessage message, String key) {
    String? imageUrl;
    imageUrl ??= message.notification!.android?.imageUrl;
    imageUrl ??= message.notification!.apple?.imageUrl;
    return  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'test_channel',
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        bigPicture: imageUrl,
        notificationLayout: imageUrl == ''
            ? NotificationLayout.Default
            : NotificationLayout.BigPicture,
      ),
      actionButtons: [
        NotificationActionButton(
          key: "open",
          label: 'Open Notification',
          // buttonType: ActionButtonType.Default,
          enabled: true,
          //icon: 'resource://drawable/ic_launcher',
        ),
      ],
    );
  }

  handleMessage({required page, required notificationId, required appStatus}) {
    if (appStatus == "background" && page!=null) {
      AuthenticationManager manager = Get.find();
    } else if (appStatus == "terminate") {
      AuthenticationManager manager = Get.find();

    }
  }
}
