import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
// import 'package:skeletonizer/skeletonizer.dart';

import 'package:english_madhyam/resrc/utils/app_colors.dart';


import '../../resrc/widgets/boldTextView.dart';
import '../../resrc/utils/ui_helper.dart';
import '../screen/pages/page/setup.dart';
class GridViewSkeleton extends StatelessWidget {
  const GridViewSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
          crossAxisSpacing: 4),
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))),
        child: SkeletonItem(
            child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.rectangle,
              border: Border.all(width: 1, color: greyColor),
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: UiHelper.getLoadingImage(imageUrl: ""),
                ),
                const SizedBox(
                  height: 10,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: primaryColor1),
                    child: const BoldTextView(
                      text: "",
                      textSize: 12,
                      color: white,
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
    ;
  }
}
