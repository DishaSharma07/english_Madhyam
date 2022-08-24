import 'package:english_madhyam/src/helper/controllers/cms_controller.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:english_madhyam/src/utils/faq.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';




class ContactUs extends StatelessWidget {
   ContactUs({Key? key}) : super(key: key);
   final CMSSController _cmsController=Get.put(CMSSController());
   HtmlConverter _htmlConverter= HtmlConverter();

   List icon = [
    "assets/cms/supportchat.svg",
    "assets/cms/calling.svg",
    "assets/cms/mail.svg",
    "assets/cms/faq.svg",
  ];

   List color = [
     const Color(0xff4FBF67),
     const  Color(0xffFF6628),
     const Color(0xff9B51E0),
     const Color(0xffFFCF19)
   ];
   List title = [
     "Support Chat",
     "Call Center",
     "Email",
     "FAQ"
   ];
   List subtitle = [
     "24x7 Online Support",
     "24x7 Customer Service",

   ];

   Future<void> _makePhoneCall(String phoneNumber) async {
     // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
     // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
     // such as spaces in the input, which would cause `launch` to fail on some
     // platforms.
     final Uri launchUri = Uri(
       scheme: 'tel',
       path: phoneNumber,
     );
     await launch(launchUri.toString());
   }
   Future<void> _sendEmail(String email) async {
     final Uri launchUri = Uri(
       scheme: 'mailto',
       path: email,
       queryParameters: {'subject': 'English Madhyam'},
     );

     await launch(launchUri.toString());
   }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading: BackButton(
          color: blackColor,
        ),
        title: CustomDmSans(
          text: "Contact Us",
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: blackColor,
        ),
      ),

      body: Padding(
        padding:  EdgeInsets.all(MediaQuery.of(context).size.width/16),
        child: SingleChildScrollView(
          child: Obx((){
            if(_cmsController.loading.value==true){
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                alignment: Alignment.center,
                child: Lottie.asset("assets/animations/loader.json",
                    height: MediaQuery.of(context).size.height * 0.2),
              );
            }else{
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomDmSans(text: "Contact Us",fontWeight: FontWeight.w700,fontSize: 36,),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomDmSans(text: "Please choose what types of support do you need and let us know.",fontSize: 16,color: Colors.grey,)
                  ,const SizedBox(
                    height: 20,
                  ),

                  GridView.builder(

                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height /1.6),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: 4,
                      itemBuilder: (BuildContext ctx, int index) {
                        return
                          GestureDetector(
                            onTap: (){
                              if(index==0){
                                // Get.to(()=>ChatScreen());

                              }else if(index==1){
                                _makePhoneCall(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.phoneNumber!);
                              }
                              else if(index==2){
                                String _email=_htmlConverter.parseHtmlString(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.helpFeed!);
                                _sendEmail(_email);

                              }else if(index==3){
                                Get.to(()=>const FaqScreen());
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:const Color(0xffE6E8EC),
                                  ),
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              child: Padding(
                                padding:const  EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: color[index].withOpacity(0.2),
                                      radius: 40,
                                      child: Center(
                                        child: SvgPicture.asset(icon[index]),
                                      ),

                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomDmSans(text: title[index], fontWeight: FontWeight.w500,fontSize: 14,),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(child: CustomDmSans(text: index==3?     "+" + _cmsController.CmsDAta.value.cmsPages!.faqs!.length.toString() +" Answers"
                                        :index==2?_cmsController.CmsDAta.value.cmsPages!.cmsPages!.emailId!:subtitle[index],align: TextAlign.center, fontWeight: FontWeight.w500,fontSize: 12,color: Colors.grey,)),

                                  ],
                                ),
                              ),
                            ),
                          );

                      }),

                  const SizedBox(
                    height: 20,
                  ),
                  CustomDmSans(text: "Follow Us",fontSize: 15,fontWeight: FontWeight.w700),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          Launch(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.twitterId!);

                        },
                        child: Card(
                          child: Image.asset(
                            "assets/cms/twiter.png",
                            height: MediaQuery.of(context).size.height*0.06,

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Launch(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.youtubeId!);
                        },
                        child: Card(

                          child: Image.asset(
                            "assets/cms/youtube.png",
                            height: MediaQuery.of(context).size.height*0.06,

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Launch(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.facebookId!);

                        },
                        child: Card(

                          child: Image.asset(
                            "assets/cms/facebook.png",
                            height: MediaQuery.of(context).size.height*0.06,

                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Launch(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.telegramId!);

                        },
                        child: Card(

                          child: Image.asset(
                            "assets/img/tele.jpg",
                            height: MediaQuery.of(context).size.height*0.06,
                          ),
                        ),
                      ),InkWell(
                        onTap: (){
                          instaLaunch(_cmsController.CmsDAta.value.cmsPages!.cmsPages!.instaId!);
                        },
                        child: Card(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/img/insta3.jpg",
                              height: MediaQuery.of(context).size.height*0.04,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              );
            }
          })
        ),
      ),
    );
  }
  //go to insta profile
  void instaLaunch(String id)async {
    var url = '${id}';

    if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
    Uri.parse(url),
      mode: LaunchMode.externalApplication,

    );
    } else {
    throw 'There was a problem to open the url: $url';
    }
  }
  //go to all profiles
  void Launch(String id)async {
    var url = '${id}';

    if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
    Uri.parse(url),
      mode: LaunchMode.externalApplication,

    );
    } else {
    throw 'There was a problem to open the url: $url';
    }
  }
}
