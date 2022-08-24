import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class Achieverstake extends StatefulWidget {
  final List<Achievers> achievers;
  const Achieverstake({Key? key, required this.achievers}) : super(key: key);

  @override
  State<Achieverstake> createState() => _AchieverstakeState();
}

class _AchieverstakeState extends State<Achieverstake> {
  final CarouselController _sliderController = CarouselController();
  HtmlConverter _htmlConverter=HtmlConverter();
  int _current = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.54,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: greyColor.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 1,
                spreadRadius: 2)
          ]),
      child: achieverSlider(context),
    );
  }

  Widget achieverSlider(BuildContext ctx) {
    final List<Widget> imageSliders = widget.achievers
        .map((item) => Container(
                // padding:
                //     const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Our Achievers Take",
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: blackColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage((item.image).toString(),
                                scale: 0.5),
                            fit: BoxFit.contain
                          ),
                          border: Border.all(
                              color: gradientLigthblue, width: 12)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: Text(
                    (item.userName).toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    item.exam_name==null?"":item.exam_name.toString(),
                    style: GoogleFonts.montserrat(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Divider(
                  color: greyColor,
                ),
                Flexible(
                  child: Text(
                      _htmlConverter.removeAllHtmlTags(item.description!),
                    style: GoogleFonts.montserrat(fontSize: 14),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            )))
        .toList();

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _sliderController,
          options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              autoPlay: true,
              aspectRatio: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.achievers.asMap().entries.map((entry) {

          return GestureDetector(
            onTap: () {
              _sliderController.animateToPage(
                entry.key,
              );
            },
            child: Container(
              width: 14.0,
              height: 14.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
              decoration: _current == entry.key
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: gradientBlue.withOpacity(0.9))
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: gradientBlue.withOpacity(0.9), width: 1.3),
                      color: whiteColor),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
