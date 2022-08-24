import 'package:english_madhyam/src/helper/controllers/youtube_contr.dart';
import 'package:english_madhyam/src/screen/videos_screen/videoscreen.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoCatScreen extends StatefulWidget {
  const VideoCatScreen({Key? key}) : super(key: key);

  @override
  State<VideoCatScreen> createState() => _VideoCatScreenState();
}

class _VideoCatScreenState extends State<VideoCatScreen> {
  final VideoController _videoController=Get.put(VideoController());
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<String> color = [
    "#DBDDFF",
    "#FFDDDD",
    "#F5E8FF",
  ];
  void _onRefresh() async {
    // monitor network fetch
    _videoController.video_catController();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _refreshController.refreshCompleted();
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,

      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDmSans(text: "Videos",color: purpleColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,),
        ),
      ),
      body: Obx(()
           {

            if(_videoController.catloading.value==false){

              return _videoController
                  .videoListCat.value.categories==null
                  ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Lottie.asset(
                    "assets/animations/49993-search.json",
                    height: MediaQuery.of(context).size.height * 0.2),
              ):
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh:_onRefresh,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.9,
                    child: GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 4),
                        itemCount: _videoController.videoListCat.value.categories!.data!.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return InkWell(
                            onTap: () {

                              Get.to(()=>VideoScreen(id:  _videoController
                                  .videoListCat.value.categories!.data![index].id!.toString() ,title:  _videoController
                                  .videoListCat.value.categories!.data![index].name! ,));
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: greyColor.withOpacity(0.8),
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                      offset: const Offset(-4, 4))
                                ],
                                color: Color(
                                    hexStringToHexInt(color[index % 4])),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                              greyColor.withOpacity(0.7),
                                              spreadRadius: 0.0,
                                              blurRadius: 5,
                                              offset: const Offset(-3, 3))
                                        ],
                                        image: DecorationImage(image: NetworkImage( _videoController
                                            .videoListCat.value.categories!.data![index].image.toString()),fit: BoxFit.cover)
                                    ),

                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4),
                                    height: MediaQuery.of(context).size.height*0.128,
                                  ),

                                  Text(
                                    _videoController
                                        .videoListCat.value.categories!.data![index].name!.length>20? _videoController
                                        .videoListCat.value.categories!.data![index].name!.substring(0,18)+"..": _videoController
                                        .videoListCat.value.categories!.data![index].name!,
                                    maxLines:2,

                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              );
            }else{
              return Center(
                child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.2,),
              );
            }
          }
      ),

    );
  }
}
