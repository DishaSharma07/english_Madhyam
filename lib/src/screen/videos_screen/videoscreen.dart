import 'package:english_madhyam/src/helper/controllers/youtube_contr.dart';
import 'package:english_madhyam/src/helper/model/youtube_list.dart';
import 'package:english_madhyam/src/screen/videos_screen/videoplayer.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final String title;

  const VideoScreen({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final VideoController _videoController = Get.put(VideoController());

  String getThumbnail({
    required String videoId,
    String quality = "sddefault",
    bool webp = false,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoController.video_listController(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: purpleColor,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CustomDmSans(
            text: widget.title,
            color: whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(18),
        children: [
          // searchBar(),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomDmSans(
                text: "Recent",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              Icon(
                Icons.keyboard_arrow_right_sharp,
                color: blackColor,
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Obx(
            () {
              if (_videoController.loading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Lottie.asset(
                      "assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ),
                );
              } else {
                if (_videoController.videoList.value.videos != null) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: recentVideos(_videoController.videoList.value));
                } else {
                  return Center(
                      child: CustomDmSans(
                    text: 'No Recents',
                  ));
                }
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          Obx(() {
            if (_videoController.loading.value) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Lottie.asset(
                    "assets/animations/loader.json",
                    height: MediaQuery.of(context).size.height * 0.14,
                  ),
                ),
              );
            } else {
              if (_videoController.videoList.value.videos != null) {
                return ListView.builder(
                    itemCount: _videoController.videoList.value.videos!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      String thumbnailUrl = getThumbnail(
                          videoId: _videoController
                                  .videoList.value.videos![index].videoId ??
                              "");

                      return InkWell(
                        onTap: () {
                          Get.to(() => VideoPlayerScreen(
                              index: index,
                              video: _videoController.videoList.value));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          color: Colors.red,
                                          image: DecorationImage(
                                              image: NetworkImage(thumbnailUrl),
                                              scale: 1.2,
                                              fit: BoxFit.cover)),
                                      // child: Image.network(',scale: 1.2
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDmSans(
                                          text: _videoController.videoList.value
                                              .videos![index].title
                                              .toString(),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          // overflow: TextOverflow.ellipsis,
                                          // maxlines: 1,
                                          // softwrap: true,
                                        ),
                                        CustomDmSans(
                                          text: _videoController.videoList.value
                                              .videos![index].publishAtDate!,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          // child:
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Lottie.asset('assets/animations/49993-search.json',
                      height: MediaQuery.of(context).size.height * 0.2),
                );
              }
            }
          })
        ],
      ),
    );
  }

  Widget recentVideos(YoutubeListModel value) {
    return ListView.builder(
        itemCount: value.videos!.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String thumbnailUrl =
              getThumbnail(videoId: value.videos![index].videoId ?? "");

          return InkWell(
            onTap: () {
              Get.to(() => VideoPlayerScreen(
                    index: index,
                    video: value,
                  ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),

                      image: DecorationImage(
                          image: NetworkImage(thumbnailUrl),
                          scale: 1.2,
                          fit: BoxFit.cover),
                      // color: Colors.red,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Positioned(
                          bottom: 5,
                          right: 10,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.transparent,
                            child: CircleAvatar(
                              backgroundColor: Colors.black45,
                              radius: 22,
                              child: Center(
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: whiteColor,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: CustomDmSans(
                      text: value.videos![index].title.toString(),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: CustomDmSans(
                      text: value.videos![index].publishAtDate.toString(),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                      color:const Color(0xff4B4B4B),
                    ))
              ],
            ),
          );
        });
  }

  Widget searchBar() {
    return InkWell(
      onTap: () {
//         setState(() {
//           searchController.clear();
//
// // loading=true;
//           // googlePlace = GooglePlace(Secrets.API_KEY);
//         });
      },
      child: Container(
        height: 60,
        child: TextField(
          cursorHeight: 25,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: EdgeInsets.all(18),
              child: SvgPicture.asset(
                "assets/icons/search/search.svg",
              ),
            ),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle: const TextStyle(color: Colors.grey, height: 3),
            hintText: 'search by topic',
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeYellowColor)),
            filled: true,
            fillColor: Color(0xffEDEDED).withOpacity(0.5),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: Colors.white,
              ),
              // borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
