import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/categoryEditorial.dart';
import 'package:english_madhyam/src/helper/model/editorial_detail_model/editorial_detail.dart';
import 'package:english_madhyam/src/helper/model/meaning_list.dart';
import 'package:english_madhyam/src/helper/model/meaning_model.dart';
import 'package:english_madhyam/src/helper/providers/editorial_detail_prov/editorial_detail_prov.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/screen/editorials_page/player_state.dart';
import 'package:english_madhyam/src/utils/converter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../screen/editorials_page/editorials_details.dart';

class EditorialDetailController extends GetxController {
  var loading = false.obs;
  var meaningloading = false.obs;
  var editorials=EditorialDetailsModel().obs;
  Rx<MeaningModel>meaning=MeaningModel().obs;
  var Cateditorials=EditorialCat().obs;
  final HtmlConverter _htmlConverter = HtmlConverter();
  ScrollController readingController=ScrollController();
  Rx<PageManager>pageManager=PageManager().obs;
   // final PageManager pageManager= PageManager();
  // PageManager _pageManager=PageManager();
Rx<EditorialCat>_editorialCat=EditorialCat().obs;
  int pages = 1;
  var editorialByCat = List<dynamic>.empty(growable: true).obs;
  Rx<MeaningList> meaningListModel=MeaningList().obs;
  Rx<double>position=0.0.obs;
  RxInt editid = 0.obs;
  RxInt categoryid = 0.obs;
  RxString resultString= "".obs;
  RxList newword = [].obs;
  List<Description>descritionColorlist=[];
  RxBool notadded = false.obs;
  String desc="";
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;


  @override
  void onInit() async {
    super.onInit();

  }
  @override
  void dispose() {

    pageManager.value.dispose();

    super.dispose();
  }
  void editorialid(int id){
    if(id!=null){
      editid.value=id;
    }
  }
  //cat id
  void categoryId(int id){
    if(id!=null){
      categoryid.value=id;
    }
  }
  void getTask(int page,int id) {
    try {
      pages=page;
      isMoreDataAvailable(false);
      isDataProcessing(true);
      EditorialDetailProvider().getEditorialDetailsByCat(cat_id: id.toString(),page: page.toString()).then((resp) {
        if(resp!.result==true){
          isDataProcessing(false);
          editorialByCat.addAll(resp.editorials!.data!);_editorialCat.value=resp;
          paginateTask();
        }else{
          isDataProcessing(false);
          isMoreDataAvailable(false);
        }

        Cateditorials.value=resp;

      }, onError: (err) {
        isDataProcessing(false);
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (exception) {
      isDataProcessing(false);
      // showSnackBar("Exception", exception.toString(), Colors.red);
    }
  }

  void paginateTask() {
    readingController.addListener(() {
      if (readingController.position.pixels ==
          readingController.position.maxScrollExtent) {
        if(Cateditorials.value.editorials!.lastPage!>Cateditorials.value.editorials!.currentPage!.toInt()){

          pages++;
        getMoreTask(pages,categoryid.value);
      }else{

        }
    }});
  }
  void getMoreTask(int pageCount,int id) {
    isDataProcessing(true);
    try {
      if(Cateditorials.value.editorials!.total!>editorialByCat.length){
        EditorialDetailProvider().getEditorialDetailsByCat(cat_id: id.toString(),page: pages.toString())
            .then((resp) {

            if(resp!.result==true){
              if (resp.editorials!.data!.isNotEmpty) {

                editorialByCat.addAll(resp.editorials!.data!);
                isMoreDataAvailable(false);
                isDataProcessing(false);

              } else {
                isMoreDataAvailable(false);
                isDataProcessing(false);

              }

            }else{
              isMoreDataAvailable(false);
              isDataProcessing(false);
              pages--;
            }


        }, onError: (err) {
          isMoreDataAvailable(false);
          isDataProcessing(false);
        });
      }else{
        isDataProcessing(false);
        isMoreDataAvailable(false);
      }
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }


  // void quizzesList()async {
  //   try{
  //     loading(true);
  //     var response=await QuizListProvider().getQuizList(type:"editorial",editorial_id:editid.value);
  //     print("response   ... .... ...${response}");
  //     if(response!=null){
  //       quizList.value=response;
  //       print("LENGTH   ==  ${quizList.value.content!.length}");
  //     }else {
  //       return null;
  //     }
  //
  //   }catch(e){
  //     print(e);
  //   }   finally{
  //     loading(false);
  //   }
  // }
//Word Meaning Individual
  void wordMeaning({required String word,required String eId}) async {

    try {
      meaningloading(true);
      var response = await EditorialDetailProvider().wordmeaning(word: word,Id: eId);
      if (response != null) {
            meaning.value = response;
            meaning.value.word = word;
            meaningloading(false);


          update();
      } else {
      }
    } catch (e) {
    } finally {
      meaningloading(false);
    }
  }

// decription function
  void descriptionColor({required List<Editorials> meaninglist}){
    descritionColorlist.clear();
      // notadded(false);
    if(meaninglist.isNotEmpty){
      for(int j=0;j<newword.value.length;j++){
        notadded(false);
        resultString.value = newword.value[j].replaceAll(',','').toString();
        resultString.value=resultString.value.replaceAll('.', '');
        resultString.value=resultString.value.replaceAll(';', '').toString().trim();
        for(int i=0;i<meaninglist.length;i++){
          if(meaninglist[i].word==resultString.value){
            descritionColorlist.add(Description(word: newword.value[j], status: true));
            notadded(true);
            break;
          }
        }
        //i ends
        if(notadded.value == false){
          descritionColorlist.add(Description(word: newword.value[j], status: false));
        }
      }
    }
  }



  //
  void editorialDetailsFetch({String?id }) async {
    try {
      loading(true);

      var response = await EditorialDetailProvider().getEditorialDetails(course_id: id!.toString());

      if (response != null) {
        editorials.value=response;


          desc=
              editorials.value.editorialDetails!.description!.replaceAll('&nbsp;', ' ');



          newword.value =  _htmlConverter.parseHtmlString(
              desc).split(" ");
        meaningListModel.value.result == true
            ? descriptionColor(
            meaninglist:
            meaningListModel.value.editorials!)
            : null;
        Future.delayed(const Duration(milliseconds: 2),(){});
        if(editorials.value.editorialDetails!.audio!.isNotEmpty){
          pageManager.value.init(
              url: editorials.value.editorialDetails!.audio![0].file!);
        }

          update();

      }
    } on NetworkException{
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();

    } finally {
      loading(false);
      update();
    }
  }
  //editorial details by category
  // void editorialCatFetch({String?id ,required String page}) async {
  //   try {
  //     loading(true);
  //
  //     var response = await EditorialDetailProvider().getEditorialDetailsByCat(cat_id: id!.toString(),page: 1.toString());
  //
  //     // print("__+_+_++__${response!.result!}");
  //     if (response != null) {
  //       Cateditorials.value=response;
  //
  //       update();
  //     }
  //   } on NetworkException {
  //     Fluttertoast.showToast(
  //         msg: "Please check your internet connection and retry");
  //     cancel();
  //
  //   } finally {
  //     loading(false);
  //   }
  // }

  //start Exam
  void meaningList({required String id})async {
    try{
      loading(true);
      var response=await EditorialDetailProvider().wordMeaningList(id: id);
      if(response!=null){
        meaningListModel.value=response;
        if(meaningListModel.value.result==true){
          editorialDetailsFetch(id: id);
        }else{
          editorialDetailsFetch(id: id);
        }
      }else {
        return null;
      }
    }catch(e){
    }   finally{
      loading(false);
    }
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
