import 'package:card_swiper/card_swiper.dart';
import 'package:english_madhyam/resrc/models/model/feed_model/feed_model.dart';
import 'package:english_madhyam/resrc/widgets/slider_widget.dart';
import 'package:english_madhyam/src/screen/pages/page/converter.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardSliderWidget extends StatefulWidget {
  final List<dynamic> list;
  final Function(int pageCount) paginationCallback;
  final int currentPageCount;

  const CardSliderWidget(
      {Key? key,
      required this.currentPageCount,
      required this.list,
      required this.paginationCallback})
      : super(key: key);

  @override
  State<CardSliderWidget> createState() => _CardSliderWidgetState();
}

class _CardSliderWidgetState extends State<CardSliderWidget> {
  final HtmlConverter _htmlConverter = HtmlConverter();
  int index = 0;
  final List<ScrollController> _scrollControllers = [];
  final SwiperController _swiperController = SwiperController();
  int _currentIndex = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPageCount;
    // for (int i = 0; i < widget.list.length; i++) {
    //   ScrollController scrollController = ScrollController();
    //   scrollController.addListener(() => _scrollListener(i));
    //   _scrollControllers.add(scrollController);
    // }
  }

  // void _scrollListener(int index) {
  //   _currentIndex = index;
  //   if (_scrollControllers[index].position.atEdge) {
  //     if (_scrollControllers[index].position.pixels != 0) {
  //       if (_currentIndex < widget.list.length - 1) {
  //         setState(() {
  //           _currentIndex = _currentIndex + 1;
  //         });
  //         _swiperController.move(
  //           _currentIndex,
  //           animation: false,
  //         );
  //         // if()
  //         // _swiperController.
  //       } else {
  //         //TODO add api call
  //         _currentPage = _currentPage + 1;
  //         widget.paginationCallback(_currentPage);
  //       }
  //     }
  //   }
  // }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return cardView();
    // return CardSlider(
    //   cards: widget.list.map((e) => cardView(e)).toList(),
    //   bottomOffset: .0008,
    //   cardHeight: 1.2,
    //
    //   paginationCallback: (page) {
    //     widget.paginationCallback(page);
    //   },
    //   containerWidth: MediaQuery.of(context).size.width,
    //   containerHeight: MediaQuery.of(context).size.height * 0.69,
    // );
  }

  Widget cardView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemHeight: MediaQuery.of(context).size.height * 0.65,
        scrollDirection: Axis.vertical,
        controller: _swiperController,
        itemWidth: MediaQuery.of(context).size.width * 0.9,
        itemCount: widget.list.length,
        curve: Curves.ease,
        viewportFraction: 0.8,
        scale: 0.8,
        itemBuilder: (c, i) {
          return cardChild(feedDataModel: widget.list[i], index: i);
        },
      ),
    );
  }

  Widget cardChild({
    required Dataum feedDataModel,
    required int index,
  }) {
    String htmlMean =
        _htmlConverter.parseHtmlString(feedDataModel.meaning.toString());
    String htmlSnoym =
        _htmlConverter.parseHtmlString(feedDataModel.synonyms.toString());
    String htmlAntonym =
        _htmlConverter.parseHtmlString(feedDataModel.antonyms.toString());
    String htmlExample =
        _htmlConverter.parseHtmlString(feedDataModel.example.toString());
    _currentIndex = index;
    if (_currentIndex == _currentPage * 19) {
      _currentPage = _currentPage + 1;
      widget.paginationCallback(_currentPage);
    }

    return Container(
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 4,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: feedDataModel.image != null
                  ? DecorationImage(
                      image: NetworkImage(
                        feedDataModel.image.toString(),
                      ),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage("assets/img/word.jpg"),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                childWidget(
                    htmlAntonym: htmlAntonym,
                    feedDataModel: feedDataModel,
                    htmlExample: htmlExample,
                    htmlMean: htmlMean,
                    htmlSnoym: htmlSnoym,
                    physics: NeverScrollableScrollPhysics()),
                if (htmlMean.length + htmlExample.length > 195)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: purpleColor,
                              child: childWidget(
                                  htmlAntonym: htmlAntonym,
                                  feedDataModel: feedDataModel,
                                  htmlExample: htmlExample,
                                  htmlMean: htmlMean,
                                  htmlSnoym: htmlSnoym,
                                  physics:const AlwaysScrollableScrollPhysics()),
                            );
                          });
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                            color: purplegrColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(24),
                                bottomLeft: Radius.circular(24))),
                        height: 28,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "View More..",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget childWidget({
    required Dataum feedDataModel,
    required String htmlMean,
    required String htmlSnoym,
    required String htmlAntonym,
    required String htmlExample,
    required ScrollPhysics physics,
  }) {
    return SingleChildScrollView(
      physics: physics,
      child: Column(
        children: [
          InkWell(

              onTap: () {
                _speak(feedDataModel.word!);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: purpleColor,
                  child: Icon(
                    Icons.volume_up_outlined,
                    color: whiteColor,
                  ),
                ),
              )),
          Text(
            dateFormatConversion(feedDataModel.date.toString()),
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            feedDataModel.word.toString(),
            style: GoogleFonts.raleway(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
            child: Column(
              children: [
                htmlMean == "null" || htmlMean.isEmpty
                    ? const SizedBox()
                    : Wrap(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text("Meaning:  ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Text(htmlMean,
                                    style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                htmlSnoym == "null" || htmlSnoym.isEmpty
                    ? const SizedBox()
                    : Wrap(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text("Synonyms:  ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Html(
                                  data: htmlSnoym,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(16.0),
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                htmlAntonym == "null" || htmlAntonym.isEmpty
                    ? const SizedBox()
                    : Wrap(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text("Antonyms:  ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Html(
                                  data: htmlAntonym,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(16.0),
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                htmlExample == "null" || htmlExample.isEmpty
                    ? const SizedBox()
                    : Wrap(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text("Examples:  ",
                                    style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                child: Html(
                                  data: htmlExample,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(16.0),
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String dateFormatConversion(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDateString = DateFormat('d MMMM yyyy').format(dateTime);
    return formattedDateString;
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }
}
