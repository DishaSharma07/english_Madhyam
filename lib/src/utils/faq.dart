
import 'package:english_madhyam/src/helper/controllers/cms_controller.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:html/parser.dart';




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
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: whiteColor,
          title: CustomDmSans(
            text: "FAQ's",
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
          leading: BackButton(
            color: blackColor,
          ),
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
            itemCount:_cmsController.CmsDAta.value.cmsPages!.faqs!.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            itemBuilder: (context,index){
              return  Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  textColor: blackColor,
                  collapsedBackgroundColor: lightGreyColor,
                  // collapsedIconColor: blackColor,
                  iconColor: blackColor,
                  title:  CustomDmSans(text:_cmsController.CmsDAta.value.cmsPages!.faqs![index].question.toString(),
                      fontSize: 14.0, fontWeight: FontWeight.w600),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0,right: 14,bottom: 10),
                      child: CustomDmSans(text:_htmlConverter.parseHtmlString(_cmsController.CmsDAta.value.cmsPages!.faqs![index].answer.toString()),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },

          );
        })


    );

  }

}
