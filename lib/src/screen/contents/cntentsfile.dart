import 'dart:io';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/helper/controllers/pdf_list_control.dart';
import 'package:english_madhyam/src/screen/choose_plan/editorial_category_list.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:english_madhyam/src/utils/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';


class AllContents extends StatefulWidget {
  final String catid;
  final String title;
  final String type;
  const AllContents({Key? key,required this.catid,required this.type,required this.title}) : super(key: key);

  @override
  _AllContentsState createState() => _AllContentsState();
}

class _AllContentsState extends State<AllContents> with TickerProviderStateMixin{
  final PdfController _pdfController=Get.put(PdfController());
  final EditorialDetailController _catEditorialContr=Get.find();
  late String _localPath;


  late TabController tabController;
  late bool _permissionReady;
  String TaskID="";

  //local PAth
  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath =    (await getApplicationDocumentsDirectory()).absolute.path;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {

    }
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
_catEditorialContr.editorialByCat.clear();
_catEditorialContr.categoryId(int.parse(widget.catid));

    tabController = TabController(length: 2, vsync: this) ;
    if(tabController.index==0)
    {
      _catEditorialContr.getTask(1,int.parse(widget.catid));

    }
    tabController.addListener(() {
      if(tabController.index==1)
        {
          _pdfController.pdf_listController(type: widget.type,id:widget.catid );


        }

    });


    _permissionReady = false;
    FlutterDownloader.registerCallback(downloadCallback);

    if (_permissionReady) {
      _prepareSaveDir();
    }
  }
  Future<bool> _checkPermission() async {
    if (Platform.isIOS) return true;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid&&
        androidInfo.version.sdkInt <= 28) {
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

  void _requestDownload(_TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {"auth": "test_for_sql_encoding"},
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
      saveInPublicStorage: true,

    );
    if(task.taskId!=null){
      Fluttertoast.showToast(msg: "Downloading Start");
    }
    setState(() {
      TaskID=task.taskId!;
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
  List<String> color = [
    "#DBDDFF",
    "#FFDDDD",
    "#F5E8FF",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPurpleColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: false,leading: BackButton(color: blackColor,),
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
            tabstile(),
            Expanded(child: TabBarView(children: [
              CategoryEditorial(Title:widget.title),
              GetX<PdfController>(
                  init: PdfController(),
                  builder: (_) {

                    if(_.loading.value==false){

                      return _
                          .pdfList.value.pdfs==null
                          ? Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Lottie.asset(
                            "assets/animations/49993-search.json",
                            height: MediaQuery.of(context).size.height * 0.2),
                      ):
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(

                            itemCount: _.pdfList.value.pdfs!.length,

                            itemBuilder: (BuildContext ctx, int index) {
                              return InkWell(
                                onTap: () {
                                  Get.to(()=>PdfViewer(link: _.pdfList.value.pdfs![index].file!,title: _.pdfList.value.pdfs![index].title!,));



                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15, bottom: 0),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(hexStringToHexInt(color[index % 3])),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.grey.shade400,
                                          offset: const Offset(0, 5))
                                    ],
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
                                              CustomDmSans(
                                                text: _.pdfList.value.pdfs![index].title.toString(),
                                                color: blackColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(right: 20.0, top: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(_.pdfList.value.pdfs![index].publishAt!.substring(0,10),
                                                      style: GoogleFonts.dmSans(
                                                          color: darkGreyColor),
                                                    ),
                                                    CircleAvatar(
                                                      backgroundColor: greyColor,
                                                      maxRadius: 2,
                                                    ),
                                                    Text(
                                                      "FREE",
                                                      style: GoogleFonts.dmSans(
                                                          color: purpleColor),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () async {
                                            _permissionReady?
                                            _requestDownload(_TaskInfo(name: _.pdfList.value.pdfs![index].title,link: _.pdfList.value.pdfs![index].file)):_retryRequestPermission();
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
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }else{
                      return Center(
                        child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.2,),
                      );
                    }
                  }
              ),


            ],controller: tabController,))
          ],
        ),
      ),
    );
  }
  Widget tabstile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
          unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,

          controller: tabController,
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
                  child: Text("Reading  ",
                      style: GoogleFonts.roboto(fontSize: 12)),
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
                  child: Text(
                    "PDF ",
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

}
class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}// _pdfController.pdf_listController(type: "1");
