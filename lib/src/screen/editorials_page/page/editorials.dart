import 'dart:io';

import 'package:english_madhyam/resrc/models/model/home_model/home_model.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/cousescontroller.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_details.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';

import '../../material/controller/materialController.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class EditorialsList extends StatefulWidget {
  final int type;
  final List<Editorials>? editorials;
  final String? date;

  const EditorialsList(
      {Key? key, required this.type, this.editorials, this.date})
      : super(key: key);

  @override
  State<EditorialsList> createState() => _EditorialsListState();
}

class _EditorialsListState extends State<EditorialsList> {
  List<Gradient> color = [
    learning1,
    learning2,
    learning3,
    learning4,
    learning5,
    learning6
  ];
  final ProfileControllers _subController = Get.put(ProfileControllers());

  final CoursesController _coursesController = Get.put(CoursesController());

  final EditorialDetailController detailController =
      Get.put(EditorialDetailController());

  final MaterialController _planDetailsController =
      Get.put(MaterialController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        _coursesController.selectDate(
            date: _coursesController.select_date.value, isRefresh: false);
        _refreshController.refreshCompleted();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.editorials!.length,
          itemBuilder: (BuildContext ctx, int index) {
            return InkWell(
                onTap: () {
                  if (widget.editorials![index].type == "PAID" &&
                      _subController.profileGet.value.user!.isSubscription ==
                          "Y") {
                    try {
                      Get.to(() => CommonEditorialsDetailsPage(
                            editorial_id: widget.editorials![index].id!.toInt(),
                            editorial_title:
                                widget.editorials![index].title.toString(),
                          ));
                    } catch (e) {
                      // print(e);
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  } else if (widget.editorials![index].type == "PAID" &&
                      _subController.profileGet.value.user!.isSubscription ==
                          "N") {
                    // Get.to(() => CommonEditorialsDetailsPage(
                    //   editorial_id: widget.editorials![index].id!.toInt(),
                    //   editorial_title:
                    //   widget.editorials![index].title.toString(),
                    // ));
                    //pay page
                    if (Platform.isAndroid) {
                      Get.to(() => const ChoosePlanDetails());
                    } else {
                      Get.to(() => InAppPlanDetail());
                    }
                  } else {
                    detailController.meaningList(
                        id: widget.editorials![index].id!.toString());
                    Get.to(() => CommonEditorialsDetailsPage(
                          editorial_id: widget.editorials![index].id!.toInt(),
                          editorial_title:
                              widget.editorials![index].title.toString(),
                        ));
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 6, left: 15, right: 15),
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 8, right: 8),
                    decoration: BoxDecoration(
                      gradient: color[index % 6],
                      boxShadow: [
                        BoxShadow(
                            color: greyColor.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: const Offset(1, 2)),
                      ],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.095,
                          width: MediaQuery.of(context).size.width * 0.3,
                          // padding: const EdgeInsets.only(
                          //     top: 15, bottom: 15, left: 35, right: 35),
                          decoration: widget.editorials![index].image != null
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: whiteColor,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget
                                          .editorials![index].image
                                          .toString())))
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: whiteColor,
                                  image: const DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          "assets/img/noimage.png"))),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (widget.editorials![index].title!.length > 34
                                          ? widget.editorials![index].title!
                                                  .substring(0, 32) +
                                              ".."
                                          : (widget.editorials![index].title)
                                              .toString()) +
                                      " (${(widget.editorials![index].date!.substring(3, 7) + widget.editorials![index].date!.substring(0, 3) + widget.editorials![index].date!.substring(7, 12))}) ",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: whiteColor),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_outlined,
                                        color: whiteColor,
                                        size: 16,
                                      ),
                                      Text(
                                        widget.editorials![index].date!
                                            .substring(0, 11)
                                            .toString(),
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.person_outline,
                                        color: whiteColor,
                                        size: 16,
                                      ),
                                      Text(
                                        widget.editorials![index].author!
                                                    .length >
                                                10
                                            ? widget.editorials![index].author!
                                                    .substring(0, 9) +
                                                ".."
                                            : widget.editorials![index].author!
                                                    .toString() +
                                                "",
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: whiteColor),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      widget.editorials![index].type == "PAID"
                                          ? Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomRoboto(
                                                text: "Premium",
                                                fontSize: 12,
                                                color: purpleColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomRoboto(
                                                text: "Free",
                                                fontSize: 12,
                                                color: purpleColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
    } else {
      return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: GetX<CoursesController>(
            builder: (_courseController) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              controller: _courseController.editorialList,
                              itemCount:
                                  _courseController.editorialListing.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return InkWell(
                                    onTap: () {
                                      if (_courseController
                                              .editorialListing[index].type ==
                                          "FREE") {
                                        detailController.meaningList(
                                            id: _courseController
                                                .editorialListing[index].id!
                                                .toString());

                                        Get.to(() =>
                                            CommonEditorialsDetailsPage(
                                              editorial_title: _courseController
                                                  .editorialListing[index].title
                                                  .toString(),
                                              editorial_id: _courseController
                                                  .editorialListing[index].id!
                                                  .toInt(),
                                            ));
                                      } else {
                                        if (_subController.profileGet.value
                                                .user!.isSubscription ==
                                            "N") {
                                          if (Platform.isAndroid) {
                                            Get.to(() =>
                                                const ChoosePlanDetails());
                                          } else {
                                            Get.to(() => InAppPlanDetail());
                                          }
                                        } else {
                                          detailController.meaningList(
                                              id: _courseController
                                                  .editorialListing[index].id!
                                                  .toString());

                                          Get.to(() =>
                                              CommonEditorialsDetailsPage(
                                                editorial_title:
                                                    _courseController
                                                        .editorialListing[index]
                                                        .title
                                                        .toString(),
                                                editorial_id: _courseController
                                                    .editorialListing[index].id!
                                                    .toInt(),
                                              ));
                                        }
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 10,
                                            left: 15,
                                            right: 15),
                                        padding: const EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 8,
                                            right: 6),
                                        decoration: BoxDecoration(
                                          gradient: color[index % 6],
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    greyColor.withOpacity(0.4),
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                offset: const Offset(1, 2)),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              padding: const EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 15,
                                                  left: 35,
                                                  right: 35),
                                              decoration: _courseController
                                                          .editorialListing[
                                                              index]
                                                          .image ==
                                                      null
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      image: const DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              "assets/img/noimage.png")),
                                                      color: whiteColor)
                                                  : BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              _courseController
                                                                  .editorialListing[index]
                                                                  .image!)),
                                                      color: whiteColor),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    (_courseController
                                                                    .editorialListing[
                                                                        index]
                                                                    .title!
                                                                    .length >
                                                                30
                                                            ? _courseController
                                                                    .editorialListing[
                                                                        index]
                                                                    .title!
                                                                    .substring(
                                                                        0, 25) +
                                                                ".."
                                                            : _coursesController
                                                                .editorialListing[
                                                                    index]
                                                                .title!) +
                                                        "(${_courseController.editorialListing[index].date!.substring(3, 7) + _courseController.editorialListing[index].date!.substring(0, 3) + _courseController.editorialListing[index].date!.substring(7, 11)})",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: whiteColor),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  FittedBox(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_outlined,
                                                          color: whiteColor,
                                                          size: 16,
                                                        ),
                                                        Text(
                                                          _courseController
                                                              .editorialListing[
                                                                  index]
                                                              .date!,
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  whiteColor),
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          Icons.person_outline,
                                                          color: whiteColor,
                                                          size: 16,
                                                        ),
                                                        Text(
                                                          _courseController
                                                                      .editorialListing[
                                                                          index]
                                                                      .author!
                                                                      .length >
                                                                  10
                                                              ? _courseController
                                                                      .editorialListing[
                                                                          index]
                                                                      .author!
                                                                      .substring(
                                                                          0,
                                                                          9) +
                                                                  ".."
                                                              : _courseController
                                                                  .editorialListing[
                                                                      index]
                                                                  .author!
                                                                  .toString(),
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  whiteColor),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        _courseController
                                                                    .editorialListing[
                                                                        index]
                                                                    .type ==
                                                                "PAID"
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    CustomRoboto(
                                                                  text:
                                                                      "Premium",
                                                                  fontSize: 12,
                                                                  color:
                                                                      purpleColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )
                                                            : Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    CustomRoboto(
                                                                  text: "Free",
                                                                  fontSize: 12,
                                                                  color:
                                                                      purpleColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              })),
                      // when the _loadMore function is running
                      if (_coursesController.loadMore.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      // When nothing else to load
                      if (_coursesController.nextPage.value == false)
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          color: Colors.amber,
                          child: const Center(
                            child: Text('You have fetched all of the content'),
                          ),
                        ),
                    ],
                  ),
                  _courseController.firstLoading.value
                      ? const Loading()
                      : const SizedBox(),
                  _courseController.editorialListing.isEmpty
                      ? notDataFound()
                      : const SizedBox(),
                ],
              );
            },
          ));
    }
    //Editorial Listing  on see all
  }

  Widget notDataFound() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RegularTextView(
            text: "NO  data found",
            textSize: 14,
            color: Colors.black,
            textAlign: TextAlign.center),
        InkWell(
            onTap: () {
              _onRefresh();
            },
            child: const Icon(
              Icons.refresh,
              size: 40,
            ))
      ],
    ));
  }
}
