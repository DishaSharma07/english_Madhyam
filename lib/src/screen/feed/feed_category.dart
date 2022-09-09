import 'package:english_madhyam/src/helper/controllers/feed_controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/word_day.dart';
import 'package:english_madhyam/src/screen/feed/phrase_day.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class FeedCategory extends StatefulWidget {

  const FeedCategory({Key? key}) : super(key: key);

  @override
  _FeedCategoryState createState() => _FeedCategoryState();
}

class _FeedCategoryState extends State<FeedCategory> with TickerProviderStateMixin {
  late TabController tabController;

    final FeedController _feedController=Get.put<FeedController>(FeedController());

  DateTime? dateTime;
  String formattedDate ="";
  String chooseDate="";


  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _feedController.feedApiFetch(type: "word",date: "0");
    tabController = TabController(length: 2, vsync: this) ..addListener(() {
      setState(() {
        if(tabController.index==0)
        {
          _feedController.feedApiFetch(type: "word",date: "0");
        }
        else if(tabController.index==1){
          _feedController.feedApiFetch(type: "phrase",date: "0");
        }else{

        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,

        centerTitle: true,
        automaticallyImplyLeading: true,
        title:CustomDmSans(
          text: "Daily Learnings",
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: blackColor,
        ),
      actions:[
        InkWell(
          onTap: ()async{
            DateTime? newDateTime = await showRoundedDatePicker(
              height: MediaQuery.of(context).size.height * 0.3,
              styleDatePicker: MaterialRoundedDatePickerStyle(
                backgroundHeader: themeYellowColor,
              ),
              context: context,
              initialDate: dateTime,
              firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(seconds: 10),)
              theme: ThemeData(primarySwatch: Colors.pink),
            );

            if (newDateTime != null) {
              setState(() {
                dateTime = newDateTime;

                formattedDate=DateFormat("MMM -d-y").format(dateTime!);
                chooseDate=" ${dateTime!.year}-${dateTime!.month}-${dateTime!.day}";
                if(tabController.index==0)
                {
                  _feedController.feedApiFetch(type: "word",date: chooseDate);
                }
              else{
                  _feedController.feedApiFetch(type: "phrase",date: chooseDate);

                }


              });

            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset("assets/icon/calendar.svg",color: purpleColor,),
          ),
        )

      ]
      ),
      body: DefaultTabController(
        length: 2,

        child: Column(
          children: [
            tabstile(),
            Obx(() {
              if (_feedController.loading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  alignment: Alignment.center,
                  child: Lottie.asset("assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.2),
                );
              } else {
                return Expanded(
                  child: TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: const [
                    WordDay(),
                    //second
                    PhraseDay(),


                  ]),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget tabstile() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: TabBar(
        // isScrollable: false,
        //   physics: const AlwaysScrollableScrollPhysics(),
          unselectedLabelColor: blackColor,
          indicatorSize: TabBarIndicatorSize.label,

          controller: tabController,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "WORD",
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Phrase",
                      style: GoogleFonts.roboto(fontSize: 12)),
                ),
              ),
            ),

          ]),
    );
  }
}
