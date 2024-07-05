import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
class ListAgendaSkeleton extends StatelessWidget {
const ListAgendaSkeleton({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {

  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder: (context, index) => SkeletonItem(
        child: SkeletonListTile(
          verticalSpacing: 12,
          leadingStyle: const SkeletonAvatarStyle(
              width: 64, height: 64, shape: BoxShape.rectangle),
          titleStyle: SkeletonLineStyle(
              height: 16,
              minLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          subtitleStyle: SkeletonLineStyle(
              height: 12,
              maxLength: 200,
              randomLength: true,
              borderRadius: BorderRadius.circular(12)),
          hasSubtitle: true,
        ),),
  );
}
}
