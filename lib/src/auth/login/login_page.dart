import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/auth/otp/otp_page.dart';
import 'package:english_madhyam/src/auth/social%20login.dart';
import 'package:english_madhyam/src/utils/Terms&co.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../network/NetworkException.dart';
import 'package:lottie/lottie.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController number = TextEditingController();
bool loader=false;
  final HttpService _httpService=HttpService();
  String? validateMobile(String value) {
    String pattern = r'(^([9876]{1})([0-9]{9})$)';
    RegExp regExp =  RegExp(pattern);
    if (value.length == 0) {
      return 'Please Enter Mobile Number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String? validateAuthId(String value) {
    if (value.length == 0) {
      return 'We couldn\'t authenticate you';
    }
    return null;
  }
  GoogleSignIn _googleSignIn = GoogleSignIn(

    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  GoogleSignInAccount? _currentUser;
  String _contactText = '';
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<User?> signInWithGoogle(SignInViewModel model) async {
  //   model.state =ViewState.Busy;
  //   GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleSignInAuthentication =
  //   await googleSignInAccount!.authentication;
  //   AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //   AuthResult authResult = await _auth.signInWithCredential(credential);
  //   _user = authResult.user;
  //   assert(!_user.isAnonymous);
  //   assert(await _user.getIdToken() != null);
  //  User currentUser = await _auth.currentUser!;
  //   assert(_user.uid == currentUser.uid);
  //   model.state =ViewState.Idle;
  //   // print("User Name: ${_user.displayName}");
  //   // print("User Email ${_user.email}");
  // }

  Future<void> sendOtp({required String mobile}) async {
    String? validate = validateMobile(mobile);
    if (validate != null) {
      Fluttertoast.showToast(msg: "Invalid Mobile Number");
      cancel();

    }else{
      setState(() {
        loader=true;
      });
      try {
        Map requestBody = {
          "phone": mobile,
        };
        var response = await _httpService.getSendOtp(requestBody);
        if (response?.result == 'success') {
          setState(() {
            loader=false;
          });
          Get.to(() => OtpPage(
            mobile: mobile,
          ));
          return;
        }
      } on NetworkException {
        Fluttertoast.showToast(
            msg: "Please check your internet connection and retry");
        cancel();

      }
    }

  }
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.07),

                CustomRoboto(
                  text: "Get Better Every Day, Practice",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                CustomRoboto(
                  text: "Test Series and Free Daily Quizzes",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: purpleColor,
                ),
                Image.asset(
                  "assets/img/two_child.png",
                  height: size.height * 0.35,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    enabled: true,
                    controller: number,
                    maxLength: 10,
                    keyboardType: const TextInputType.numberWithOptions(signed: false),
                    style: GoogleFonts.roboto(fontSize: 16, letterSpacing: 1.0),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomRoboto(text: "+91"),
                            Container(
                              height: 25,
                              width: 1,
                              color: blackColor,
                            ),
                            const SizedBox(
                              width: 4,
                            )
                          ],
                        ),
                        prefixStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          color: blackColor,
                        ),
                        hintText: "Enter your mobile number ",
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          color: greyColor,
                        )),
                  ),
                ),
                SizedBox(height: size.height * 0.06),
                Center(
                  child: InkWell(
                    onTap: () {
                      sendOtp(mobile: number.text.trim());
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: greyColor,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(1, 2))
                        ],
                        gradient: RadialGradient(
                          center: const Alignment(0.0, 0.2),
                          colors: [purpleColor.withOpacity(0.7), purplegrColor.withOpacity(0.8)],
                          radius: 1.0,
                        ),
                      ),
                      child: loader==false?Text(
                        'Continue',
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
                      ):Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.04,),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.1),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SvgPicture.asset(
                //       "assets/icon/fb.svg",
                //       height: 35,
                //     ),
                //     const SizedBox(width: 30),
                //     InkWell(
                //       onTap: (){
                //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInDemo()), (route) => false);
                //       },
                //       child: Image.asset(
                //         "assets/img/google.png",
                //         scale: 1.8,
                //       ),
                //     )
                //   ],
                // ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRoboto(
                      text: "By signing up you agree to our ",
                      fontSize: 12,
                      color: greyColor,
                    ),
                    InkWell(
                      onTap: (){
     Get.to(()=>TermsCond());
                      },
                      child: CustomRoboto(
                        text: "Terms and Condition ",
                        fontSize: 12,
                        color: blackColor,
                        linethrough: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
