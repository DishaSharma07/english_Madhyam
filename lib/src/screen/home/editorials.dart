import 'package:english_madhyam/src/helper/controllers/choose_plan_detail_controller/choose_plan_detail_contr.dart';
import 'package:english_madhyam/src/helper/controllers/editorial_controller/cousescontroller.dart';
import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/choose_plan/choose_plan_details.dart';
import 'package:english_madhyam/src/screen/editorials_page/editorials_details.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class EditorialsList extends StatefulWidget {
  final int type;
  List<Editorials>? editorials;
  PageController? cont;
  String? Date;

  // int Index;

  EditorialsList(
      {Key? key, required this.type, this.editorials, this.cont, this.Date})
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
  final ProfileControllers _subcontroller = Get.put(ProfileControllers());
  final CoursesController _coursesController = Get.put(CoursesController());
  final EditorialDetailController detailController =
      Get.put(EditorialDetailController());
  final PlanDetailsController _planDetailsController =
  Get.put(PlanDetailsController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch

    _coursesController.editorialListing.clear();

    _coursesController.selectDate(date: _coursesController.select_date.value);
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
//Home Page Editorial List

    if (widget.type == 0) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.editorials!.length,
          itemBuilder: (BuildContext ctx, int index) {
            return InkWell(
                onTap: () {
                  if (widget.editorials![index].type == "PAID" &&
                      _subcontroller.profileGet.value.user!.isSubscription ==
                          "Y") {
                    detailController.meaningList(
                        id: widget.editorials![index].id!.toString());
                    // detailController.editorialDetailsFetch(
                    //     id: widget.editorials![index].id!.toString());

                    Get.to(() => EditorialsDetails(
                          editorial_id: widget.editorials![index].id!.toInt(),
                          editorial_title:
                              widget.editorials![index].title.toString(),
                        ));
                  } else if (widget.editorials![index].type == "PAID" &&
                      _subcontroller.profileGet.value.user!.isSubscription ==
                          "N") {
                    //pay page
                    Get.to(() => const ChoosePlanDetails());
                  } else {
                    detailController.meaningList(
                        id: widget.editorials![index].id!.toString());
                    // detailController.editorialDetailsFetch(
                    //     id: widget.editorials![index].id.toString());


                    Get.to(() => EditorialsDetails(
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
                                      fontSize: 14,
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
                                            fontSize: 12,
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
    }
    //Editorial Listing  on see all
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: GetBuilder<CoursesController>(
            init: CoursesController(),

          builder: (_courseController) {
             if(_courseController.editorialListing.isNotEmpty){
               return Column(
                 children: [
                   Expanded(
                       child: ListView.builder(
                           shrinkWrap: true,
                           controller: _courseController.editorialList,
                           physics: const BouncingScrollPhysics(),
                           itemCount: _courseController.editorialListing.length,
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
                                     // detailController.editorialDetailsFetch(
                                     //     id: _courseController
                                     //         .editorialListing[index].id!
                                     //         .toString());

                                     Get.to(() => EditorialsDetails(
                                       editorial_title: _courseController
                                           .editorialListing[index].title
                                           .toString(),
                                       editorial_id: _courseController
                                           .editorialListing[index].id!
                                           .toInt(),
                                     ));
                                   } else {

                                     if (_subcontroller
                                         .profileGet.value.user!.isSubscription ==
                                         "N") {
                                       Get.to(() => ChoosePlanDetails());
                                     } else {
                                       detailController.meaningList(
                                           id: _courseController
                                               .editorialListing[index].id!
                                               .toString());
                                       // detailController.editorialDetailsFetch(
                                       //     id: _courseController
                                       //         .editorialListing[index].id!
                                       //         .toString());


                                       Get.to(() => EditorialsDetails(
                                         editorial_title: _courseController
                                             .editorialListing[index].title
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
                                         top: 8, bottom: 10, left: 15, right: 15),
                                     padding: const EdgeInsets.only(
                                         top: 12, bottom: 12, left: 8, right: 6),
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
                                       mainAxisSize: MainAxisSize.min,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Container(
                                           height: MediaQuery.of(context).size.height *
                                               0.1,
                                           width: MediaQuery.of(context).size.width *
                                               0.35,
                                           padding: const EdgeInsets.only(
                                               top: 15,
                                               bottom: 15,
                                               left: 35,
                                               right: 35),
                                           decoration: _courseController
                                               .editorialListing[index]
                                               .image ==
                                               null
                                               ? BoxDecoration(
                                               borderRadius:
                                               BorderRadius.circular(12),
                                               image: const DecorationImage(
                                                   fit: BoxFit.cover,
                                                   image: AssetImage(
                                                       "assets/img/noimage.png")),
                                               color: whiteColor)
                                               : BoxDecoration(
                                               borderRadius:
                                               BorderRadius.circular(12),
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
                                             MainAxisAlignment.spaceBetween,
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
                                                     .substring(0, 25) +
                                                     ".."
                                                     : _coursesController
                                                     .editorialListing[index]
                                                     .title!) +
                                                     "(${_courseController.editorialListing[index].date!.substring(3, 7) + _courseController.editorialListing[index].date!.substring(0, 3) + _courseController.editorialListing[index].date!.substring(7, 11)})",
                                                 style: GoogleFonts.roboto(
                                                     fontSize: 14,
                                                     fontWeight: FontWeight.w700,
                                                     color: whiteColor),
                                               ),
                                               SizedBox(
                                                 height: MediaQuery.of(context)
                                                     .size
                                                     .height *
                                                     0.01,
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
                                                       _courseController
                                                           .editorialListing[index]
                                                           .date!,
                                                       style: GoogleFonts.lato(
                                                           fontSize: 12,
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
                                                           .substring(0, 9) +
                                                           ".."
                                                           : _courseController
                                                           .editorialListing[index]
                                                           .author!
                                                           .toString(),
                                                       style: GoogleFonts.lato(
                                                           fontSize: 12,
                                                           fontWeight: FontWeight.w500,
                                                           color: whiteColor),
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
                                                       alignment:
                                                       Alignment.bottomRight,
                                                       child: CustomRoboto(
                                                         text: "Premium",
                                                         fontSize: 12,
                                                         color: purpleColor,
                                                         fontWeight:
                                                         FontWeight.w600,
                                                       ),
                                                     )
                                                         : Align(
                                                       alignment:
                                                       Alignment.bottomRight,
                                                       child: CustomRoboto(
                                                         text: "Free",
                                                         fontSize: 12,
                                                         color: purpleColor,
                                                         fontWeight:
                                                         FontWeight.w600,
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
                   if (_coursesController.nextPage.value==false)
                     Container(
                       padding: const EdgeInsets.only(top: 10, bottom: 10),
                       color: Colors.amber,
                       child: const Center(
                         child: Text('You have fetched all of the content'),
                       ),
                     ),
                 ],
               );
             }else{
               return Center(
                         child: Lottie.asset("assets/animations/49993-search.json",height: MediaQuery.of(context).size.height*0.14,),
                       );
             }
          }
        )
        // child:  Obx((){
        //   if(_coursesController.firstLoading.value){
        //     return Center(
        //       child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.14,),
        //     );
        //   }
        //   else {
        //     return Column(
        //       children: [
        //         Expanded(
        //           child: ListView.builder(
        //               shrinkWrap: true,
        //               controller: _coursesController.editorialList,
        //               // physics: const NeverScrollableScrollPhysics(),
        //               itemCount:
        //               _coursesController.editorialListing.length,
        //               itemBuilder: (BuildContext ctx, int index) {
        //                 return InkWell(
        //                     onTap: () {
        //                       if (_coursesController.editorialListing[index].type ==
        //                           "FREE") {
        //                         print("FREE");
        //
        //                         detailController.editorialDetailsFetch(
        //                             id: _coursesController.editorialListing[index].id!
        //                                 .toString());
        //                         detailController.meaningList(
        //                             id: _coursesController.editorialListing[index].id!
        //                                 .toString());
        //                         Get.to(() => EditorialsDetails(
        //                           editorial_title: _coursesController.editorialListing[index].title
        //                               .toString(),
        //                           editorial_id: _coursesController.editorialListing[index].id!
        //                               .toInt(),
        //                         ));
        //                       } else {
        //                         print(_subcontroller
        //                             .profileGet.value.user!.isSubscription);
        //                         print("jcsdjvhfdhf22djg");
        //                         print(_subcontroller
        //                             .profileGet.value.user!.isSubscription);
        //                         if (_subcontroller
        //                             .profileGet.value.user!.isSubscription ==
        //                             "N") {
        //                           Get.to(() => ChoosePlanDetails());
        //                         } else {
        //                           print("hhhhh");
        //                           detailController.editorialDetailsFetch(
        //                               id: _coursesController.editorialListing[index].id!
        //                                   .toString());
        //                           detailController.meaningList(
        //                               id: _coursesController.editorialListing[index].id!
        //                                   .toString());
        //
        //                           Get.to(() => EditorialsDetails(
        //                             editorial_title: _coursesController.editorialListing[index].title
        //                                 .toString(),
        //                             editorial_id: _coursesController.editorialListing[index].id!
        //                                 .toInt(),
        //                           ));
        //                         }
        //                         print("paid");
        //                       }
        //                     },
        //                     child: Container(
        //                       color: Colors.transparent,
        //                       child: Container(
        //                         margin: const EdgeInsets.only(
        //                             top: 8, bottom: 10, left: 15, right: 15),
        //                         padding: const EdgeInsets.only(
        //                             top: 12, bottom: 12, left: 8, right: 6),
        //                         decoration: BoxDecoration(
        //                           gradient: color[index % 6],
        //                           boxShadow: [
        //                             BoxShadow(
        //                                 color: greyColor.withOpacity(0.4),
        //                                 blurRadius: 2,
        //                                 spreadRadius: 1,
        //                                 offset: const Offset(1, 2)),
        //                           ],
        //                           borderRadius: BorderRadius.circular(18),
        //                         ),
        //                         child: Row(
        //                           mainAxisSize: MainAxisSize.min,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Container(
        //                               height:
        //                               MediaQuery.of(context).size.height * 0.1,
        //                               width: MediaQuery.of(context).size.width * 0.35,
        //                               padding: const EdgeInsets.only(
        //                                   top: 15, bottom: 15, left: 35, right: 35),
        //                               decoration:_coursesController
        //                                   .editorialListing[index]
        //                                   .image ==
        //                                   null? BoxDecoration(
        //                                   borderRadius: BorderRadius.circular(12),
        //                                   image: const DecorationImage(
        //                                       fit:  BoxFit.cover,
        //                                       image:
        //                                       AssetImage(
        //                                           "assets/img/noimage.png")
        //                                   ),
        //                                   color: whiteColor):BoxDecoration(
        //                                   borderRadius: BorderRadius.circular(12),
        //                                   image: DecorationImage(
        //                                       fit: BoxFit.cover,
        //                                       image: NetworkImage(_coursesController
        //                                           .editorialListing[index]
        //                                           .image!)),
        //                                   color: whiteColor),
        //                             ),
        //                             const SizedBox(
        //                               width: 10,
        //                             ),
        //                             Expanded(
        //                               child: Column(
        //                                 mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                                 crossAxisAlignment: CrossAxisAlignment.start,
        //                                 children: [
        //                                   const SizedBox(
        //                                     height: 10,
        //                                   ),
        //                                   Text(
        //                                     (_coursesController
        //                                         .editorialListing[index]
        //                                         .title!
        //                                         .length >
        //                                         30
        //                                         ? _coursesController
        //                                         .editorialListing[index]
        //                                         .title!
        //                                         .substring(0, 25) +
        //                                         ".."
        //                                         : _coursesController
        //                                         .editorialListing[index]
        //                                         .title!) +
        //                                         "(${_coursesController.editorialListing[index].date!
        //
        //                                             .substring(3,7)+_coursesController
        //                                             .editorialListing[index].date!
        //                                             .substring(0,3)+_coursesController
        //                                             .editorialListing[index].date!
        //                                             .substring(7,11)
        //                                         })",
        //                                     style: GoogleFonts.roboto(
        //                                         fontSize: 14,
        //                                         fontWeight: FontWeight.w700,
        //                                         color: whiteColor),
        //                                   ),
        //                                   SizedBox(
        //                                     height:
        //                                     MediaQuery.of(context).size.height *
        //                                         0.01,
        //                                   ),
        //                                   FittedBox(
        //                                     child: Row(
        //                                       children: [
        //                                         Icon(
        //                                           Icons.access_time_outlined,
        //                                           color: whiteColor,
        //                                           size: 16,
        //                                         ),
        //                                         Text(
        //                                           _coursesController.editorialListing[index].date!
        //                                           ,
        //                                           style: GoogleFonts.lato(
        //                                               fontSize: 12,
        //                                               fontWeight: FontWeight.w500,
        //                                               color: whiteColor),
        //                                         ),
        //                                         const SizedBox(
        //                                           width: 4,
        //                                         ),
        //                                         Icon(
        //                                           Icons.person_outline,
        //                                           color: whiteColor,
        //                                           size: 16,
        //                                         ),
        //                                         Text(
        //                                           _coursesController.editorialListing[index].author!.length>10?_coursesController.editorialListing[index].author!.substring(0,9)+"..":_coursesController.editorialListing[index].author!
        //                                               .toString(),
        //                                           style: GoogleFonts.lato(
        //                                               fontSize: 12,
        //                                               fontWeight: FontWeight.w500,
        //                                               color: whiteColor),
        //                                         ),
        //                                         const SizedBox(
        //                                           width: 20,
        //                                         ),
        //
        //                                         _coursesController.editorialListing[index].type ==
        //                                             "PAID"
        //                                             ? Align(
        //                                           alignment: Alignment.bottomRight,
        //                                           child: CustomRoboto(
        //                                             text: "Premium",
        //                                             fontSize: 12,
        //                                             color: purpleColor,
        //                                             fontWeight: FontWeight.w600,
        //                                           ),
        //                                         )
        //                                             : Align(
        //                                           alignment: Alignment.bottomRight,
        //                                           child: CustomRoboto(
        //                                             text: "Free",
        //                                             fontSize: 12,
        //                                             color: purpleColor,
        //                                             fontWeight: FontWeight.w600,
        //                                           ),
        //                                         ),
        //                                       ],
        //                                     ),
        //                                   ),
        //
        //
        //                                 ],
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ));
        //               }),
        //         ),
        //         // when the _loadMore function is running
        //         if (_coursesController.loadMore == true)
        //           const Padding(
        //             padding: EdgeInsets.only(top: 10, bottom: 40),
        //             child: Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //           ),
        //
        //         // When nothing else to load
        //         if (_coursesController.nextPage == false)
        //           Container(
        //             padding: const EdgeInsets.only(top: 30, bottom: 40),
        //             color: Colors.amber,
        //             child: const Center(
        //               child: Text('You have fetched all of the content'),
        //             ),
        //           ),
        //       ],
        //     );
        //   }
        // })
        );
  }
}
