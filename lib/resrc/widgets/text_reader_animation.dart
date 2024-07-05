import 'package:flutter/material.dart';





GlobalKey _keyT1 = GlobalKey();
GlobalKey _keyT2 = GlobalKey();
GlobalKey _keyT3 = GlobalKey();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late  AnimationController animationController1;
  late AnimationController animationController2;
  late AnimationController animationController3;
  double _aniWidth = 8.0;
  AlignmentDirectional _alignm1 = AlignmentDirectional.centerStart;
  double _text1Width = 0.0;
  double _text2Width = 0.0;
  double _text3Width = 0.0;
  bool _text1Visiblity = false;
  bool _text2Visiblity = false;
  bool _text3Visiblity = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    animationController1 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController3 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    animation1 = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: animationController1,
      curve: Curves.fastOutSlowIn,
    ))
      ..addStatusListener(handler1);

    animation2 = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: animationController2,
      curve: Curves.fastOutSlowIn,
    ))
      ..addStatusListener(handler2);

    animation3 = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: animationController3,
      curve: Curves.fastOutSlowIn,
    ))
      ..addStatusListener(handler3);
  }

  _afterLayout(_) {
    _getSizes();
  }

  _getSizes() {
    _text1Width = _keyT1.currentContext!.size!.width;
    _text2Width = _keyT2.currentContext!.size!.width;
    _text3Width = _keyT3.currentContext!.size!.width;
    print("width of Red: $_text1Width $_text2Width $_text3Width");
    animationController1.forward();
  }

  void handler1(status) {
    if (status == AnimationStatus.forward) {
      setState(() {
        _text1Visiblity = true;
        _aniWidth = _text1Width * 0.3;
        _alignm1 = AlignmentDirectional.centerEnd;
      });
    } else if (status == AnimationStatus.completed) {
      setState(() {
        _text1Visiblity = false;
        _aniWidth = 3.0;
        animationController1.reset();
        animationController2.forward();
      });
    }
  }

  void handler2(status) {
    if (status == AnimationStatus.forward) {
      setState(() {
        _text2Visiblity = true;
        _aniWidth = _text3Width * 0.3;
        _alignm1 = AlignmentDirectional.centerEnd;
      });
    } else if (status == AnimationStatus.completed) {
      setState(() {
        _text2Visiblity = false;
        _aniWidth = 3.0;
        animationController2.reset();
        animationController3.forward();
      });
    }
  }

  void handler3(status) {
    if (status == AnimationStatus.forward) {
      setState(() {
        _text3Visiblity = true;
        _aniWidth = 35.0;
        _alignm1 = AlignmentDirectional.centerEnd;
      });
    } else if (status == AnimationStatus.completed) {
      setState(() {
        _text3Visiblity = false;
        _aniWidth = 3.0;
        animationController3.reset();
        animationController1.forward();
      });
    }
  }

  @override
  void dispose() {
    animationController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Animation Experiment',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: 100,
        margin: EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext ctx,int index){
          return ReaderAnimation(
            globalKey: GlobalKey(),
            animationController: animationController1,
            animation: animation1,
            alignmentDirectional: _alignm1,
            aniWidth: _aniWidth,
            textString: "Text",
            textVisibility: _text1Visiblity,
            textWidth: _text1Width,
          );

        }),
        // child: Row(
        //   children: <Widget>[
        //     ReaderAnimation(
        //       globalKey: UniqueKey(),
        //       animationController: animationController1,
        //       animation: animation1,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Text",
        //       textVisibility: _text1Visiblity,
        //       textWidth: _text1Width,
        //     ),
        //     ReaderAnimation(
        //       globalKey: UniqueKey(),
        //       animationController: animationController2,
        //       animation: animation2,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Reader",
        //       textVisibility: _text2Visiblity,
        //       textWidth: _text2Width,
        //     ),
        //     ReaderAnimation(
        //       globalKey: UniqueKey(),
        //       animationController: animationController3,
        //       animation: animation3,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Animationss",
        //       textVisibility: _text3Visiblity,
        //       textWidth: _text3Width,
        //     ),ReaderAnimation(
        //       globalKey: UniqueKey(),
        //       animationController: animationController3,
        //       animation: animation3,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Animation",
        //       textVisibility: _text3Visiblity,
        //       textWidth: _text3Width,
        //     ),ReaderAnimation(
        //       globalKey: _keyT3,
        //       animationController: animationController3,
        //       animation: animation3,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Animation",
        //       textVisibility: _text3Visiblity,
        //       textWidth: _text3Width,
        //     ),ReaderAnimation(
        //       globalKey: _keyT3,
        //       animationController: animationController3,
        //       animation: animation3,
        //       alignmentDirectional: _alignm1,
        //       aniWidth: _aniWidth,
        //       textString: "Animationsss",
        //       textVisibility: _text3Visiblity,
        //       textWidth: _text3Width,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
class ReaderAnimation extends StatelessWidget {
  final Key? globalKey;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final double? textWidth;
  final String textString;
  final double? aniWidth;
  final bool? textVisibility;
  final AlignmentDirectional alignmentDirectional;

  ReaderAnimation({
    Key? key,
    this.globalKey,
    this.animationController,
    this.animation,
    this.textWidth,
    required this.textString,
    this.aniWidth,
    this.textVisibility,
    required this.alignmentDirectional,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: globalKey,
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            textString,
            style: TextStyle(fontSize: 22),
          ),
        ),
        if (animationController != null && animation != null)
          AnimatedBuilder(
            animation: animationController!,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                left: animation!.value * (textWidth ?? 0),
                child: Visibility(
                  visible: textVisibility ?? true,
                  child: Container(
                    width: (textWidth ?? 0) * 0.5,
                    child: Stack(
                      alignment: alignmentDirectional,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.centerEnd,
                              end: AlignmentDirectional.centerStart,
                              stops: [0.1, 1.0],
                              colors: [
                                Colors.blueAccent[100]!,
                                Colors.white70,
                              ],
                            ),
                          ),
                          width: aniWidth ?? 0,
                          height: 50,
                        ),
                        Container(
                          width: 3,
                          height: 50.0,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
