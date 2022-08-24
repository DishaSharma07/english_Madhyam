import 'package:english_madhyam/src/helper/controllers/payment_controller/payment.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/src/helper/model/purchase_history_model.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final PaymentController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        title: Text(
          "Purchase History",
          style: TextStyle(color: whiteColor),
        ),
        leading: const BackButton(),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetX<PaymentController>(
              init: PaymentController(),
              builder: (contr) {
                if (contr.purchaseloading.value) {
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
                  if (contr.purchasehistory.value.purchaseHistory!.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/49993-search.json',
                              height:
                                  MediaQuery.of(context).size.height * 0.2),
                          CustomDmSans(
                            text: "No Purchase History",
                            color: blackColor,
                          )
                        ],
                      ),
                    );
                  } else {
                    return refund(
                        purchase: contr.purchasehistory.value.purchaseHistory!);
                  }
                }
              }),
        ),
      ),
    );
  }

  Widget refund({required List<PurchaseHistory> purchase}) {
    return ListView.builder(
        shrinkWrap: true,
        // itemCount: 2,
        itemCount: purchase.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin:const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase[index].planTitle!.length > 20
                        ? purchase[index].planTitle!.substring(0, 18) + ".."
                        : purchase[index].planTitle!,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  // purchase[index].orderId!=null?Text(
                  //   "Order ID : " +
                  //       (purchase[index].orderId!.length > 25
                  //           ? purchase[index].orderId!.substring(0, 18) + ".."
                  //           : purchase[index].orderId!.toString()),
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 14),
                  // ):Text(""),
                  SizedBox(
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
                              text: 'Date of Purchase :' +
                                  purchase[index].startDate.toString(),
                              fontSize: 14,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomDmSans(
                              text: 'End Date of Subscription :' +
                                  purchase[index].endDate.toString(),
                              fontSize: 14,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            CustomDmSans(
                              text: "Plan Duration : " +
                                  purchase[index].planDuration!.toString() +
                                  " Month",
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: Row(
                          children: [
                            CustomDmSans(
                              text:
                                  " \u{20B9}${purchase[index].fee!.toString()}",
                              color: greenColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            CustomDmSans(
                              text:
                                  " \u{20B9}${purchase[index].originalPrice!.toString()}",
                              color: greyColor,
                              fontSize: 16,
                              linethrough: TextDecoration.lineThrough,
                            ),
                          ],
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

  void _onRefresh() async {
    // monitor network fetch
    _controller.purchaseHistory();

    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
