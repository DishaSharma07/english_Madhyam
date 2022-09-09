// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// String? selectedNotificationPayload;
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String title;
//   final String body;
//   final String payload;
// }
//
//
// class DownloadDocs extends StatefulWidget {
//   DownloadDocs({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _DownloadDocsState createState() => _DownloadDocsState();
// }
//
// class _DownloadDocsState extends State<DownloadDocs> {
//
//
//
//   @override
//   void initState() {
//
//     // setUp();
//
//
//     super.initState();
//   }
//
//
//   setUp()async{
//
//     WidgetsFlutterBinding.ensureInitialized();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//           print("////////////////////////");
//           if (payload != null) {
//             debugPrint('notification payload: $payload');
//           }
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Text(
//           'Download Progress Notification',
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await _showProgressNotification();
//         },
//         tooltip: 'Download Notification',
//         child: Icon(Icons.download_sharp),
//       ),
//     );
//   }
//
//   Future<void> _showProgressNotification() async {
//     const int maxProgress = 5;
//     for (int i = 0; i <= maxProgress; i++) {
//       await Future<void>.delayed(const Duration(seconds: 1), () async {
//         final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails('progress channel', 'progress channel',
//             channelShowBadge: false,
//             importance: Importance.max,
//             priority: Priority.high,
//             onlyAlertOnce: true,
//             showProgress: true,
//             maxProgress: maxProgress,
//             progress: i);
//         final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//         await flutterLocalNotificationsPlugin.show(
//             0,
//             'progress notification title',
//             'progress notification body',
//             platformChannelSpecifics,
//             payload: 'item x');
//       });
//     }
//   }
// }