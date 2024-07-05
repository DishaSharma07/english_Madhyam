import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/player_state.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EditorialAudioPlayer extends StatefulWidget {

   const EditorialAudioPlayer({Key?key});

  @override
  State<EditorialAudioPlayer> createState() => _EditorialAudioPlayerState();
}

class _EditorialAudioPlayerState extends State<EditorialAudioPlayer> {
  final EditorialDetailController controller =
  Get.find();
  var speed = 0.75.obs;

  @override
  Widget build(BuildContext context) {
    return  audioPlayerSection();
  }
  Widget audioPlayerSection() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: purpleColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.42,
                  child: ValueListenableBuilder<ProgressBarState>(
                    valueListenable:
                    controller.pageManager.value.progressNotifier,
                    builder: (_, value, __) {
                      return ProgressBar(
                        thumbColor: Colors.white,
                        progressBarColor: white,
                        timeLabelTextStyle:
                        const TextStyle(color: Colors.white),
                        progress: value.current,
                        buffered: value.buffered,
                        total: value.total,
                        onSeek: controller.pageManager.value.seek,
                      );
                    },
                  ),
                ),
              ),
              InkWell(
                  onTap: () {
                    showSpeedDialog();
                  },
                  child: const Icon(Icons.more_vert))
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  backwordButton(context),
                  const SizedBox(
                    width: 12,
                  ),
                  playerButton(context),
                  const SizedBox(
                    width: 12,
                  ),
                  forwordButton(context),
                ],
              ))
        ],
      ),
    );
  }
  Widget backwordButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.replay_10,
        color: Colors.white,
      ),
      iconSize: 25.0,
      onPressed: () {
        controller.pageManager.value.seekToBack(Duration(
            hours: 0,
            minutes: 0,
            seconds: 60,
            milliseconds: 0,
            microseconds: 0));
      },
    );
  }

  Widget forwordButton(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.forward_10,
          color: Colors.white,
        ),
        iconSize: 25.0,
        onPressed: () {
          controller.pageManager.value.seekToNext(const Duration(
              hours: 0,
              minutes: 0,
              seconds: 60,
              milliseconds: 0,
              microseconds: 0));
        });
  }
  Widget playerButton(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: controller.pageManager.value.buttonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(
                Icons.play_circle,
                color: Colors.white,
              ),
              iconSize: 35.0,
              onPressed: controller.pageManager.value.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(
                Icons.pause_circle,
                color: Colors.white,
              ),
              iconSize: 35.0,
              onPressed: controller.pageManager.value.pause,
            );
        }
      },
    );
  }
  showSpeedDialog() {
    Get.bottomSheet(
      Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        speed(0.75);
                        controller.pageManager.value.speed0point75();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 0.75
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(
                              title: ".75x", color: Colors.black)
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        speed(1);
                        controller.pageManager.value.speedOne();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 1
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(
                              title: "Normal", color: Colors.black),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        speed(1.25);
                        controller.pageManager.value.speed1point25();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 1.25
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(
                              title: "1.25x", color: Colors.black),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        speed(1.50);
                        controller.pageManager.value.speed1point50();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 1.50
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(
                              title: "1.50x", color: Colors.black),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        speed(1.75);
                        controller.pageManager.value.speed1point75();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 1.75
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(
                              title: "1.75x", color: Colors.black),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        speed(2);
                        controller.pageManager.value.speedTwo();
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check,
                              color: speed.value == 2
                                  ? Colors.black
                                  : Colors.transparent),
                          const SizedBox(
                            width: 10,
                          ),
                          buildSpeedTitle(title: "2x", color: Colors.black),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ))
            ],
          )),
      isDismissible: true,
      enableDrag: true,
    );
  }
  Widget buildSpeedTitle({title, color}) {
    return RegularTextDarkMode(
      text: title,
      color: color,
    );
  }

}
