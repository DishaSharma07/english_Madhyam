
import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';



import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/pages/controller/cms_controller.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'converter.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool tap = false;
  final CMSSController _cmsController=Get.put(CMSSController());
  HtmlConverter _htmlConverter=HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.0,
          title: ToolbarTitle(title: "FAQ's",)
        ),
        body:
        Obx((){
          if(_cmsController.loading.value){
            return Container(
              height: MediaQuery.of(context).size.height*0.8,
              child: Center(
                child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.14,),
              ),
            );
          }
          return ListView.builder(
            itemCount:_cmsController.cmsData.value.cmsPages!.faqs!.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemBuilder: (context,index){
              return  Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: homeColor
                ),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ExpansionTile(
                    trailing: Icon(Icons.arrow_drop_down_outlined,color: Colors.black,),
                    textColor: blackColor,
                    //collapsedBackgroundColor: lightGreyColor,
                    // collapsedIconColor: blackColor,
                    iconColor: blackColor,
                    title:  RegularTextDarkMode(text:_cmsController.cmsData.value.cmsPages!.faqs![index].question.toString(),
                        ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0,right: 14,bottom: 10),
                        child: RegularTextDarkMode(text:_htmlConverter.parseHtmlString(_cmsController.cmsData.value.cmsPages!.faqs![index].answer.toString()),maxLine: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },

          );
        })


    );

  }

}
