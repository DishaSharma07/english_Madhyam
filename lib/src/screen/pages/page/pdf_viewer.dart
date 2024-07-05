import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewer extends StatefulWidget {
  final String link;
  final String title;

  const PdfViewer({Key? key, required this.link,required this.title}) : super(key: key);
  @override
  _PdfViewer createState() => _PdfViewer();
}

class _PdfViewer extends State<PdfViewer> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: purpleColor,
        title:ToolbarTitle(title: widget.title,),
      ),
      body:SfPdfViewer.network(
        widget.link,
      ),
    );
  }
}