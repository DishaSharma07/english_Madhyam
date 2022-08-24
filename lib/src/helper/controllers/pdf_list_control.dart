import 'package:english_madhyam/src/helper/model/cms.dart';
import 'package:english_madhyam/src/helper/model/pdf_list_model.dart';
import 'package:english_madhyam/src/helper/model/youtube_list.dart';
import 'package:english_madhyam/src/helper/providers/cms_prov.dart';
import 'package:english_madhyam/src/helper/providers/individual_pdf.dart';
import 'package:english_madhyam/src/helper/providers/video_list_prov.dart';
import 'package:get/get.dart';

class PdfController extends GetxController{
  RxBool loading =false.obs;
  Rx<PdfList>pdfList=PdfList().obs;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // pdf_listController();
  }

  void pdf_listController({required String type,required String id})async {
    try{
      loading(true);
      var response=await PDFProvider().pdflistProv(type: type,id: id);
      if(response!=null){
        pdfList.value=response;
      }else {
        return null;
      }

    }catch(e){
    }   finally{
      loading(false);
    }
  }


}