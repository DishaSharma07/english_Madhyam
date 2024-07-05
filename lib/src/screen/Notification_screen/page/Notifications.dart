import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/Notification_screen/controller/notification_contr.dart';
import 'package:english_madhyam/src/internet_connectivity/initialize_internet_checker.dart';
import 'package:english_madhyam/src/screen/Notification_screen/page/notification_detail.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotifcationController _notifcationController = Get.find();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  String duration(int index){

    Duration posted=DateTime.parse(_notifcationController.notificationdata.value.notification![index].created_at.toString()).difference(DateTime.now());
    return posted.inHours<(-24)?posted.inDays.toString()+" Days ago":posted.inHours.toString()+" hr ago";
  }
  @override
  void initState() {
    // TODO: implement initState
    InternetChecker(ctx: context);

    super.initState();
  }
  void _onRefresh() async {
    // monitor network fetch
    _notifcationController.getNotification();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    _refreshController.refreshCompleted();
  }
  void _onNoRefresh() async {
    _notifcationController.getNotification();
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.0,
          //backgroundColor: whiteColor,
          title: ToolbarTitle(title: "Notification",),
          actions: [
            InkWell(
              onTap: () {

                _notifcationController.clearAll();

              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding:
                const EdgeInsets.only(left: 14, right: 12, top: 7, bottom: 0),
                decoration: BoxDecoration(
                  color:  greenColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomDmSans(
                  text:  "Clear all",
                  color: whiteColor,
                  fontSize: 15,
                ),
              ),
            )

          ],
        ),


        body: Obx((){
          if(_notifcationController.notification_loading.value){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            if (_notifcationController.notificationdata.value.result == false) {
              return GestureDetector(

                onVerticalDragDown:(i) {
                  _onNoRefresh();
                },
                child: Center(
                  child: Lottie.asset('assets/animations/49993-search.json',
                      height: MediaQuery.of(context).size.height * 0.2),
                ),
              );
            }else{
              return SmartRefresher(
                  controller: _refreshController,
                  onRefresh:_onRefresh,
                  child: buildListView());
            }

          }
        })
    );
  }

  ListView buildListView() {
    return ListView.builder(
        itemCount: _notifcationController.notificationdata.value.notification!.length,
        itemBuilder: (context,index){
          return Column(
            children: [
              InkWell(
                onTap: (){
                  _notifcationController.readNotification(id: _notifcationController.notificationdata.value.notification![index].id.toString());

                  Get.to(()=>NotificationDetail(notification: _notifcationController.notificationdata.value.notification![index]));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child:  ListTile(
                    tileColor: _notifcationController.notificationdata.value.notification![index].read==1?lightGreyColor:whiteColor,
                    isThreeLine: true,
                    minVerticalPadding: 0.0,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20.0,),
                    leading: Container(
                      width: MediaQuery.of(context).size.width*0.15,
                      height: MediaQuery.of(context).size.height*0.15,
                      decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border:  const Border(
                            right:  BorderSide(width: 1.0, color: Colors.white24)
                        ),
                        image:_notifcationController.notificationdata.value.notification![index].image!=null ?
                        DecorationImage(
                            image:
                            NetworkImage((_notifcationController.notificationdata.value.notification![index].image).toString())
                            ,fit: BoxFit.cover):DecorationImage(
                            image:
                            AssetImage(("assets/images/placeholder.png").toString())
                            ,fit: BoxFit.fill),

                      ),
                    ),
                    title: CustomDmSans(
                      text:(_notifcationController.notificationdata.value.notification![index].title).toString(),
                      fontWeight: FontWeight.w700,fontSize: 14,),

                    subtitle:  CustomDmSans(
                      text:(_notifcationController.notificationdata.value.notification![index].text).toString(),
                      maxLines: 2,
                      fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey,),
                    trailing:  CustomDmSans(
                      text:duration(index)=="0 hr ago"?"Just Now":duration(index).replaceAll("-", ""),
                      fontWeight: FontWeight.w500,fontSize: 12,color: greyColor,),
                  ),
                ),
              ),
              const Divider(thickness: 1.5,)
            ],
          );
        });
  }
}
