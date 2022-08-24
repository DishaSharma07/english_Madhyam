import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/helper/controllers/profile_controllers/profile_controllers.dart';
import 'package:english_madhyam/src/screen/editorials_page/editorials_details.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/utils/custom_roboto/custom_roboto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CategoryEditorial extends StatefulWidget {
  final String Title;
  const CategoryEditorial({Key? key,required this.Title}) : super(key: key);

  @override
  State<CategoryEditorial> createState() => _CategoryEditorialState();
}

class _CategoryEditorialState extends State<CategoryEditorial> {

  final EditorialDetailController detailController=Get.put(EditorialDetailController());

  List<String> color = [
    "#DBDDFF",
    "#FFECE7",
    "#EDF6FF",
    "#EBFFE5",
    "#F6F4FF",
    "#EBFFE5",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor.withOpacity(0.01),
      body: Obx((){
        if(detailController.isDataProcessing.value){
          return SizedBox(
            height: MediaQuery.of(context).size.height*0.8,
            child: Center(
              child: Lottie.asset("assets/animations/loader.json",height: MediaQuery.of(context).size.height*0.14,),
            ),
          );
        }
        else{
          if(detailController
              .editorialByCat.isNotEmpty){
            return  Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListView.builder(
                // reverse: true,
                  controller: detailController.readingController,
                  itemCount: detailController.editorialByCat.length,
                  itemBuilder: (BuildContext ctx, int index){
                    if (index == detailController.editorialByCat.length - 1 &&
                        detailController.isMoreDataAvailable.value == true) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return InkWell(
                        onTap: () {
                          // if( _contr.editorialByCat[index].type == "PAID"){
                          //
                          // }else{
                          //
                          // }
                          (detailController.editorialByCat[index].id);
                          detailController.meaningList(id:  detailController.editorialByCat[index].id.toString());

                          // detailController.editorialDetailsFetch(id: detailController.editorialByCat[index].id.toString());

                          Get.to(()=>EditorialsDetails(
                            editorial_title: detailController.editorialByCat[index].title!, editorial_id:  detailController.editorialByCat[index].id!,));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 8, bottom: 6, left: 15, right: 15),
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 8, right: 8),
                            decoration: BoxDecoration(
                              color:Color(hexStringToHexInt(color[index % 6])),

                              boxShadow: [
                                BoxShadow(
                                    color: greyColor.withOpacity(0.4),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 2)),
                              ],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.11,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  // padding: const EdgeInsets.only(
                                  //     top: 15, bottom: 15, left: 35, right: 35),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: whiteColor,
                                      image: DecorationImage(
                                          fit:
                                          detailController.editorialByCat[index].image == null
                                              ? BoxFit.contain
                                              : BoxFit.cover,
                                          image:
                                          detailController.editorialByCat[index].image != null
                                              ? NetworkImage(detailController.editorialByCat[index].image
                                              .toString())
                                              :
                                          const NetworkImage(
                                              "https://www.pngitem.com/pimgs/m/251-2518917_ui-system-apps-by-blackvariant-gallery-icon-png.png"))),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          (detailController.editorialByCat[index].title!.length>34?detailController.editorialByCat[index].title!.substring(0,34)+"..":detailController.editorialByCat[index].title!).toString() +
                                              " ( ${detailController.editorialByCat[index].date} ) ",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: blackColor),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height *
                                              0.025,
                                        ),
                                        FittedBox(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_outlined,
                                                color: greyColor,
                                                size: 16,
                                              ),
                                              Text(detailController.editorialByCat[index].date!,

                                                style: GoogleFonts.lato(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                    color: greyColor),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Icon(
                                                Icons.person_outline,
                                                color: greyColor,
                                                size: 16,
                                              ),
                                              Text(detailController.editorialByCat[index].author!,

                                                style: GoogleFonts.lato(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w500,
                                                    color: greyColor),
                                              ),

                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height *
                                              0.005,
                                        ),
                                        detailController.editorialByCat[index].type == "PAID"
                                            ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: CustomRoboto(
                                            text: "Premium",
                                            fontSize: 12,
                                            color: purpleColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                            : Align(
                                          alignment: Alignment.bottomRight,
                                          child: CustomRoboto(
                                            text: "Free",
                                            fontSize: 12,
                                            color: purpleColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));

                  }),
            );
          }else{
            return Center(
              child: Lottie.asset('assets/animations/49993-search.json',
                  height: MediaQuery.of(context).size.height * 0.2),
            );
          }

        }
      })
    );
  }
}
