import 'package:english_madhyam/resrc/models/model/feed_model/feed_model.dart';
import 'package:english_madhyam/resrc/widgets/slider_widget.dart';
import 'package:english_madhyam/src/screen/pages/page/converter.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardSliderWidget extends StatefulWidget {
  final List<dynamic> list;

  const CardSliderWidget({Key? key, required this.list}) : super(key: key);

  @override
  State<CardSliderWidget> createState() => _CardSliderWidgetState();
}

class _CardSliderWidgetState extends State<CardSliderWidget> {
  final HtmlConverter _htmlConverter = HtmlConverter();
  String FormattedDate = "";
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return CardSlider(
      cards: widget.list.map((e) => cardView(e)).toList(),
      bottomOffset: .0005,
      cardHeight: 1.3,
      containerWidth: MediaQuery.of(context).size.width,
      containerHeight: MediaQuery.of(context).size.height * 0.69,
    );
  }

  Widget cardView(dynamic item) {
    return Container(
      decoration: BoxDecoration(
          color: purpleColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 4)
          ]),
      child: cardChild(feedDataModel: item),
    );
  }

  Widget cardChild({
    required Dataum feedDataModel,
  }) {
    String htmlMean =
        _htmlConverter.parseHtmlString(feedDataModel.meaning.toString());
    String htmlSnoym =
        _htmlConverter.parseHtmlString(feedDataModel.synonyms.toString());
    String htmlAntonym =
        _htmlConverter.parseHtmlString(feedDataModel.antonyms.toString());
    String htmlExample =
        _htmlConverter.parseHtmlString(feedDataModel.example.toString());
    return SingleChildScrollView(
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
                      fit: BoxFit.cover)
                  : const DecorationImage(
                      image: AssetImage("assets/img/word.jpg"),
                      fit: BoxFit.cover),
            ),
          ),
          Text(
            feedDataModel.date.toString(),
            style: GoogleFonts.raleway(
              fontSize: 14,
              color: Colors.white,
            ),
          ), Text(
            feedDataModel.word.toString(),
            style: GoogleFonts.raleway(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            // height: MediaQuery.of(context).size.height*0.8,
            padding: const EdgeInsets.only(top: 03, left: 10, right: 10),
            child: Column(
              // shrinkWrap: true,
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
                                ) /*Text(
                                                      htmlSnoym,
                                                      style: GoogleFonts.raleway(
                                                        fontSize: 16,
                                                        color: blackColor,
                                                      ))*/
                                ,
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
                                ) /*Text(
                                                      htmlAntonym,
                                                      style: GoogleFonts.raleway(
                                                        fontSize: 16,
                                                        color: blackColor,
                                                      ))*/
                                ,
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
                                ) /*Text(
                                                      htmlExample,
                                                      style: GoogleFonts.raleway(
                                                        fontSize: 16,
                                                        color: blackColor,
                                                      ))*/
                                ,
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
  String dateFormatConversion(String date){
    // Convert the string to a DateTime object
    DateTime dateTime = DateTime.parse(date);
    // Format the DateTime object to the desired format
    String formattedDateString = DateFormat('d MMMM yyyy').format(dateTime);
  }

// Widget phraseWidget({
//   required FeedDataModel phrase,
// }) {
//   String htmlMean = _htmlConverter.parseHtmlString(phrase.meaning.toString());
//   return Column(
//     children: [
//       Container(
//         height: MediaQuery.of(context).size.height * 0.2,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           image: phrase.image != null
//               ? DecorationImage(
//               image: NetworkImage(
//                 phrase.image.toString(),
//               ),
//               fit: BoxFit.cover)
//               : const DecorationImage(
//               image: AssetImage("assets/img/word.jpg"),
//               fit: BoxFit.cover),
//         ),
//       ),
//       Text(
//         phrase.word.toString(),
//         style: GoogleFonts.raleway(
//           fontSize: 24,
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       const SizedBox(height: 10),
//       Container(
//         padding: const EdgeInsets.all(10),
//         height:
//         MediaQuery.of(context).size.height * 0.3,
//
//         child: Scrollbar(
//           thumbVisibility: true,
//           thickness: 5.0,
//           trackVisibility: true,
//           radius: const Radius.circular(12),
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//
//               Wrap(
//                 children: [
//                   Row(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context)
//                             .size
//                             .width *
//                             0.25,
//                         child: Text("Phrase:  ",
//
//                             style:
//                             GoogleFonts.raleway(
//                                 fontSize: 16,
//                                 color: whiteColor,
//
//                                 fontWeight:
//                                 FontWeight
//                                     .w600)),
//                       ),
//                       Expanded(
//                         child: Text(
//                             phrase
//                                 .word!,
//                             style:
//                             GoogleFonts.raleway(
//                               fontSize: 16,
//                               color: whiteColor,
//                             )),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Wrap(
//                 children: [
//                   Row(
//                     crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context)
//                             .size
//                             .width *
//                             0.25,
//                         child: Text("Meaning:  ",
//                             style:
//                             GoogleFonts.raleway(
//                                 fontSize: 16,
//                                 color: whiteColor,
//                                 fontWeight:
//                                 FontWeight
//                                     .w600)),
//                       ),
//                       Expanded(
//                           child: Html(
//                             data: htmlMean,
//                             style: {
//                               "body": Style(
//                                   fontSize: FontSize(18.0),fontWeight: FontWeight.w300,
//                                   color: whiteColor
//                               ),
//                             },
//                           )
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
