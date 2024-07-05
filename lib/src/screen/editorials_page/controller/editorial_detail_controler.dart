import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/categoryEditorial.dart';
import 'package:english_madhyam/resrc/models/model/editorial_detail_model/editorial_task_model.dart';
import 'package:english_madhyam/resrc/models/model/meaning_list.dart';
import 'package:english_madhyam/resrc/models/model/meaning_model.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/player_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../resrc/models/model/editorial_detail_model/editorial_detail.dart';
import '../../../chatGpt/model/chatGptModel.dart';
import '../../pages/page/converter.dart';
import 'package:english_madhyam/storage/cache_manager.dart';


class EditorialDetailController extends GetxController with CacheManager {
  var loading = false.obs;
  var meaningLoading = false.obs;
  var editorials = EditorialDetailsModel().obs;
  Rx<MeaningModel> meaning = MeaningModel().obs;
  var cateditorialModel = EditorialCat().obs;
  final HtmlConverter _htmlConverter = HtmlConverter();
  ScrollController readingController = ScrollController();
  Rx<PageManager> pageManager = PageManager().obs;
  var _editorialCat = EditorialCat().obs;
  int pages = 1;
  var editorialByCat = List<dynamic>.empty(growable: true).obs;
  Rx<MeaningList> meaningListModel = MeaningList().obs;
  Rx<double> position = 0.0.obs;
  RxInt editid = 0.obs;
  RxInt categoryid = 0.obs;
  RxString resultString = "".obs;
  RxList newword = [].obs;
  List<EditorialDescription> descritionColorlist = [];
  RxBool notadded = false.obs;
  String desc = "";
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  List<TextCompletionData> messages = [];
  List<EditorialDescription> readingData=[];

  @override
  void onInit() async {
    super.onInit();

  }

  @override
  void dispose() {
    pageManager.value.dispose();

    super.dispose();
  }

  void editorialid(int id) {
    if (id != null) {
      editid.value = id;
    }
  }

  //cat id
  void categoryId(int id) {
    if (id != null) {
      categoryid.value = id;
    }
  }

  void getTask(int page, int id) {
    try {
      pages = page;
      isMoreDataAvailable(false);
      isDataProcessing(true);
      apiService
          .getEditorialDetailsByCat(catId: id.toString(), page: page.toString())
          .then((resp) {
        if (resp!.result == true) {
          isDataProcessing(false);
          editorialByCat.addAll(resp.editorials!.data!);
          _editorialCat.value = resp;
          paginateTask();
        } else {
          isDataProcessing(false);
          isMoreDataAvailable(false);
        }

        cateditorialModel.value = resp;
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
        if (cateditorialModel.value.editorials!.lastPage! >
            cateditorialModel.value.editorials!.currentPage!.toInt()) {
          pages++;
          getMoreTask(pages, categoryid.value);
        } else {}
      }
    });
  }

  void getMoreTask(int pageCount, int id) {
    isDataProcessing(true);
    try {
      if (cateditorialModel.value.editorials!.total! > editorialByCat.length) {
        apiService
            .getEditorialDetailsByCat(
                catId: id.toString(), page: pages.toString())
            .then((resp) {
          if (resp!.result == true) {
            if (resp.editorials!.data!.isNotEmpty) {
              editorialByCat.addAll(resp.editorials!.data!);
              isMoreDataAvailable(false);
              isDataProcessing(false);
            } else {
              isMoreDataAvailable(false);
              isDataProcessing(false);
            }
          } else {
            isMoreDataAvailable(false);
            isDataProcessing(false);
            pages--;
          }
        }, onError: (err) {
          isMoreDataAvailable(false);
          isDataProcessing(false);
        });
      } else {
        isDataProcessing(false);
        isMoreDataAvailable(false);
      }
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }

//Word Meaning Individual
  void wordMeaning({required String word, required String eId}) async {
    try {
      meaningLoading(true);
      var response = await apiService.wordMeaning(word: word, id: eId);
      if (response != null) {
        meaning.value = response;
        meaning.value.word = word;
        meaningLoading(false);

        update();
      } else {}
    } catch (e) {
    } finally {
      meaningLoading(false);
    }
  }


  void wordMeaningChatGpt({required String word, required String eId}) async {
    try {

      Map<String, String> rowParams = {
        "model": "text-davinci-003",
        "prompt": word,
      };
      meaningLoading(true);
      var response = await apiService.wordMeaningGpt(body: rowParams);
      if (response != null) {
        addServerMessage(response.choices);
        meaningLoading(false);
        update();
      } else {}
    } catch (e) {
    } finally {
      meaningLoading(false);
    }
  }
  addServerMessage(List<TextCompletionData> choices) {
    for (int i = 0; i < choices.length; i++) {
      messages.insert(i, choices[i]);
    }
  }

// decription function
  void descriptionColor({ List<Editorials>? meaninglist}) {
    descritionColorlist.clear();
    // notadded(false);
      for (int j = 0; j < newword.value.length; j++) {
        notadded(false);
        resultString.value = newword.value[j].replaceAll(',', '').toString();
        resultString.value = resultString.value.replaceAll('.', '');
        resultString.value =
            resultString.value.replaceAll(';', '').toString().trim();
       if(meaninglist!=null&&meaninglist.isNotEmpty){
         for (int i = 0; i < meaninglist.length; i++) {
           if (meaninglist[i].word == resultString.value) {
             descritionColorlist
                 .add(EditorialDescription(word: newword.value[j], status: true));
             notadded(true);
             break;
           }
         }
       }
        //i ends
        if (notadded.value == false) {
          descritionColorlist
              .add(EditorialDescription(word: newword.value[j], status: false));

      }
    }
  }

  //
  void editorialDetailsFetch({String? id}) async {
    try {
      loading(true);

      var response =
          await apiService.getEditorialDetails(courseId: id!.toString());
        loading(false);
      if (response != null) {
        editorials.value = response;

        desc = editorials.value.editorialDetails!.description!
            .replaceAll('&nbsp;', ' ');

        newword.value = _htmlConverter.parseHtmlString(desc).split(" ");
        readingData= getEditorialDescriptions(editorials.value.editorialDetails!.id.toString());

        if(readingData.isNotEmpty){
          descritionColorlist=readingData;
        }else{
          descriptionColor(meaninglist: meaningListModel.value.editorials);

        }
        Future.delayed(const Duration(milliseconds: 2), () {});
        if (editorials.value.editorialDetails!.audio!.isNotEmpty) {
          pageManager.value
              .init(url: editorials.value.editorialDetails!.audio![0].file!);
        }

        update();
      }
    } catch (e) {
      loading(false);
    }
  }

  void meaningList({required String id}) async {
    try {
      loading(true);
      var response = await apiService.wordMeaningList(id: id);
      loading(false);
      if (response != null) {
        meaningListModel.value = response;

          editorialDetailsFetch(id: id);



        // if (meaningListModel.value.result == true) {
        // } else {
        //   editorialDetailsFetch(id: id);
        // }
      } else {
        return null;
      }
    } catch (e) {
      loading(false);

    } finally {
      loading(false);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
