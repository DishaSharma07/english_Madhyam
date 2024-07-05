import 'package:english_madhyam/resrc/models/model/plan_detail/plan_detial.dart';
import 'package:english_madhyam/resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/payment/page/all_coupon_list.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:english_madhyam/src/screen/pages/page/setup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../material/controller/materialController.dart';
import '../controller/paymentController.dart';


class ChoosePlanDetails extends StatefulWidget {
  const ChoosePlanDetails({Key? key}) : super(key: key);

  @override
  State<ChoosePlanDetails> createState() => _ChoosePlanDetailsState();
}

class _ChoosePlanDetailsState extends State<ChoosePlanDetails> {
  final AuthenticationManager authController = Get.find();
  final MaterialController _controller =
      Get.put<MaterialController>(MaterialController());
  final PaymentController _paymentController = Get.put(PaymentController());
  final ProfileControllers _profileControllers = Get.put(ProfileControllers());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Razorpay _razorpay;
  String _razorPayTxnId = "";
  int _selectedPlan = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      _controller.onClickRadioButton(0);
      _controller.getPlanDetails();


    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _selectedPlan = 0;
    _paymentController.couponCode.value = "";
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    UiHelper.showSnakbarMsg(context, "ERROR: Payment not completed");
    await _profileControllers.profileDataFetch();
    Get.back();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        timeInSecForIosWeb: 10);
    cancel();
    setState(() {
      _profileControllers.profileDataFetch();
    });
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _razorPayTxnId = response.paymentId!;
    });
    _paymentController.confirmPayment(
        pay: response.paymentId!,
        amount: _paymentController.couponCode.value == ""
            ? _controller.planDetails.value.list![_selectedPlan].fee!.toString()
            : _paymentController.applyCoupon.value.couponDetails!.finalAmount
                .toString(),
        PlanID:
            _controller.planDetails.value.list![_selectedPlan].id.toString(),
        paymentMethod: "razorpay");
    await _profileControllers.profileDataFetch();
    UiHelper.showSnakbarSucess(
        context, "You have Successfully purchased Subscription");
    Get.back();
    /*Get.offUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const BottomWidget()),
        (route) => true); //placeOrderApi();*/
  }

  void openCheckout(double amount) async {
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
      'name': authController.getName(),
      'description': "English Madhyam",
      'prefill': {
        'contact': authController.getMobile(),
        'email': authController.getEmail()
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  void _onRefresh() async {
    // monitor network fetch
    setState(() {
      _selectedPlan = 0;
      _controller.onClickRadioButton(0);
      _paymentController.couponCode.value = "";
    });
    _controller.getPlanDetails();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0.0,
          //backgroundColor: Colors.white,
          centerTitle: true,
          title: const ToolbarTitle(
           title: 'Choose Your Plan',
          ),
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/img/ribbon.png",
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.cover,
              ),),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                child: Row(
                  children: [
                    Image.asset("assets/img/unlocked.png"),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomRoboto(
                      text: "Access to all paid content",
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
                if (!_controller.isLoading.value) {
                  if (_controller.planDetails.value.result == false) {
                    return Center(
                      child: Lottie.asset('assets/animations/49993-search.json',
                          height: MediaQuery.of(context).size.height * 0.2),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.planDetails.value.list!.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          PlanList planData =
                              _controller.planDetails.value.list![index];
                          return planListRow1(planData, index);
                        });
                  }
                } else {
                  return Center(
                    child: Lottie.asset("assets/animations/loader.json"),
                  );
                }
              }),
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
                  decoration: BoxDecoration(
                      color: purpleColor.withOpacity(0.09),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),

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
                            fontSize: 16,color: Colors.black,
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
                              text:
                                  "Applied Coupon : ${_paymentController.couponCode.value}",
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
                                            text: "\u{20B9}${_paymentController
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
                                                        .toString()}")
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
                                            text: "\u{20B9}${_paymentController
                                                    .applyCoupon
                                                    .value
                                                    .couponDetails!
                                                    .finalAmount}")
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
              const SizedBox(height: 6,),
              Obx(() {
                return InkWell(
                  onTap: () {
                    if (_paymentController.couponCode.value != "") {
                      openCheckout((double.parse(_paymentController
                          .applyCoupon.value.couponDetails!.finalAmount
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
                                child: Lottie.asset(
                                    "assets/animations/loader.json"),
                              ),
                            ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6,),
            ],
          )),
        ));
  }
  planListRow1(PlanList planData, int index) {
    return Obx(
     () {
        return GestureDetector(
          onTap: () {
            _paymentController.couponCode.value = "";
            _controller.groupValue.value = index;
            // setState(() {

              _selectedPlan = index;
            // });

          },
          child: Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      _controller.groupValue.value == index
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _controller.groupValue.value == index
                          ? primaryColor
                          : Colors.grey,
                    ),
                  ),
                  title: BoldTextView(
                    text: "${planData.duration} Months",
                    textAlign: TextAlign.start,
                    textSize: 16,
                  ),
                  subtitle: BoldTextView(
                  textAlign: TextAlign.start,
                    color: primaryColor,weight: FontWeight.w500,
                    text: _controller.planDetails.value.list![index].perDay!
                                .toString()
                                .length >
                            5
                        ? "(${_controller.planDetails.value.list![index].perDay!.toString().substring(0, 5)})" +
                            " per day"
                        : "${_controller.planDetails.value.list![index].perDay!}per day",
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _controller.planDetails.value.list![index].discount != 0
                          ? DottedBorder(
                              borderType: BorderType.RRect,
                              dashPattern: const [3, 3],
                              color: primaryColor,
                              strokeWidth: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 3.0, bottom: 3, left: 10, right: 10),
                                child: RegularTextView(
                                  text:
                                      "${_controller.planDetails.value.list![index].discount}% OFF",
                                  color: primaryColor,
                                ),
                              ))
                          : const SizedBox(),
                      const SizedBox(
                        height: 6,
                      ),

                    ],
                  ),
                ),
                Positioned(
                    child: SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      planData.mrp != planData.fee!
                          ? Text(
                        "\u{20B9} ${_controller.planDetails.value.list![index].mrp}",
                        style: GoogleFonts.roboto(
                            color: examGreyColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough),
                      )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      BoldTextView(
                        text: "\u{20B9} ${planData.fee}",
                        textSize: 18,
                      ),
                    ],
                  ),
                ),
                bottom: 0,right: 0,),
              ],
            ),
          ),
        );
      }
    );
  }
}
