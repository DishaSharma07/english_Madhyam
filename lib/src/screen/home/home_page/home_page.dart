import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/controllers/home_controllers/home_controller.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/helper/controllers/quiz_list_controller/quiz_list.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/screen/Notification_screen/Notifications.dart';
import 'package:english_madhyam/src/screen/editorials_page/editorials_page.dart';
import 'package:english_madhyam/src/screen/home/achievers.dart';
import 'package:english_madhyam/src/screen/home/daily_quiz.dart';
import 'package:english_madhyam/src/screen/home/drawer_screen.dart';
import 'package:english_madhyam/src/screen/home/editorials.dart';
import 'package:english_madhyam/src/screen/home/refer_and_earn.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../helper/controllers/Notification_contr/notification_contr.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  PageController bottomcontroller;

  HomePage({Key? key, required this.bottomcontroller}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  final HttpService _httpService = HttpService();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  late String userImage;
  String _connectionStatus = 'Unknown';
  String deviceTokenn = "";

  final NetworkInfo _networkInfo = NetworkInfo();

  GlobalKey<NavigatorState>? NavigationKey;
  final HomeController homeController = Get.put(HomeController());
  final QuizListController _quizListController = Get.find();
  final ProfileControllers _profile = Get.put(ProfileControllers());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CarouselController _sliderController = CarouselController();
  final NotifcationController _notifcationController = Get.find();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _current = 0;

  void _onRefresh() async {
    // monitor network fetch
    homeController.homeApiFetch();
    _notifcationController.getNotification();

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  /// to get app version
  ///
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  deviceToken() async {
    FirebaseMessaging messaging;
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");

    await messaging.getToken().then((value) {
      if (value != null) {
        // setToken(value);
        setState(() {
          deviceTokenn = value;
        });
      } else {
        messaging.onTokenRefresh.listen((event) {
          setState(() {
            deviceTokenn = event;
          });
        });
      }
    });
    return deviceTokenn;
  }

  ///finding device type
  Future<void> initPlatformState(String ip) async {
    var deviceData = <String, dynamic>{};
    deviceToken();
    try {
      if (kIsWeb) {
        // deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo)!;
          print(ip);
          debugPrint(
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo)
                  .toString(),
              wrapWidth: 2200);
          _httpService.device_info(
              device_token: deviceTokenn,
              device_name: deviceData['model'],
              device_type: "Android",
              ip_address: ip,
              os_version: deviceData['version.release']);
          homeController.mandatoryUpdateContr(
            int.parse(_packageInfo.buildNumber),
            "Android",
            context,
          );
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

  ///Getting Device Info
  Map<String, dynamic>? _readAndroidBuildData(AndroidDeviceInfo build) {
    try {
      return <String, dynamic>{
        'version.securityPatch': build.version.securityPatch,
        'version.sdkInt': build.version.sdkInt,
        'version.release': build.version.release,
        'version.previewSdkInt': build.version.previewSdkInt,
        'version.incremental': build.version.incremental,
        'version.codename': build.version.codename,
        'version.baseOS': build.version.baseOS,
        'board': build.board,
        'bootloader': build.bootloader,
        'brand': build.brand,
        'device': build.device,
        'display': build.display,
        'fingerprint': build.fingerprint,
        'hardware': build.hardware,
        'host': build.host,
        'id': build.id,
        'manufacturer': build.manufacturer,
        'model': build.model,
        'product': build.product,
        'supported32BitAbis': build.supported32BitAbis,
        'supported64BitAbis': build.supported64BitAbis,
        'supportedAbis': build.supportedAbis,
        'tags': build.tags,
        'type': build.type,
        'isPhysicalDevice': build.isPhysicalDevice,
        'androidId': build.androidId,
        'systemFeatures': build.systemFeatures,
      };
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to get Platform version" + e.toString());
      cancel();
    }
  }

  ///Getting Ip address
  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      print('Failed to get Wifi Name $e');
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      print('Failed to get Wifi BSSID $e');
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
      initPlatformState(wifiIPv4!);
    } on PlatformException catch (e) {
      print('Failed to get Wifi IPv4 $e');
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      wifiIPv6 = await _networkInfo.getWifiIPv6();
      initPlatformState(wifiIPv6!);
    } on PlatformException catch (e) {
      print('Failed to get Wifi IPv6 $e');
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      wifiBroadcast = await _networkInfo.getWifiBroadcast();
    } on PlatformException catch (e) {
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
    } on PlatformException catch (e) {
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    try {
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      wifiSubmask = 'Failed to get Wifi submask';
    }

    setState(() {
      _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';
    });
  }

  ///Getting user Details for birthday pop
  userDetails() async {
    homeController.homeApiFetch();

    final _prefs = await SharedPreferences.getInstance();

    _prefs.getBool("Birthday") == true && _prefs.getBool("Showed") != true
        ? _openSubmitDialog()
        : null;
  }

  @override
  void initState() {
    // TODO: implement initState
    // InternetChecker(ctx: context);
    print("initstate");

    super.initState();
    userDetails();

    DateTime now = DateTime.now();
    int hours = now.hour;

    greetings(hours);
    _initPackageInfo();

    _initNetworkInfo();
    homeController.warningPopContr(context);
    homeController.SecWarningPopContr(context);
  }

  String greeting = "";

  String greetings(int hours) {
    if (hours >= 1 && hours <= 12) {
      setState(() {
        greeting = "Good Morning";
      });
    } else if (hours >= 12 && hours <= 16) {
      setState(() {
        greeting = "Good Afternoon";
      });
    } else if (hours >= 16 && hours <= 21) {
      setState(() {
        greeting = "Good Evening";
      });
    } else if (hours >= 21 && hours <= 24) {
      setState(() {
        greeting = "Good Night";
      });
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: whiteColor,
        drawer: const HomeDrawer(),
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0.0,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (_profile.profileGet.value.user!.name != null) {
                  return CustomRoboto(
                    text: "Hi ," + _profile.profileGet.value.user!.name!,
                    color: darkGreyColor,
                    fontSize: 14,
                  );
                } else {
                  return CustomRoboto(
                    text: "Hi User",
                    color: darkGreyColor,
                    fontSize: 14,
                  );
                }
              }),
              CustomRoboto(
                text: greeting,
                color: darkGreyColor,
                fontSize: 14,
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/icon/menu.svg",
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => NotificationScreen());
                // Get.to(() => AudioAnimation());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 20),
                child: Stack(
                  children: [
                    SvgPicture.asset("assets/icon/bell.svg"),
                    Positioned(
                      // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: _notifcationController.unread_notification > 0
                          ? const Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent)
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(child: Obx(() {
            if (homeController.loading.value) {
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
              // homeController.update();
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/img/bg.png",
                        ),
                        fit: BoxFit.fitWidth)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    homeController.banner.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: slider()),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 10),
                      child: Text(
                        "Recent Posts",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: blackColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        EditorialsList(
                          type: 0,
                          editorials: homeController.courses,
                          cont: widget.bottomcontroller,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => EditorialsPage());
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 10, bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: purpleColor,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              "See all",
                              style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: purpleColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, bottom: 15, top: 20),
                      child: Text(
                        "Daily Quiz >",
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: blackColor),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.16,
                                child: DailyQuiz(
                                  quiz: homeController.quizs,
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _quizListController
                                        .selectedPageIndex.value = 2;
                                    _quizListController.pageC.value
                                        .animateToPage(2,
                                            duration: Duration(milliseconds: 2),
                                            curve: Curves.easeOutBack);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 35, right: 35, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: purpleColor,
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    "See all",
                                    style: GoogleFonts.lato(
                                        fontSize: 16, color: purpleColor),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                      child: Achieverstake(achievers: homeController.achievers),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                      child: InkWell(
                          onTap: () {
                            onShare(context);
                          },
                          child: const RefferEarn()),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: purpleColor.withOpacity(0.13),
                      child: bottom(),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              );
            }
          })),
        ));
  }

  Widget slider() {
    final List<Widget> imageSliders = homeController.banner
        .map((item) => Container(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  child: Image.network(item.banner.toString(),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width)),
            ))
        .toList();

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _sliderController,
          options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 0.9,
              autoPlay: true,
              aspectRatio: 1.9,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: homeController.banner.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () {
              _sliderController.animateToPage(
                entry.key,
              );
            },
            child: Container(
              width: 6.0,
              height: 6.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradientBlue
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
        "Share English Madhyam App with your friends ,${"https://play.google.com/store/search?q=english%20madhyam&c=apps"}",
        subject: "Share English Madhyam App",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  Widget bottom() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                homeController.students + " +",
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Students",
                style: GoogleFonts.montserrat(
                  color: blackColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (homeController.succesRate).toString(),
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Success Rate",
                style: GoogleFonts.montserrat(
                  color: blackColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${homeController.Mentors} +",
                style: GoogleFonts.montserrat(
                  color: purplegrColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Mentors",
                style: GoogleFonts.montserrat(
                  color: blackColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _openSubmitDialog() async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/img/birthImg.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "May God Bless you with health, wealth and prosperity in your life",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ]),
            ));
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("Showed", true);
  }
}
