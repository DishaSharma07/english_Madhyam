import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/resrc/models/model/pdf_list_model.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:english_madhyam/src/screen/pages/page/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../../../custom/semiBoldTextView.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';
import '../../profile/controller/profile_controllers.dart';
import '../controller/pdf_list_control.dart';
import 'editorial_category_list.dart';

class MaterialSubCategoryPage extends StatefulWidget {
  final String catid;
  final String subCateId;
  final String title;
  final String type;

  const MaterialSubCategoryPage(
      {Key? key,
      required this.catid,
      required this.subCateId,
      required this.type,
      required this.title})
      : super(key: key);

  @override
  _MaterialSubCategoryPageState createState() =>
      _MaterialSubCategoryPageState();
}

class _MaterialSubCategoryPageState extends State<MaterialSubCategoryPage>
    with TickerProviderStateMixin {
  final PdfController _pdfController = Get.put(PdfController());
  final _catEditorialContr = Get.put(EditorialDetailController());
  late String _localPath;
  final GlobalKey<SfPdfViewerState> _allContentsKey = GlobalKey();
  int? downloadStarted;
  final AuthenticationManager authController = Get.find();
  final ProfileControllers _subcontroller = Get.put(ProfileControllers());

  bool? _permissionReady;
  late TabController tabController;
  String TaskID = "";

  /// pdf download section
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;

  /// permission for downloading pdf
  Future<bool> _requestPermissions() async {
    var permission =
        await _permissionHandler.checkPermissionStatus(Permission.storage);

    if (permission != PermissionStatus.granted) {
      await _permissionHandler.requestPermissions([Permission.storage]);
      permission =
          await _permissionHandler.checkPermissionStatus(Permission.storage);
    }

    return permission == PermissionStatus.granted;
  }

  ///download directory get
  Future<Directory?> _getDownloadDirectory() async {
    try {
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();
      return directory!;
    } catch (e) {
      return await getExternalStorageDirectory();
    }
  }

  ///download pdf
  Future<void> _download(String? file, int? index) async {
    setState(() {
      downloadStarted = index;
    });
    try {
      final dir = await _getDownloadDirectory();
      final isPermissionStatusGranted = await _requestPermissions();

      final hasExisted = dir?.existsSync() ?? false;
      if (!hasExisted) {
        await dir?.create();
      }
      if (isPermissionStatusGranted || dir != null) {
        // print(file!.length.toString() + "FILE LENGTH");
        final savePath = path.join(dir!.path, widget.title + ".pdf");
        // Fluttertoast.showToast(msg: savePath);
        cancel();

        await _startDownload(savePath, file!);
      } else {
        // print("user decline download permission");
        // handle the scenario when user declines the permissions
      }
    } catch (e) {}
  }

  ///dio for start downloading
  Future<void> _startDownload(String savePath, String file) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      result =
          await apiService.downloadPdfFile(filePath: file, savePath: savePath);
      if (result['isSuccess'] == true) {
        await _showNotification(result);
        Fluttertoast.showToast(msg: savePath.toString());
        cancel();
        Fluttertoast.showToast(msg: "Pdf Downloaded in your app folder");
        setState(() {
          downloadStarted = null;
        });
      }
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {}
  }

  /// local notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('1', 'channel name',
        // 'channel description',
        priority: Priority.high,
        importance: Importance.max);

    final platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    // print("${platform.iOS!.subtitle}" + "platform information");

    await flutterLocalNotificationsPlugin!.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _catEditorialContr.editorialByCat.clear();
    _catEditorialContr.categoryId(int.parse(widget.catid));

    /// pdf download initialization
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/logo_round');

    if (Platform.isAndroid) {
      final initSettings = InitializationSettings(android: android);
      flutterLocalNotificationsPlugin!.initialize(initSettings);
    }

    _permissionReady = false;

    tabController = TabController(length: 2, vsync: this);
    if (tabController.index == 0) {
      _catEditorialContr.getTask(1, int.parse(widget.catid));
    }
    tabController.addListener(() {
      if (tabController.index == 1) {
        _pdfController.pdfListController(type: widget.type, id: widget.catid);
      }
    });
  }

  List<String> color = [
    "#DBDDFF",
    "#FFDDDD",
    "#F5E8FF",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _allContentsKey,
      //backgroundColor: bgPurpleColor,
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDmSans(
            text: widget.title,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            buildTabWidget(),
            const SizedBox(
              height: 6,
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [
                CategoryEditorialListPage(Title: widget.title),
                GetX<PdfController>(
                    init: PdfController(),
                    builder: (_) {
                      if (_.loading.value == false) {
                        return _.pdfList.value.pdfs == null
                            ? Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Lottie.asset(
                                    "assets/animations/49993-search.json",
                                    height: MediaQuery.of(context).size.height *
                                        0.2),
                              )
                            : pdfListWidgetTab(_.pdfList.value.pdfs!);
                      } else {
                        return Center(
                          child: Lottie.asset(
                            "assets/animations/loader.json",
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                        );
                      }
                    }),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget pdfListWidgetTab(List<Pdfs> pdff) {
    // Sort the list of items by date
    pdff.sort((a, b) => b.publishAt!.compareTo(a.publishAt!));
    return ListView(
      // reverse: true,
      children: List.generate(pdff.length, (index) {
        return InkWell(
          onTap: () {
            if (widget.type == "1") {
              if (_subcontroller.profileGet.value.user!.isSubscription == "Y") {
                Get.to(() => PdfViewer(
                      link: pdff[index].file!,
                      title: pdff[index].title!,
                    ));
              } else {
                _subcontroller.profileDataFetch();
                if (Platform.isAndroid) {
                  Get.to(() => const ChoosePlanDetails());
                } else {
                  Get.to(() => InAppPlanDetail());
                }
              }
            } else {
              Get.to(() => PdfViewer(
                    link: pdff[index].file!,
                    title: pdff[index].title!,
                  ));
            }
          },
          child: Container(
            margin:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).mode.isDark
                  ? Colors.black
                  : Color(hexStringToHexInt(color[index % 3])),
              /*boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.grey.shade400,
                    offset: const Offset(0, 5))
              ],*/
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset("assets/icon/clock_timer.svg"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SemiBoldTextView(
                          text: pdff[index].title.toString(),
                          color: blackColor,
                          weight: FontWeight.w600,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pdff[index].publishAt!.substring(0, 10),
                                style: GoogleFonts.dmSans(color: darkGreyColor),
                              ),
                              CircleAvatar(
                                backgroundColor: greyColor,
                                maxRadius: 2,
                              ),
                              Text(
                                widget.type == "1" ? "PAID" : "FREE",
                                style: GoogleFonts.dmSans(color: purpleColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                downloadStarted == index
                    ? Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: blackColor,
                        ),
                      )
                    : Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () async {
                            if (widget.type == "1") {
                              if (_subcontroller
                                      .profileGet.value.user!.isSubscription ==
                                  "Y") {
                                _download(pdff[index].file, index);
                              } else {
                                _subcontroller.profileDataFetch();
                                if (Platform.isAndroid) {
                                  Get.to(() => const ChoosePlanDetails());
                                } else {
                                  Get.to(() => InAppPlanDetail());
                                }
                              }
                            } else {
                              _download(pdff[index].file, index);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icon/downloadicon.svg",
                              ),
                              CustomDmSans(text: "PDF")
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildTabWidget() {
    print("gffgf${authController.darkTheme == true}");
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
          //unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,
          controller: tabController,
          labelColor: Colors.black,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Reading",
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("PDF", style: GoogleFonts.roboto(fontSize: 12)),
                ),
              ),
            ),
          ]),
    );
  }
}
