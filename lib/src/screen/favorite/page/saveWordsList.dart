import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/boldTextView.dart';
import 'package:english_madhyam/resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';



import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/favorite/model/wardDataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../utils/colors/colors.dart';
import '../../pages/page/converter.dart';
import '../../pages/page/custom_dmsans.dart';

class SaveWordList extends GetView<FavoriteController> {
  static const name = "SaveWordList";
  SaveWordList({Key? key}) : super(key: key);

  final FavoriteController favoriteController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ToolbarTitle(title: "My Words"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetX<FavoriteController>(builder: (controller) {
          return Stack(
            children: [
             listBodyWidget(saveWordsList: controller.saveWordsList),
              controller.loading.value?const Loading():const SizedBox(),
              !controller.loading.value && controller.saveWordsList.isEmpty?const Center(child: Text("No Data Found"),):const SizedBox(),
            ],
          );
        }),
      ),
    );
  }

  Widget listBodyWidget({required List<dynamic> saveWordsList}) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
          itemCount: saveWordsList.length,
          reverse: false,
          itemBuilder: (context, index) {
            WordData wordData = saveWordsList[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 5, top: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      "${wordData.word??""} :",
                      style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: primaryColor),
                    ),
                    subtitle: RegularTextView(
                      text: _htmlConverter.parseHtmlString(wordData.meaning.toString().replaceAll("-", "")),maxLine: 50,
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                       await  controller.removeWordsFromList(
                            context: context,
                            wordId: wordData.vocabId.toString() ?? "");
                       saveWordsList.removeAt(index);
                       controller.update();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.bookmark,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    favoriteController.getSaveWordsList();

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
