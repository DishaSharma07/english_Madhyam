import 'package:english_madhyam/resrc/utils/app_colors.dart';
import 'package:english_madhyam/src/screen/category/controller/libraryController.dart';
import 'package:english_madhyam/src/screen/practice/page/praticeCategoryPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../resrc/widgets/loading.dart';
import 'package:english_madhyam/resrc/widgets/regularTextView.dart';

import 'package:english_madhyam/resrc/widgets/regularTextView.dart';


import '../../../../resrc/utils/routes/my_constant.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/gridViewSkeleton.dart';
import '../../../utils/colors/colors.dart';
import '../../material/controller/materialController.dart';
import '../../material/page/materialCategory.dart';
import '../../practice/controller/praticeController.dart';
class LibraryPage extends GetView<LibraryController> {
    LibraryPage({Key? key}) : super(key: key);

  final controller=Get.put(LibraryController());
   final MaterialController _materialController =
   Get.put(MaterialController());

   final GlobalKey<RefreshIndicatorState> _refreshKey =
   GlobalKey<RefreshIndicatorState>();

   final _praticeController = Get.put(PraticeController());

   List<String> color = [
     "#EDF6FF",
     "#FFDDDD",
     "#F6F4FF",
     "#EBFFE5",
   ];

   void _onRefresh() async {
     // monitor network fetch
     controller.getParentCategory(isRefresh: false);
     await Future.delayed(const Duration(milliseconds: 1000));
     // if failed,use refreshFailed()
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: const ToolbarTitle(
           title: "Library",
           color: Colors.white,
         ),
       ),
       body: Container(
         width: context.width,
         height: context.height,
         padding: const EdgeInsets.all(12),
         child: Stack(
           children: [
             RefreshIndicator(
                 key: _refreshKey,
                 onRefresh: () async {
                   return Future.delayed(
                     const Duration(seconds: 1),
                         () {
                       _onRefresh();
                     },
                   );
                 },
                 child: Skeleton(
                   themeMode: ThemeMode.light,
                   isLoading: controller.loading.value,
                   skeleton: const GridViewSkeleton(),
                   child:  buildMenuList(context),)
             ),
             Obx(() =>
             controller.loading.value ? const Loading() : const SizedBox())
           ],
         ),
       ),
     );
   }
   buildMenuList(BuildContext context) {
     return GetX<LibraryController>(builder: (controller) {
       return GridView.builder(
         shrinkWrap: true,
         physics: const AlwaysScrollableScrollPhysics(),
         itemCount: controller.parentCategories.length,
         itemBuilder: (context, index) => buildChildMenuBody(index, context),
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 3,
             mainAxisSpacing: 20,
             childAspectRatio: 0.7,
             crossAxisSpacing: 4),
       );
     });
   }


   Widget buildChildMenuBody(int index, BuildContext context){
     return InkWell(
       onTap: (){
         if(controller.parentCategories[index].id==1){
           _materialController.getMaterialCategory(controller.parentCategories[index].id.toString());
           Get.to(MaterialCategoryListPage(parentcateId: controller.parentCategories[index].id.toString(),));
         }else{
           _praticeController.getPracticeCategories(controller.parentCategories[index].id.toString());
           Get.to(PraticeCategorListPage(parentcateId: controller.parentCategories[index].id.toString(),));
         }
       },
       child: Container(
         margin: const EdgeInsets.all(4),
         padding: const EdgeInsets.all(8),
         decoration: BoxDecoration(
           boxShadow: [
             BoxShadow(
                 color: greyColor
                     .withOpacity(0.8),
                 blurRadius: 2,
                 spreadRadius: 1,
                 offset: const Offset(-4, 4))
           ],
           color: Color(hexStringToHexInt(
               color[index % 4])),
           borderRadius:
           BorderRadius.circular(8),
         ),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment:
           MainAxisAlignment
               .spaceBetween,
           children: [
             Container(
               decoration: BoxDecoration(
                   borderRadius:
                   BorderRadius.circular(
                       4),
                   boxShadow: [
                     BoxShadow(
                         color: greyColor
                             .withOpacity(
                             0.7),
                         spreadRadius: 0.0,
                         blurRadius: 5,
                         offset:
                         const Offset(
                             -3, 3))
                   ],
                   image: DecorationImage(
                       image: NetworkImage(
                           controller.parentCategories[index].image ?? MyConstant.banner_image),
                       fit: BoxFit.cover)),
               padding:
               const EdgeInsets.only(
                   left: 4.0, right: 4),
               height: MediaQuery.of(context)
                   .size
                   .height *
                   0.13,
             ),
             const SizedBox(
               height: 5,
             ),
             Text(
               controller.parentCategories[index].name??"",
               maxLines: 2,
               textAlign: TextAlign.center,
               style: GoogleFonts.roboto(
                   fontSize: 12,color: blackColor,
                   fontWeight:
                   FontWeight.w600),
             )
           ],
         ),
       ),
     );
   }

   buildChildMenuBody1(int index, BuildContext context) {
     return GestureDetector(
       onTap: (){
         print(controller.parentCategories[index].id.toString()+"ID");
         if(controller.parentCategories[index].id==1){
           _materialController.getMaterialCategory(controller.parentCategories[index].id.toString());
           Get.to(MaterialCategoryListPage(parentcateId: controller.parentCategories[index].id.toString(),));
         }else{
           _praticeController.getPracticeCategories(controller.parentCategories[index].id.toString());
           Get.to(PraticeCategorListPage(parentcateId: controller.parentCategories[index].id.toString(),));
         }
       },
       child: Container(
         margin: const EdgeInsets.all(3),
         decoration: const BoxDecoration(
             color: primaryColor,
             shape: BoxShape.rectangle,
             borderRadius: BorderRadius.all(Radius.circular(10))),
         child: Center(
           child: Padding(
             padding: const EdgeInsets.all(6.0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 //Icon(Icons.category),
                 Image.network(
                   controller.parentCategories[index].image ?? MyConstant.banner_image,
                   height: 35,
                 ),
                 const SizedBox(
                   height: 6,
                 ),
                 RegularTextView(
                   text: controller.parentCategories[index].name ?? "",
                   textSize: 14,
                   maxLine: 2,
                   textAlign: TextAlign.center,
                 ),
               ],
             ),
           ),
         ),
       ),
     );
   }
}
