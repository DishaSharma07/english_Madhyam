import 'dart:io';
import 'package:english_madhyam/resrc/models/model/purchase_history_model.dart';
import 'package:english_madhyam/resrc/widgets/rounded_button.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../commonController/authenticationController.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PaymentController _controller = Get.find();
  final AuthenticationManager _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.purchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //iconTheme:  IconThemeData(color:  _authController.darkTheme?Colors.white:white),
        //backgroundColor: _authController.darkTheme?Colors.transparent:purpleColor,
        title: const ToolbarTitle(title: "Purchase History"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GetX<PaymentController>(
                            init: PaymentController(),
                            builder: (contr) {
                              if (contr.purchaseloading.value) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Center(
                                    child: Lottie.asset(
                                      "assets/animations/loader.json",
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                    ),
                                  ),
                                );
                              } else {
                                if (contr.purchasehistory.value.purchaseHistory!
                                    .isEmpty) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomDmSans(
                                          text: "No Plan Found",
                                          color: blackColor,
                                        ),
                                        RoundedButton(
                                            text: "Choose Plan",
                                            press: () {
                                              if (Platform.isAndroid) {
                                                Get.to(() =>
                                                    const ChoosePlanDetails());
                                              } else {
                                                Get.to(() => InAppPlanDetail());
                                              }
                                            })
                                      ],
                                    ),
                                  );
                                } else {
                                  return refund(
                                      purchase: contr.purchasehistory.value
                                          .purchaseHistory!);
                                }
                              }
                            }),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget refund({required List<PurchaseHistory> purchase}) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: purchase.length,
        itemBuilder: (context, index) {
          var data = purchase[index];
          return Card(
            elevation: 5,
            margin:
                const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.planTitle!.length > 20
                        ? "${data.planTitle!.substring(0, 18)}.."
                        : data.planTitle!,
                    style: const TextStyle(
                        /*color: Colors.black,*/
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDmSans(
                              text: 'Date of Purchase :${data.startDate}',
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomDmSans(
                              text: 'End Date of Subscription :${data.endDate}',
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomDmSans(
                              text:
                                  "Plan Duration : ${data.planDuration!} Month",
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Platform.isIOS
                            ? buildText(data)
                            : CustomDmSans(
                                text: " \u{20B9}${data.fee!.toString()}",
                                color: greenColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildText(PurchaseHistory purchaseHistory) {
    if (purchaseHistory.planDuration == 1) {
      return CustomDmSans(
        text: " \u{20B9}${"105"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else if (purchaseHistory.planDuration == 3) {
      return CustomDmSans(
        text: " \u{20B9}${"259"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else if (purchaseHistory.planDuration == 12) {
      return CustomDmSans(
        text: " \u{20B9}${"649"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else {
      return SizedBox();
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    _controller.purchaseHistory();

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
