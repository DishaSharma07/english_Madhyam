import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';

import '../../resrc/widgets/boldTextView.dart';

class ListVideoSkeleton extends StatelessWidget {
  const ListVideoSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      itemCount: 10,
      itemBuilder: (context, index) => SkeletonItem(
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 250,
                    ),
                    const InkWell(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 50,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                BoldTextView(text: ""),
              ],
            ),
          )),
    );
    ;
  }
}
