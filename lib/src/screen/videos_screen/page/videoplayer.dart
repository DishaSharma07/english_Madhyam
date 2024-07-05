import 'package:english_madhyam/resrc/models/model/youtube_list.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int index;
final YoutubeListModel video;
  VideoPlayerScreen({Key? key, required this.index,required this.video}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  PodPlayerController? controller;
  bool? isVideoPlaying;
  bool showprogress = false;


  @override
  void initState() {
  try{
    controller = PodPlayerController(

      playVideoFrom: PlayVideoFrom.youtube(widget.video.videos![widget.index].videoId.toString()),

      podPlayerConfig:const  PodPlayerConfig(
        isLooping: false,
        autoPlay: false,

      ),
    )..initialise();
  }catch(e){
    print(e.toString()+"CRASHES");
  }
    //    }
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      PodVideoPlayer(

        controller: controller!,
        videoTitle: CustomDmSans(text: "English Madhyam",color: themeYellowColor,),
        podProgressBarConfig: const PodProgressBarConfig(
          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
        ),
      )
    );
  }

}

