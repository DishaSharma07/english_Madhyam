import 'package:english_madhyam/src/helper/model/cms.dart';
import 'package:english_madhyam/src/helper/model/video_cat_model.dart';
import 'package:english_madhyam/src/helper/model/youtube_list.dart';
import 'package:english_madhyam/src/helper/providers/cms_prov.dart';
import 'package:english_madhyam/src/helper/providers/video_list_prov.dart';
import 'package:get/get.dart';

class VideoController extends GetxController{
  RxBool loading =false.obs;
  RxBool catloading =false.obs;
  Rx<YoutubeListModel>videoList=YoutubeListModel().obs;
  Rx<VideoCategoriesModel>videoListCat=VideoCategoriesModel().obs;
  var videoCat=List<dynamic>.empty(growable: true).obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    video_catController();

  }

  void video_listController({required String id})async {
    try{
      loading(true);
      var response=await VideoListProvider().videolistPro(id: id,);
      if(response!=null){

        videoList.value=response;

      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }
  void video_catController()async {
    try{
      catloading(true);
      var response=await VideoListProvider().videoCatPro("1");
      if(response!=null){
        videoListCat.value=response;
        // if(videoCat.isEmpty){
        //   videoCat.addAll(response.categories!);
        //
        // }else if(videoCat[0]==response.videos![0]){
        //   loading(false);
        //
        // }else{
        //   videoCat.addAll(response.videos!);
        //
        // }
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      catloading(false);
    }
  }


}