import 'package:english_madhyam/src/screen/pages/controller/cms_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import '../../../custom/toolbarTitle.dart';

class TermsCond extends StatefulWidget {
  TermsCond({Key? key}) : super(key: key);

  @override
  _TermsCondState createState() => _TermsCondState();
}

class _TermsCondState extends State<TermsCond> {
  final CMSSController _cmsController=Get.put(CMSSController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const ToolbarTitle(title: "Terms & Conditions"),
      ),
      body: Obx((){
        if(_cmsController.loading==true){
          return Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: Center(
              child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.14,),
            ),
          );
        }else{
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(

              child: Html(
                data: _cmsController.cmsData.value.cmsPages!.cmsPages!.terms!,
              ),
            ),
          );
        }
      }),
    );
  }
}
