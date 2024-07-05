import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';


class ListDocumentSkeleton extends StatelessWidget {
  const ListDocumentSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      itemCount: 10,
      itemBuilder: (context, index) => SkeletonItem(
          child: Container(
            color: Colors.transparent,
            child: ListTile(
              title: Container(width: context.width,height: 20,color: greyColor,),
              trailing: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  "assets/icons/view_icon.png",
                  width: 40,
                ),
              ),
            ),
          )),
    );
    ;
  }
}
