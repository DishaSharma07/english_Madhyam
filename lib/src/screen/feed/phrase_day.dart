import 'dart:ui';

import 'package:english_madhyam/src/helper/bindings/feed_bindings/feed_bind.dart';
import 'package:english_madhyam/src/helper/controllers/feed_controller/feed_controller.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class PhraseDay extends StatefulWidget {
  const PhraseDay({Key? key}) : super(key: key);

  @override
  _PhraseDayState createState() => _PhraseDayState();
}

class _PhraseDayState extends State<PhraseDay> {
  final FeedController _feedController=Get.put<FeedController>(FeedController());

  final HtmlConverter _htmlConverter=HtmlConverter();
  String FormattedDate="";

  @override
  void initState() {
    // TODO: implement initState
    FeedBinding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: purpleColor.withOpacity(0.001),
        body:SizedBox(
          height: MediaQuery.of(context).size.height ,
          width: MediaQuery.of(context).size.width,
          child: GetX<FeedController>(
            init: FeedController(),
            builder: (controller) {
              if(controller.loading.value){
                return Center(
                  child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.2,),
                );
              }
              else{
                return controller.feeds.value.data!.phrase==null||controller.feeds.value.data!.phrase!.isEmpty
                    ?  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Lottie.asset(
                          'assets/animations/49993-search.json',
                          height:
                          MediaQuery.of(context).size.height * 0.15),
                    ),
                    CustomDmSans(text: "No Phrases Today")
                  ],
                )
                    : PageView.builder(
                    controller: controller.pageController,
                    // onPageChanged: controller.,
                    scrollDirection: Axis.vertical,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.feeds.value.data!.phrase!.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      FormattedDate=DateFormat("MMM -d-y").format(DateTime.parse(controller.feeds.value.data!.phrase![index].date!));
                      String htmlMean=_htmlConverter.parseHtmlString(controller.feeds.value.data!.phrase![index].meaning.toString());

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(

                          children: [
                            const SizedBox(height: 8),
                            Text(
                              FormattedDate,
                              style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: darkGreyColor,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.feeds.value.data!.phrase![index].word.toString(),
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height:
                              MediaQuery.of(context).size.height * 0.25,
                              width: MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: controller.feeds.value.data!.phrase![index].image!=null?DecorationImage(
                                      image: NetworkImage(controller.feeds.value.data!.phrase![index].image.toString(),),
                                      fit: BoxFit.cover
                                  ):DecorationImage(
                                      image: AssetImage("assets/img/phraseee.png"),
                                      fit: BoxFit.cover
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        color: greyColor.withOpacity(0.6),
                                        spreadRadius: 2,
                                        offset:const Offset(1,4)
                                    )
                                  ]
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:const EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height*0.3,
                              decoration: BoxDecoration(
                                  color:const  Color(0xffccccff).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: greyColor.withOpacity(0.2),
                                        offset: const Offset(2, 4),
                                        spreadRadius: 3,
                                        blurRadius: 2
                                    )
                                  ]
                              ),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                thickness: 5.0,
                                trackVisibility: true,
                                radius: const Radius.circular(12),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Center(child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: purpleColor.withOpacity(0.4)
                                        ),
                                        padding:const EdgeInsets.all(2),
                                        child: CustomDmSans(text: "Scroll Down",fontSize: 10,))),
                                    Wrap(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              child: Text("Phrase:  ",
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 16,
                                                      color: blackColor,
                                                      fontWeight: FontWeight.w600)),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  controller.feeds.value.data!.phrase![index].word!,
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color: blackColor,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),Wrap(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              child: Text("Meaning:  ",
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 16,
                                                      color: blackColor,
                                                      fontWeight: FontWeight.w600)),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  htmlMean,
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 13,
                                                    color: blackColor,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }


            },
          ),
        ));
  }
}
