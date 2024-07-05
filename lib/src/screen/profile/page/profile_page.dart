import 'dart:io';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool edit = false;
  final ProfileControllers _profileControllers = Get.find();
  final AuthenticationManager _authenticationController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var dropdownvalueCity;
  var dropdownvalueState;
  bool state = false;
  bool city = false;
  bool isLoading = false;
  bool loader = false;
  final ImagePicker _picker = ImagePicker();
  XFile pickedFileProfile = XFile("");
  String imageUrl = "";
  String Path = "";
  String path = "";

  FetchUserData() {
    setState(() {
      userName.text =
          _profileControllers.profileGet.value.user!.name.toString();
      phone.text = _profileControllers.profileGet.value.user!.phone.toString();
      email.text = _profileControllers.profileGet.value.user!.email.toString();
      dob.text =
          _profileControllers.profileGet.value.user!.dateOfBirth.toString();
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    _profileControllers.refreshList();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  DateTime? dateTime;
  TextEditingController userName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController dob = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    FetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        //backgroundColor: whiteColor,
        title: ToolbarTitle(
          title: "Edit Profile",
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                edit = !edit;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding:
                  const EdgeInsets.only(left: 14, right: 12, top: 7, bottom: 0),
              decoration: BoxDecoration(
                color: edit == true ? greyColor : greenColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomDmSans(
                text: edit == true ? "Cancel" : "Edit",
                color: whiteColor,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Obx(() {
            if (_profileControllers.loading.value) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/loader.json",
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          edit == true ? bottomSheetSelector() : null;
                        },
                        child: SizedBox(
                            width: Get.width * 0.28,
                            height: Get.height * 0.14,
                            child: Stack(
                              fit: StackFit.expand,
                              // overflow: Overflow.visible,
                              children: [
                                loader == true
                                    ? const CircularProgressIndicator()
                                    : Path == ""
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _profileControllers.profileGet
                                                    .value.user!.image
                                                    .toString()),
                                          )
                                        : CircleAvatar(
                                            backgroundImage: FileImage(
                                                File(pickedFileProfile.path)),
                                          ),
                                edit == true
                                    ? Positioned(
                                        bottom: 18,
                                        right: 0,
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              bottomSheetSelector();
                                            },
                                            child: const Icon(Icons.camera_alt,
                                                size: 15, color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : const Text("")
                              ],
                            )),
                      ),
                    ),

                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Column(
                            children: [
                              CustomDmSans(
                                text: _profileControllers
                                    .profileGet.value.user!.name
                                    .toString(),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              _profileControllers
                                          .profileGet.value.user!.email !=
                                      null
                                  ? CustomDmSans(
                                      text: (_profileControllers
                                              .profileGet.value.user!.email)
                                          .toString(),
                                      fontSize: 16,
                                    )
                                  : const Text(""),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          // color: redColor,
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/img/profile_shape.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      enabled: edit,
                      readOnly: !edit,
                      controller: userName,
                      //style: GoogleFonts.roboto(color: blackColor),
                      decoration: InputDecoration(
                          labelText: "Username",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: Colors.grey.shade400, fontSize: 13)),
                    ),
                    TextFormField(
                      enabled: false,
                      readOnly: true,
                      controller: phone,
                      //style: GoogleFonts.roboto(color: blackColor),
                      decoration: InputDecoration(
                          prefixText: "+91  ",
                          /*prefixStyle:
                              GoogleFonts.dmSans(color: blackColor, fontSize: 16),*/
                          labelText: "Phone Number",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: Colors.grey.shade400, fontSize: 13)),
                    ),
                    TextFormField(
                      enabled: edit,
                      readOnly: !edit,
                      controller: email,
                      //style: GoogleFonts.roboto(color: blackColor),
                      decoration: InputDecoration(
                          labelText: "Enter Email Address ",
                          enabled: false,
                          border: InputBorder.none,
                          labelStyle: GoogleFonts.roboto(
                              color: Colors.grey.shade400, fontSize: 13)),
                    ),
                    const Divider(),
                    _profileControllers.profileGet.value.user!.isSubscription !=
                            "N"
                        ? subsDetails()
                        : const Text(""),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        try {
                          _profileControllers.updateProfile(
                            name: userName.text.trim(),
                            city: dropdownvalueCity.toString() != "null"
                                ? dropdownvalueCity
                                : _profileControllers
                                    .profileGet.value.user!.cityId
                                    .toString(),
                            state: dropdownvalueState.toString() != "null"
                                ? dropdownvalueState
                                : _profileControllers
                                    .profileGet.value.user!.stateId
                                    .toString(),
                            image: Path == "" ? null : Path,
                            birthDay: "",
                            email: email.text == ""
                                ? _profileControllers
                                    .profileGet.value.user!.email
                                : email.text,
                            userName: userName.text.trim(),
                          );
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                        setState(() {
                          edit = false;
                          state = false;
                          city = false;
                        });
                      },
                      child: Visibility(
                        visible: edit,
                        child: Center(
                          child: Container(
                            // margin: const EdgeInsets.only(bottom: 40, top: 20),
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: purplegrColor, width: 2),
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
                              'Update',
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
                      ),
                    ),
                    // :Text(""),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  void getImage1(source, String key) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        loader = true;
      });
    }

    final dir = await path_provider.getTemporaryDirectory();

    final targetPath = dir.absolute.path + "/temp.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile!.path,
      targetPath,
      quality: 88,
      rotate: 0,
    );

    setState(() {
      pickedFileProfile = pickedFile;
      Path = result!.path;
      loader = false;
    });
  }

  bottomSheetSelector() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100.0,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const Text(
                  "Choose photo",
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.camera, color: purplegrColor),
                      onPressed: () {
                        getImage1(ImageSource.camera, "photo");
                        Navigator.pop(context);
                      },
                      label: const Text(
                        "Camera",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.image, color: purplegrColor),
                      onPressed: () {
                        getImage1(ImageSource.gallery, "photo");
                        Navigator.pop(context);
                      },
                      label: const Text(
                        "Gallery",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget subsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          "Material Purchase Detail",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Text(
            "Start From : ${_profileControllers.profileGet.value.user!.subscriptionDetails!.startDate!} ",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Text(
            "End On : ${_profileControllers.profileGet.value.user!.subscriptionDetails!.endDate!} ",
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Validity ${_profileControllers.profileGet.value.user!.subscriptionDetails!.planDuration!} Months",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
              ),
              Text(
                "₹ ${_profileControllers.profileGet.value.user!.subscriptionDetails!.fee!}",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          "${_profileControllers.profileGet.value.user!.subscriptionDetails!.daysLeft}Days left",
          style: GoogleFonts.roboto(
              color: greenColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Future _pickImage() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _imageFile = pickedimage != null ? File(pickedimage.path) : null;
    if (_imageFile != null) {
      setState(() {
        _imageFile = File(pickedimage!.path);
      });
    }
  }
}
