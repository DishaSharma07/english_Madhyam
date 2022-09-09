import 'dart:io';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/editorials_page/player_state.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/practice/performance_report.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../helper/controllers/exam_details/quiz_details.dart';
import 'package:permission_handler/permission_handler.dart';
import '../practice/instructions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class EditorialsDetails extends StatefulWidget {
  final int editorial_id;
  final String editorial_title;

  const EditorialsDetails(
      {Key? key, required this.editorial_id, required this.editorial_title})
      : super(key: key);

  @override
  _EditorialsDetailsState createState() => _EditorialsDetailsState();
}

class _EditorialsDetailsState extends State<EditorialsDetails>
    with SingleTickerProviderStateMixin {
  final QuizDetailsController Quizcontroller = Get.put(QuizDetailsController());
  final HtmlConverter _htmlConverter = HtmlConverter();

  final EditorialDetailController controller =
      Get.put(EditorialDetailController());
  late bool _permissionReady;
  String TaskID = "";

  final ReceivePort _port = ReceivePort();
  List<TaskInfo>? _tasks;

  final fileName = '/English-madhyam.pdf';
  int position = 0;
  List<Gradient> color = [
    learning1,
    learning2,
    learning3,
    learning4,
    learning5,
    learning6
  ];
  bool darkmode = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ItemScrollController itemScrollController = ItemScrollController();

  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;
  String type = "";
  int CurrentVideo = 0;
  double custFontSize = 17;
  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      // print(
      //   'Callback on UI isolate: '
      //       'task ($TaskID) is in status ($status) and process ($progress)',
      // );
      if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && TaskID != null) {
        String query = "SELECT * FROM task WHERE task_id='" + TaskID + "'";
        var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: TaskID);
      }
      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == TaskID);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id,
      DownloadTaskStatus status,
      int progress,
      ) {
    // print(
    //   'Callback on background isolate: '
    //       'task ($id) is in status ($status) and process ($progress)',
    // );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }
  void increaseFontSize() async {
    if (custFontSize >= 30.0) {
      Fluttertoast.showToast(msg: "Maximum Size");
      cancel();
    } else {
      setState(() {
        custFontSize += 2;
      });
    }
  }

  void decreaseFontSize() async {
    if (custFontSize <= 17.0) {
      Fluttertoast.showToast(msg: "Minimum Size");
      cancel();

      setState(() {
        custFontSize = 17;
      });
    } else {
      setState(() {
        custFontSize -= 1;
      });
    }
  }

  late String _localPath;
  bool notadded = false;

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        // print("NOt UUUUU exception");

        externalStorageDirPath =
            (await getExternalStorageDirectory())!.path;
      } catch (e) {
        // print(e.toString() + "exception");
        final directory = (await getExternalStorageDirectory())!.absolute.path;
        externalStorageDirPath = directory;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    // print(externalStorageDirPath.toString());
    return externalStorageDirPath;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    // print(_localPath.toString() + "oooooooo");
    final savedDir = Directory(_localPath);
    final hasExisted = await savedDir.exists();
    // print(hasExisted);

    if (!hasExisted) {
      // print(hasExisted);
      await savedDir.create();
    }
  }



  AnimationController? _recordAnimCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _permissionReady = false;
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    if (_permissionReady) {
      _prepareSaveDir();
    }

    _recordAnimCtrl =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();

    controller.pageManager.value.dispose();
    _recordAnimCtrl!.dispose();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void _requestDownload(TaskInfo task) async {
    // print("kkkkk");
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      saveInPublicStorage: true,
      requiresStorageNotLow: true,
      fileName: task.name,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );
    setState(() {
      // print(task.status);
      TaskID = task.taskId!;
    });
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();
    if (hasGranted) {
      await _prepareSaveDir();
    }
    setState(() {
      _permissionReady = hasGranted;
    });
  }

  double speed = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkmode == false ? whiteColor : blackColor,
      key: _scaffoldKey,
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
          child: Drawer(
            backgroundColor: const Color(0xffccccff).withOpacity(0.6),
            child: Obx(() {
              if (controller.loading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Center(
                    child: Lottie.asset(
                      "assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // InkWell(
                          //     onTap: () {
                          //       setState(() {
                          //         type = "Bottom";
                          //       });
                          //     },
                          //     child: Container(
                          //         margin: EdgeInsets.only(right: 20),
                          //         padding: EdgeInsets.all(5),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(4),
                          //             color: type == "Bottom"
                          //                 ? purpleColor.withOpacity(0.8)
                          //                 : whiteColor),
                          //         child: CustomDmSans(
                          //           text: "Bottom",
                          //           fontSize: 12,
                          //           color: type == "Bottom"
                          //               ? whiteColor
                          //               : blackColor,
                          //         ))),
                          //DrakMode
                          InkWell(
                              onTap: () {
                                setState(() {
                                  darkmode = !darkmode;
                                });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: darkmode == true
                                          ? blackColor
                                          : whiteColor),
                                  child: CustomDmSans(
                                    text: darkmode == true
                                        ? "Light Mode"
                                        : "Dark Mode",
                                    fontSize: 12,
                                    color: darkmode == true
                                        ? whiteColor
                                        : blackColor,
                                  ))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (controller.meaningListModel.value.result == false)
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                      'assets/animations/49993-search.json',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                  CustomDmSans(
                                    text: "No meanings Available",
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: ScrollablePositionedList.builder(
                                itemScrollController: itemScrollController,
                                initialScrollIndex: position,
                                addAutomaticKeepAlives: true,
                                itemCount: controller
                                    .meaningListModel.value.editorials!.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  String resultText =
                                      _htmlConverter.parseHtmlString(controller
                                          .meaningListModel
                                          .value
                                          .editorials![index]
                                          .meaning
                                          .toString());
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        position = index;
                                      });
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            position == index
                                                ? Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Icon(
                                                      Icons.bookmark,
                                                      color: redColor,
                                                      size: 14,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            CustomDmSans(
                                              text:
                                                  "${controller.meaningListModel.value.editorials![index].word} : ",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            CustomDmSans(
                                              text: resultText,
                                              fontSize: 16,
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: themePurpleColor,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        leading: BackButton(
          color: whiteColor,
        ),
        title: Text(
          widget.editorial_title.length > 35
              ? widget.editorial_title.substring(0, 35) + ".."
              : widget.editorial_title,
          style: GoogleFonts.lato(color: whiteColor, fontSize: 17),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              increaseFontSize();
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(top: 13, bottom: 13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(2)),
                color: const Color(0xffccccff).withOpacity(0.6),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          GestureDetector(
            onTap: () {
              decreaseFontSize();
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(top: 13, bottom: 13, left: 6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2)),
                color: const Color(0xffccccff).withOpacity(0.6),
              ),
              child: const Icon(Icons.remove),
            ),
          ),
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(
                Icons.list,
                color: whiteColor,
              ))
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: GetBuilder<EditorialDetailController>(
                  init: EditorialDetailController(),
                  builder: (_controller) {
                    if (kDebugMode) {}
                    if (_controller.loading.value) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Lottie.asset(
                            "assets/animations/loader.json",
                            height: MediaQuery.of(context).size.height * 0.14,
                          ),
                        ),
                      );
                    } else {
                      if (_controller
                              .editorials.value.editorialDetails!.description !=
                          null) {
                        // newword =  _htmlConverter.parseHtmlString(
                        //     controller.editorials.value.editorialDetails!.description!).split(" ");

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller
                                  .editorials.value.editorialDetails!.title
                                  .toString(),
                              style: GoogleFonts.dmSans(
                                  color: darkmode == false
                                      ? redColor
                                      : Colors.amber,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(_controller.editorials
                                          .value.editorialDetails!.image!),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _controller.editorials.value.editorialDetails!
                                    .audio!.isNotEmpty
                                ? audioPlayerSection()
                                : const Text(""),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: blackColor,
                                            size: 8,
                                          ),
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: blackColor,
                                            size: 8,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          CustomDmSans(
                                            text: "Swipe",
                                            color: purpleColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  _controller.editorials.value.editorialDetails!
                                          .pdf!.isNotEmpty
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          child: InkWell(
                                            onTap: () async {

                                              _permissionReady
                                                  ? _requestDownload(TaskInfo(
                                                      name: _controller
                                                          .editorials
                                                          .value
                                                          .editorialDetails!
                                                          .title,
                                                      link: _controller
                                                          .editorials
                                                          .value
                                                          .editorialDetails!
                                                          .pdf![0]
                                                          .file!,
                                              ))
                                                  : _retryRequestPermission();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icon/downloadicon.svg",
                                                ),
                                                CustomDmSans(text: "PDF")
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            _controller.meaningListModel.value.result == false
                                ? SizedBox(
                                    child: Text(
                                      _htmlConverter.parseHtmlString(controller
                                          .editorials
                                          .value
                                          .editorialDetails!
                                          .description!),
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        wordSpacing: 10.0,
                                        color: darkmode == true
                                            ? whiteColor
                                            : blackColor,
                                        fontSize: custFontSize,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text.rich(
                                      TextSpan(children: <InlineSpan>[
                                        for (int i = 0;
                                            i <
                                                _controller
                                                    .descritionColorlist.length;
                                            i++)
                                          TextSpan(
                                              text: _controller
                                                      .descritionColorlist[i]
                                                      .word
                                                      .toString() +
                                                  " ",
                                              style: TextStyle(
                                                  wordSpacing: 10.0,
                                                  // color: highlightText(select: newword[i], meaninglist: controller.meaningListModel.value.editorials!)==true?themeYellowColor:darkmode==true?whiteColor:blackColor,
                                                  color: _controller
                                                              .descritionColorlist[
                                                                  i]
                                                              .status ==
                                                          true
                                                      ? const Color(0XFF1BC169)
                                                      : darkmode == true
                                                          ? whiteColor
                                                          : blackColor,
                                                  fontSize: custFontSize),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {});
                                                  _controller.wordMeaning(
                                                      word: _controller
                                                          .descritionColorlist[
                                                              i]
                                                          .word,
                                                      eId: widget.editorial_id
                                                          .toString());
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            content: Obx(() {
                                                              if (_controller
                                                                      .meaningloading
                                                                      .value ==
                                                                  true) {
                                                                return Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  height: 30,
                                                                  // width: 20,
                                                                  child: Lottie
                                                                      .asset(
                                                                    "assets/animations/loader.json",
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.08,
                                                                  ),
                                                                );
                                                              } else if (_controller
                                                                      .meaning
                                                                      .value
                                                                      .vocab ==
                                                                  null) {
                                                                return Container(
                                                                  // height: 200,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(4),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Text(
                                                                    "No meaning available",
                                                                    style: GoogleFonts.dmSans(
                                                                        fontSize:
                                                                            custFontSize,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color:
                                                                            whiteColor),
                                                                  ),
                                                                );
                                                              } else {
                                                                return Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(4),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Text(
                                                                    "${_controller.meaning.value.word.toString()} :${_htmlConverter.parseHtmlString(controller.meaning.value.vocab!.meaning!)} ",
                                                                    style: GoogleFonts.dmSans(
                                                                        fontSize:
                                                                            custFontSize,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: whiteColor
                                                                            .withOpacity(0.8)),
                                                                  ),
                                                                );
                                                              }
                                                            }));
                                                      });
                                                })
                                      ]),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.0),
                            _Quizbutton(),
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("NO DATA NOW!!"),
                        );
                      }
                    }
                  },
                )),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: type == "Bottom"
      //     ?GetBuilder<EditorialDetailController>(
      //     init: EditorialDetailController(),
      //     builder: ( cont) {
      //       if(cont.meaningloading.value==false){
      //
      //         return controller.meaning.value.result!=null?(controller.meaning.value.result==true &&controller.meaning.value.vocab==null)?Container(
      //           color: purpleColor,
      //           padding: const EdgeInsets.all(10),
      //           child: Text(
      //             "No meaning Available",
      //             style: GoogleFonts.dmSans(
      //                 color: whiteColor,
      //                 fontSize: 10,
      //                 fontWeight: FontWeight.w500),
      //           ),
      //
      //
      //         ):Container(
      //           color: purpleColor,
      //           padding: const EdgeInsets.all(10),
      //           child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 controller.meaning.value.word!+" :",
      //                 style: GoogleFonts.dmSans(
      //                     color: whiteColor,
      //                     fontSize: custFontSize,
      //                     fontWeight: FontWeight.w500),
      //               ),
      //               Expanded(
      //                 child: Text(
      //                   "  " +
      //                       _htmlConverter.parseHtmlString( controller.meaning.value.vocab!.meaning!),
      //                   style: GoogleFonts.dmSans(
      //                     color: whiteColor,
      //                     fontSize: custFontSize,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ):Container(
      //           color: purpleColor,
      //           padding: const EdgeInsets.all(10),
      //           child: Text(
      //             " Meaning Shows Here ",
      //             style: GoogleFonts.dmSans(
      //                 color: whiteColor,
      //                 fontSize: 10,
      //                 fontWeight: FontWeight.w500),
      //           ),
      //         );
      //       }else{
      //         return Center(child: Lottie.asset( "assets/animations/loader.json",
      //           height: MediaQuery.of(context).size.height * 0.14,),);
      //       }
      //     },)
      //       : const SizedBox(),
      // ),
    );
  }

  Widget _Quizbutton() {
    // if Quiz is available then show button
    if ((controller.editorials.value.editorialDetails!.quizAvailable!) == 1) {
// if not attempted nd not completed then start quiz

      if ((controller.editorials.value.editorialDetails!.isAttempt!) == 0 &&
          (controller.editorials.value.editorialDetails!.isCompleted!) == 0) {
        return InkWell(
          onTap: () {
            if (controller.editorials.value.editorialDetails!.examId != null) {
              Quizcontroller.examids(
                  controller.editorials.value.editorialDetails!.examId);
              Get.off(() => TestInstructions(
                    title: controller.editorials.value.editorialDetails!.title
                        .toString(),
                    type: 0,
                    examid:
                        controller.editorials.value.editorialDetails!.examId!,
                    catTitle: "",
                  ));
            } else {
              Fluttertoast.showToast(msg: "No Quizz Available");
              cancel();
            }
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: purplegrColor, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: greyColor,
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
                gradient: RadialGradient(
                  center: const Alignment(0.0, 0.0),
                  colors: [purpleColor, purplegrColor],
                  radius: 3.0,
                ),
              ),
              child: Text(
                'Start Quiz',
                style: GoogleFonts.roboto(
                    color: whiteColor,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: const Offset(1.0, 4),
                        blurRadius: 3.0,
                        color: greyColor.withOpacity(0.5),
                      ),
                    ]),
              ),
            ),
          ),
        );
      }
      //if attemptd but not completed then Quiz is pause
      else if ((controller.editorials.value.editorialDetails!.isAttempt!) ==
              1 &&
          (controller.editorials.value.editorialDetails!.isCompleted!) == 0) {
        return InkWell(
          onTap: () {
            if (controller.editorials.value.editorialDetails!.examId != null) {
              controller.editorialid(
                  controller.editorials.value.editorialDetails!.id!);

              Quizcontroller.examids(
                  controller.editorials.value.editorialDetails!.examId);

              Get.off(() => TestInstructions(
                  title: controller.editorials.value.editorialDetails!.title
                      .toString(),
                  type: 0,
                  catTitle: "",
                  examid:
                      controller.editorials.value.editorialDetails!.examId!));
            } else {
              Fluttertoast.showToast(msg: "No Quizz Available");
              cancel();
            }

            // Get.to(() => BottomWidget());
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: purplegrColor, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: greyColor,
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
                gradient: RadialGradient(
                  center: const Alignment(0.0, 0.0),
                  colors: [purpleColor, purplegrColor],
                  radius: 3.0,
                ),
              ),
              child: Text(
                'Resume Quiz',
                style: GoogleFonts.roboto(
                    color: whiteColor,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: const Offset(1.0, 4),
                        blurRadius: 3.0,
                        color: greyColor.withOpacity(0.5),
                      ),
                    ]),
              ),
            ),
          ),
        );
      }
      // if attempted and completed too then show result
      else {
        return InkWell(
          onTap: () {
            Get.to(() => PerformanceReport(
                  id: controller.editorials.value.editorialDetails!.examId!
                      .toString(),
                  eid: controller.editorials.value.editorialDetails!.id!
                      .toString(),
                  title: controller.editorials.value.editorialDetails!.title,
                  catid: controller.editorials.value.editorialDetails!.id!
                      .toString(),
                  Route: 0,
                ));
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: purplegrColor, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: greyColor,
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(1, 2))
                ],
                gradient: RadialGradient(
                  center: const Alignment(0.0, 0.0),
                  colors: [purpleColor, purplegrColor],
                  radius: 3.0,
                ),
              ),
              child: Text(
                'Show Report',
                style: GoogleFonts.roboto(
                    color: whiteColor,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: const Offset(1.0, 4),
                        blurRadius: 3.0,
                        color: greyColor.withOpacity(0.5),
                      ),
                    ]),
              ),
            ),
          ),
        );
      }
    } else {
      return const Text("");
    }
  }

  // Widget videoListing(List<Video> videos) {
  //   return Container(
  //       height: MediaQuery.of(context).size.height * 0.25,
  //       child: ListView.builder(
  //           itemCount: videos.length,
  //           shrinkWrap: true,
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (context, index) {
  //             return InkWell(
  //               onTap: () {
  //                 Get.to(() => BasicPlayerPage(
  //                       url: videos[index].file!,
  //                       title: widget.editorial_title,
  //                     ));
  //               },
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width * 0.6,
  //                 margin: EdgeInsets.all(6),
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(12)),
  //                     gradient: color[index % 6] // color: Colors.red,
  //                     ),
  //                 child: CircleAvatar(
  //                   radius: 30,
  //                   backgroundColor: Colors.transparent,
  //                   child: CircleAvatar(
  //                     backgroundColor: Colors.black45,
  //                     radius: 30,
  //                     child: Center(
  //                       child: Icon(
  //                         Icons.play_arrow_rounded,
  //                         color: whiteColor,
  //                         size: 32,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }));
  // }

  Widget _buildRecordWidget() {
    return AnimatedBuilder(
      animation: _recordAnimCtrl!,
      builder: (_, child) {
        return Transform.rotate(
          angle: _recordAnimCtrl!.value * 2 * math.pi,
          child: child,
        );
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            // color: redColor,
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(
                    controller.editorials.value.editorialDetails!.image!),
                scale: 2,
                fit: BoxFit.cover)),
      ),
    );
  }

  // Widget _buildNeedleWidget() {
  //   return Positioned(
  //     top: 50.0,
  //     right: 0.0,
  //     child: RotationTransition(
  //       turns: _needleAnimCtrl!,
  //       // To make the needle swivel around the white circle
  //       // the alignment is placed placed at the center of the white circle
  //       alignment: FractionalOffset(4 / 5, 1 / 6),
  //       child: NeedleWidget(
  //         size: 130.0,
  //       ),
  //     ),
  //   );
  // }

  Widget audioPlayerSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color:
              darkmode == true ? Colors.white : purplegrColor.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18), bottomRight: Radius.circular(18))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
