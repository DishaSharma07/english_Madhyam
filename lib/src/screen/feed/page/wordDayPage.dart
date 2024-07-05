import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/cardSlider_widget.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';


class WordDayPage extends StatefulWidget {
  const WordDayPage({Key? key}) : super(key: key);

  @override
  _WordDayPageState createState() => _WordDayPageState();
}

class _WordDayPageState extends State<WordDayPage> {
  // var wordDay = controller.wordOfDayList[index];
  // FormattedDate = DateFormat("MMM -d-y")
  //     .format(DateTime.parse(wordDay.date!));
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
      if (controller.wordOfDayList.isEmpty) {
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
                  _speak(controller.wordOfDayList[0].word!);
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
              list: controller.wordOfDayList,
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
