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
  final Function(int pageCount) paginationCallback;

  const PhraseDayPge({Key? key,required this.paginationCallback}) : super(key: key);

  @override
  _PhraseDayPgeState createState() => _PhraseDayPgeState();
}

class _PhraseDayPgeState extends State<PhraseDayPge> {
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
            CustomDmSans(text: "No Phrase Today")
          ],
        );
      } else {
        return Column(
          children: [
            CardSliderWidget(
              list: controller.phraseList,
              paginationCallback: (page){
                widget.paginationCallback(page);
                controller.pageCounter.value=controller.pageCounter.value+1;
              },
              currentPageCount: controller.pageCounter.value,
            ),
          ],
        );
      }
    }
  }

}
