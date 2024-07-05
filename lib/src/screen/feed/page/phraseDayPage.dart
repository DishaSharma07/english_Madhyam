import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/cardSlider_widget.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../../resrc/helper/bindings/feed_bindings/feed_bind.dart';
import '../../pages/page/converter.dart';

class PhraseDayPge extends StatefulWidget {
  const PhraseDayPge({Key? key}) : super(key: key);

  @override
  _PhraseDayPgeState createState() => _PhraseDayPgeState();
}

class _PhraseDayPgeState extends State<PhraseDayPge> {
  final HtmlConverter _htmlConverter = HtmlConverter();
  String FormattedDate = "";

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
        body: GetX<FeedController>(
          init: FeedController(),
          builder: (controller) {
            return child(controller);
          },
        ));
  }

  Widget child(FeedController controller) {
    if (controller.loading.value) {
      return Loading();
    } else {
      if (controller.phraseList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/animations/49993-search.json',
                  height: MediaQuery.of(context).size.height * 0.15),
            ),
            CustomDmSans(text: "No Words Today")
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            InkWell(

                onTap: () {
                  _speak(controller.phraseList[0].word!);
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

            CardSliderWidget(
              list: controller.phraseList,
            ),
          ],
        );
      }
    }
  }
  FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setVolume(5);
    await flutterTts.setSpeechRate(0.3);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }
}
