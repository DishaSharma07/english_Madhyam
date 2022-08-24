import 'package:english_madhyam/src/helper/model/cms.dart';
import 'package:english_madhyam/src/helper/providers/cms_prov.dart';
import 'package:get/get.dart';

class CMSSController extends GetxController{
  RxBool loading =false.obs;
  Rx<CMSPAGES>CmsDAta=CMSPAGES().obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    CmssPagesController();

  }

  void CmssPagesController()async {
    try{
      loading(true);
      var response=await CmssProvider().CmsPages();
      if(response!=null){
        CmsDAta.value=response;
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }


}