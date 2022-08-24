import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/controllers/choose_plan_detail_controller/choose_plan_detail_contr.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/screen/bottom_nav/bottom_nav.dart';
import 'package:english_madhyam/src/screen/choose_plan/all_coupon_list.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:english_madhyam/src/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../helper/controllers/payment_controller/payment.dart';

class ChoosePlanDetails extends StatefulWidget {
  const ChoosePlanDetails({Key? key}) : super(key: key);

  @override
  State<ChoosePlanDetails> createState() => _ChoosePlanDetailsState();
}

class _ChoosePlanDetailsState extends State<ChoosePlanDetails> {
  final PlanDetailsController _controller =
      Get.put<PlanDetailsController>(PlanDetailsController());
  final PaymentController _paymentController = Get.put(PaymentController());
  final ProfileControllers _profileControllers = Get.put(ProfileControllers());
  late Razorpay _razorpay;
  String _razorPayTxnId = "";
  int _selectedPlan = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: Payment not completed", timeInSecForIosWeb: 10);

    cancel();
    _profileControllers.profileDataFetch();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        timeInSecForIosWeb: 10);
    cancel();
    setState(() {
      _profileControllers.profileDataFetch();
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _razorPayTxnId = response.paymentId!;
    });

    _paymentController.checkPaymentContr(
        pay: response.paymentId!,
        amount:
            _controller.planDetails.value.list![_selectedPlan].fee!.toString(),
        PlanID:
            _controller.planDetails.value.list![_selectedPlan].id.toString(),
        CouponCode: _paymentController.couponCode.value);
    setState(() {
      _profileControllers.profileDataFetch();
    });
    Fluttertoast.showToast(msg: "You have Successfully purchased Subscription");
    cancel();
    // Get.off(()=>const PurchaseHistoryScreen());

    Get.offUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const BottomWidget()),
        (route) => true); //placeOrderApi();
  }

  void openCheckout(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    // rzp_test_4Q31IbUFwyd9ie test key
    // rzp_live_YJ3XTbIRf8bjeQ  it is live key

    var options = {
      'key': "rzp_live_YJ3XTbIRf8bjeQ",
      'amount': (amount.toInt()) * 100,
      'image': "https://razorpay.com/assets/razorpay-glyph.svg",
      'currency': 'INR',
      "theme": {"color": "#0033FD", "backdrop_color": "#FFBE00"},
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "display": {
        "widget": {
          "main": {
            "heading": {"color": "#FFBE00", "fontSize": "12px"}
          }
        }
      },
      'name': prefs.get("name"),
      'description': "English Madhyam",
      'prefill': {
        'contact': prefs.getString("phone"),
        'email': prefs.get("email")
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            color: blackColor,
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Text(
            "Choose Your Plan",
            style: GoogleFonts.lato(
                color: blackColor, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<PlanDetailsController>(builder: (_) {
              if (_controller.loading.isFalse) {
                if (_controller.planDetails.value.result == false) {
                  return Center(
                    child: Lottie.asset('assets/animations/49993-search.json',
                        height: MediaQuery.of(context).size.height * 0.2),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _.planDetails.value.list!.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Container(
                          // height: MediaQuery.of(context).size.height * 0.22,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xff5853F5), width: 2),
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff5853F5),
                                    Color(0xff7581F5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0, 2])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _controller.planDetails.value.list![index]
                                            .duration
                                            .toString() +
                                        " Months",
                                    style: GoogleFonts.roboto(
                                        color: whiteColor, fontSize: 15),
                                  ),
                                  Transform.scale(
                                    scale: 1.8,
                                    child: Radio(
                                        splashRadius: 1.0,
                                        value: index,
                                        groupValue: _.groupValue.value,
                                        onChanged: (value) {
                                          _paymentController.couponCode.value =
                                              "";
                                          _.onClickRadioButton(value);
                                          setState(() {
                                            _selectedPlan = index;
                                          });
                                        },
                                        activeColor: whiteColor,
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return whiteColor;
                                          }
                                          return greyColor;
                                        })),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "\u{20B9} " +
                                        _controller
                                            .planDetails.value.list![index].fee
                                            .toString(),
                                    style: GoogleFonts.roboto(
                                        color: whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  _controller.planDetails.value.list![index]
                                              .mrp !=
                                          _controller.planDetails.value
                                              .list![index].fee!
                                      ? Text(
                                          "\u{20B9} " +
                                              _controller.planDetails.value
                                                  .list![index].mrp
                                                  .toString(),
                                          style: GoogleFonts.roboto(
                                              color: examGreyColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _controller.planDetails.value.list![index]
                                          .discount !=
                                      0
                                  ? DottedBorder(
                                      borderType: BorderType.RRect,
                                      dashPattern: const [3, 3],
                                      color: whiteColor,
                                      strokeWidth: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0,
                                            bottom: 3,
                                            left: 10,
                                            right: 10),
                                        child: Text(
                                          _controller.planDetails.value
                                                  .list![index].discount
                                                  .toString() +
                                              "%" +
                                              " OFF",
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: whiteColor),
                                        ),
                                      ))
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Limited time Offer ",
                                    style: GoogleFonts.roboto(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    _controller.planDetails.value.list![index]
                                                .perDay!
                                                .toString()
                                                .length >
                                            5
                                        ? "(${_controller.planDetails.value.list![index].perDay!.toString().substring(0, 5)})" +
                                            " per day"
                                        : _controller.planDetails.value
                                                .list![index].perDay!
                                                .toString() +
                                            "per day",
                                    style: GoogleFonts.roboto(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
              } else {
                return Center(
                  child: Lottie.asset("assets/animations/loader.json"),
                );
              }
            }),

            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(2),
            //     border:Border.all(
            //       color: purpleColor
            //     )
            //   ),
            //   child: Row(
            //     children: [
            //       CustomDmSans(text: "20% Off"),
            //       // Image.asset("assets/img/couponcode")
            //     ],
            //   ),
            // ),
            InkWell(
              onTap: () {
                _paymentController.CouponListContr();
                Get.to(() => UseCoupons(
                      planId: _controller
                          .planDetails.value.list![_selectedPlan].id
                          .toString(),
                    ));
              },
              child: Container(
                color: purpleColor.withOpacity(0.09),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/coupon.svg",
                          height: 40,
                        ),
                        CustomDmSans(
                          text: "Use coupons",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_right_outlined)
                  ],
                ),
              ),
            ),

            Obx(() {
              return Column(
                children: [
                  _paymentController.couponCode.value == ""
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(2),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: greenColor)),
                          child: CustomDmSans(
                            text: "Applied Coupon : " +
                                _paymentController.couponCode.value.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  _paymentController.couponCode.value == ""
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomDmSans(text: "You Saved:"),
                                      CustomDmSans(
                                          text: "\u{20B9}" +
                                              (_paymentController
                                                          .applyCoupon
                                                          .value
                                                          .couponDetails!
                                                          .discount
                                                          .toString()
                                                          .length >
                                                      5
                                                  ? _paymentController
                                                      .applyCoupon
                                                      .value
                                                      .couponDetails!
                                                      .discount
                                                      .toString()
                                                      .substring(0, 5)
                                                  : _paymentController
                                                      .applyCoupon
                                                      .value
                                                      .couponDetails!
                                                      .discount
                                                      .toString()))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomDmSans(text: "Final Amount:"),
                                      CustomDmSans(
                                          text: "\u{20B9}" +
                                              _paymentController
                                                  .applyCoupon
                                                  .value
                                                  .couponDetails!
                                                  .finalAmount
                                                  .toString())
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              );
            }),

            Center(
                child: Image.asset(
              "assets/img/ribbon.png",
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
            )),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10),
              child: Row(
                children: [
                  Image.asset("assets/img/unlocked.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomRoboto(
                    text: "Unlock Daily Prime Updates",
                    fontSize: 14,
                    color: const Color(0xff676767),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10),
              child: Row(
                children: [
                  Image.asset("assets/img/touch.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomRoboto(
                    text: "Unlimited Tapping for Meaning",
                    fontSize: 14,
                    color: const Color(0xff676767),
                  )
                ],
              ),
            ),
            Obx(() {
              return InkWell(
                onTap: () {
                  print(_paymentController.couponCode.value);
                  if (_paymentController.couponCode.value != "") {
                    openCheckout((double.parse(_paymentController.applyCoupon.value.couponDetails!.finalAmount
                        .toString())));
                  } else {
                    openCheckout((double.parse(_controller
                        .planDetails.value.list![_selectedPlan].fee!
                        .toString())));
                  }
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
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
                    child: _paymentController.loading.value == false
                        ? Text(
                            'JOIN NOW',
                            style: GoogleFonts.roboto(
                                color: whiteColor,
                                decoration: TextDecoration.none,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1.0, 4),
                                    blurRadius: 3.0,
                                    color: greyColor.withOpacity(0.5),
                                  ),
                                ]),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(
                              child:
                                  Lottie.asset("assets/animations/loader.json"),
                            ),
                          ),
                  ),
                ),
              );
            })
          ],
        )));
  }
}