// gyj
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: _buildRecordWidget(),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.42,
                child: ValueListenableBuilder<ProgressBarState>(
                  valueListenable:
                      controller.pageManager.value.progressNotifier,
                  builder: (_, value, __) {
                    return ProgressBar(
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: controller.pageManager.value.seek,
                    );
                  },
                ),
              ),
              playerButton(context)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      speed = 0.75;
                    });

                    controller.pageManager.value.pointSevenSpeed();
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: speed == 0.75
                            ? themeYellowColor
                            : purpleColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FittedBox(
                            child: CustomDmSans(
                          text: ".75x",
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          align: TextAlign.center,
                        )),
                      ))),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      speed = 1.0;
                    });
                    controller.pageManager.value.oneSpeed();
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: speed == 1.0
                            ? themeYellowColor
                            : purpleColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CustomDmSans(
                          text: "1x",
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          align: TextAlign.center,
                        ),
                      ))),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      speed = 1.25;
                    });
                    controller.pageManager.value.maxSpeed();
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: speed == 1.25
                            ? themeYellowColor
                            : purpleColor.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FittedBox(
                            child: CustomDmSans(
                          text: "1.25x",
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          align: TextAlign.center,
                          fontSize: 12,
                        )),
                      )))
            ],
          )
        ],
      ),
    );
  }

  // Widget audioProgressPlayer() {
  //   return ValueListenableBuilder<ProgressBarState>(
  //     valueListenable: _pageManager.progressNotifier,
  //     builder: (_, value, __) {
  //       return ProgressBar(
  //         progress: value.current,
  //         progressBarColor: themeYellowColor,
  //         thumbColor: purpleColor,
  //         buffered: value.buffered,
  //         total: value.total,
  //         onSeek: _pageManager.seek,
  //       );
  //     },
  //   );
  // }

  Widget playerButton(BuildContext context) {
    // return ValueListenableBuilder<ButtonState>(
    //   valueListenable: _pageManager.buttonNotifier,
    //   builder: (_, value, __) {
    //     switch (value) {
    //       case ButtonState.loading:
    //
    //         return Container(
    //           height: 20,
    //           width: 20,
    //           margin: const EdgeInsets.all(8.0),
    //
    //           child: const CircularProgressIndicator(),
    //         );
    //       case ButtonState.paused:
    //
    //         return InkWell(
    //           onTap: _pageManager.play,
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.blue.shade600
    //             ),
    //             child: IconButton(
    //               padding: const EdgeInsets.all(2),
    //               icon:  Icon(Icons.play_arrow,color: themeYellowColor,),
    //               iconSize: 28.0,
    //               onPressed:_pageManager.play,
    //             ),
    //           ),
    //         );
    //       case ButtonState.playing:
    //         return InkWell(
    //           onTap:  _pageManager.pause,
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.blue.shade600
    //             ),
    //             child: IconButton(
    //               icon:  Icon(Icons.pause,color: themeYellowColor,),
    //               iconSize: 20.0,
    //               onPressed: _pageManager.pause,
    //             ),
    //           ),
    //         );
    //     }
    //   },
    // );
    return ValueListenableBuilder<ButtonState>(
      valueListenable: controller.pageManager.value.buttonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: controller.pageManager.value.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: controller.pageManager.value.pause,
            );
        }
      },
    );
  }
}

class TaskInfo {
  final String? name;
  final String? link;
  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status ;

  TaskInfo({this.name, this.link});
}

class Description {
  String word;
  bool status;

  Description({required this.word, required this.status});
}
