import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/cousescontroller.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class EditorialsPage extends StatefulWidget {
  EditorialsPage({Key? key}) : super(key: key);

  @override
  _EditorialsPageState createState() => _EditorialsPageState();
}

class _EditorialsPageState extends State<EditorialsPage> {
  String week = "";
  String firstdate = "";
  String day = "";
  late String dob;
  int? monthdata;
  int? year;
  bool _isloading = true;
  DateTime? dateTime;
  String ChooseDate = "";
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _weekDay = DateFormat('E');
  final _month = DateFormat('MM');
  final _year = DateFormat('y');
  final dates = <Days>[];
  final CoursesController _courses = Get.put(CoursesController());

  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    getData();
    dates[5].status = true;
  }

  getData() async {
    firstdate = DateFormat('yyyy-MM-dd').format(_currentDate);
    for (int i = 0; i < 6; i++) {
      var newDate = DateTime.now().subtract(Duration(days: 5));
      formattedDate = DateFormat("MMM -d-y").format(_currentDate);
      final date = newDate.add(Duration(days: i));
      // var now =
      //     currentDate.subtract(new Duration(days: currentDate.weekday - 1));
      if (i == 0) {
        dates.add(Days(
            dateInt: _dayFormatter.format(date),
            dayStr: _weekDay.format(date),
            month: _month.format(date),
            date: date,
            year: _year.format(date),
            status: false));
      } else {
        dates.add(Days(
            dateInt: _dayFormatter.format(date),
            dayStr: _weekDay.format(date),
            month: _month.format(date),
            date: date,
            year: _year.format(date),
            status: false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: authGreyColor,
      appBar: AppBar(
        //backgroundColor: themePurpleColor,
        titleSpacing: 0.0,
        title: ToolbarTitle(title: "Editorials",),
        centerTitle: false,
        actions: [
          InkWell(
            onTap: () async {
              DateTime? newDateTime = await showRoundedDatePicker(
                height: MediaQuery.of(context).size.height * 0.3,
                styleDatePicker: MaterialRoundedDatePickerStyle(
                  backgroundHeader: themeYellowColor,
                ),
                context: context,
                initialDate: dateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(
                  const Duration(seconds: 10),
                ),
                theme: ThemeData(primarySwatch: Colors.pink),
              );
              if (newDateTime != null) {
                setState(() {
                  dateTime = newDateTime;
                  formattedDate = DateFormat("MMM -d-y").format(dateTime!);
                  ChooseDate =
                      " ${dateTime!.year}-${dateTime!.month}-${dateTime!.day}";

                  _courses.selectDate(date: ChooseDate.toString(),isRefresh: true);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset("assets/icon/calendar.svg",color: Theme.of(context).hintColor,),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: schedule(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
            ),
            child: CustomRoboto(
              text: "Editorials ( ${formattedDate} )",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: EditorialsList(
              type: 1,
              date: ChooseDate,
            ),
          )
        ],
      ),
    );
  }

  Widget schedule() {
    return SizedBox(
      height: 72,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      ChooseDate = "";
                    });
                    for (int i = 0; i < 6; i++) {
                      setState(() {
                        dates[i].status = false;
                      });
                    }
                    setState(() {
                      dates[index].status = true;

                      week = dates[index].dayStr;
                      // var month = DateFormat('yyyy-MM-dd').format(
                      //     _currentDate);
                      day = dates[index].dateInt;
                      monthdata = int.parse(dates[index].month);
                      year = int.parse(dates[index].year);
                      _isloading = true;
                      dob = "${year}-${monthdata}-${day}";
                      formattedDate =
                          DateFormat("MMM -d-y").format(dates[index].date);

                      _courses.selectDate(date: dob.toString(),isRefresh: true);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    height: 72,
                    width: 40,
                    decoration: BoxDecoration(
                        color: (dates[index].status)
                            ? themePurpleColor
                            : authGreyColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          dates[index].dayStr,
                          style: TextStyle(
                              color: dates[index].status == true
                                  ? whiteColor
                                  : Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: ChooseDate != null
                                    ? authGreyColor
                                    : dates[index].status == true
                                        ? authGreyColor
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(dates[index].dateInt,style: TextStyle(color: Colors.black),)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class Days {
  String dateInt;
  String dayStr;
  String month;
  String year;
  DateTime date;
  bool status = false;

  Days(
      {required this.dateInt,
      required this.date,
      required this.dayStr,
      required this.status,
      required this.month,
      required this.year});

  @override
  String toString() {
    // TODO: implement toString
    return dateInt + "  " + dayStr + " " + month + " " + " " + year;
  }
}
