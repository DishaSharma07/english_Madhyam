import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/helper/model/feed_model/feed_model.dart';
import 'package:english_madhyam/src/helper/model/graph_data/graph_data_model.dart';
import 'package:english_madhyam/src/helper/model/home_model/home_model.dart';
import 'package:english_madhyam/src/helper/providers/feed_providers/feed_prov..dart';
import 'package:english_madhyam/src/helper/providers/graph_data_prov/graph_data_prov.dart';
import 'package:english_madhyam/src/helper/providers/home_providers/task_provider.dart';
import 'package:english_madhyam/src/network/NetworkException.dart';
import 'package:english_madhyam/src/network/http.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GraphDataController extends GetxController {
  var loading = true.obs;
  Rx<GraphData> graphdata=GraphData().obs;
  Rx<double> percentage=0.0.obs;


  @override
  void onInit() async {

    super.onInit();
  }



  //
  Future<void> graphDataFetch({required String examid}) async {
    try {
      loading.value=true;
      var response = await GraphDataProv().graphData(examid:examid );
      if (response != null) {
        graphdata.value=response ;
        pieChart();
        update();
        return;
      }
    } on NetworkException {
      Fluttertoast.showToast(
          msg: "Please check your internet connection and retry");
      cancel();

    } finally {
      loading.value=false;
    }
  }

  double pieChart(){
   int unanswered = (
        graphdata.value.content!.totalQuestion! -
        graphdata.value.content!.skipQuestion!);
   percentage.value = (unanswered /
       graphdata.value.content!.totalQuestion!) *
        100;

    return percentage.value;
  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
