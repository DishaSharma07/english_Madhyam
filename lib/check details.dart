// // import 'package:lottie/lottie.dart';
// // import 'package:english_madhyam/src/utils/colors/colors.dart';
// // import 'package:get/get.dart';
// // import 'package:english_madhyam/src/helper/controllers/editorial_detail_controller/editorial_detail_controler.dart';
// // import 'package:english_madhyam/src/helper/model/meaning_model.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/gestures.dart';
// // import 'package:flutter/material.dart';
// //
// // import 'src/helper/providers/editorial_detail_prov/editorial_detail_prov.dart';
// //
// // class SelectableTextScreen extends StatefulWidget {
// //   @override
// //   _SelectableTextScreenState createState() => _SelectableTextScreenState();
// // }
// //
// // class _SelectableTextScreenState extends State<SelectableTextScreen> {
// //   String word = "The city is essentially being destroyed ruthlessly block by block,&rdquo; Oleksandr Striuk said. He said heavy street fighting continued and artillery barrages threatened the lives of the estimated 13,000 civilians still sheltering in the ruined city that once was home to more than 100,000";
// //   List<String> newword= [];
// // bool load = false;
// //   var meaning = "";
// //   MeaningModel meaningModel = MeaningModel();
// //
// // void wordMeaning({required String word}) async {
// //     try {
// //       setState(() {
// //         load = true;
// //       });
// //       var response = await EditorialDetailProvider().wordmeaning(word: word);
// //       if (response != null) {
// //         if (response.vocab != null) {
// //           setState(() {
// //             meaningModel = response;
// //             meaningModel.word=word;
// //
// //
// //             load = false;
// //           });
// //           print(response);
// //         } else {
// //           setState(() {
// //             meaningModel = response;
// //             load = false;
// //           });
// //         }
// //       } else {
// //         return null;
// //       }
// //     } catch (e) {
// //       print(e);
// //     } finally {}
// //   }
// //
// // final EditorialDetailController _detailController = Get.put(EditorialDetailController());
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     newword = word.split(" ");
// //     print(newword);
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Text("zxcz"),
// //       ),
// //       body: Center(
// //         child:Text.rich(
// //             TextSpan(
// //                 children: <InlineSpan>[
// //                   for(int i=0;i<newword.length;i++)
// //                     TextSpan(
// //                         text: newword[i].toString()+" ",
// //                         style: TextStyle(
// //                             wordSpacing: 15.0,
// //                             fontSize: 25),
// //                       recognizer: TapGestureRecognizer()..onTap = (){
// //                         _detailController.wordMeaning(word: newword[i]);
// //                         showDialog(
// //                             context: context,
// //                             builder: (BuildContext context) {
// //                               return AlertDialog(
// //                                 content: Obx((){
// //                     if(_detailController.meaningloading.value){
// //                       return SizedBox(
// //                         child: Lottie.asset(
// //                           "assets/animations/loader.json",
// //                           height: 150,
// //                           width: 150,
// //                         ),
// //                       );
// //                               }
// //                     else if(_detailController.meaning.value.vocab==null){
// //                       return Container(
// //                         padding: const EdgeInsets.all(4),
// //                         decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(5)),
// //                         child: Text("No meaning available",
// //
// //                         ),
// //                       );
// //                      }
// //                     else{
// //                       return  Text(
// //                         "${_detailController.meaning.value.word.toString()}: ${_detailController.meaning.value.vocab.toString()}",
// //                         );
// //                       }
// //                       }),
// //
// //                               );
// //                             }
// //                         );
// //                       }
// //
// //                     )
// //                 ]
// //             )
// //         ),
// //       ),
// //     );
// //   }
// //
// // }
//
//
// // ignore_for_file: prefer_const_constructors
//
// import 'package:english_madhyam/src/utils/colors/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class ThemeTest extends StatefulWidget {
//   const ThemeTest({Key? key}) : super(key: key);
//
//   @override
//   State<ThemeTest> createState() => _ThemeTestState();
// }
//
// class _ThemeTestState extends State<ThemeTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(onPressed: (){
//             Get.isDarkMode
//                 ? Get.changeTheme(ThemeData.light())
//                 : Get.changeTheme(ThemeData.dark());
//           }, icon: Icon(Icons.image))
//         ],
//       ),
//       body: Column(
//         children: [
//           Text("jasdausdavdsi",style: TextStyle(
//             color: correctColor
//           ),),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           Text("jasdausdavdsi"),
//           ElevatedButton(onPressed: (){}, child: Text("dchsgdvchd"),
//           style: ElevatedButton.styleFrom(
//             primary: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//           ElevatedButton(onPressed: (){}, child: Text("dchsgdvchd")),
//           ElevatedButton(onPressed: (){}, child: Text("dchsgdvchd")),
//         ],
//       ),
//     );
//   }
// }
