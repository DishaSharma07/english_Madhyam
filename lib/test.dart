import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Height Widgets with View More Example'),
        ),
        body: FeedList(),
      ),
    );
  }
}

class FeedList extends StatelessWidget {
  final List<String> items = List<String>.generate(10, (i) => i == 5 ? "Item $i\n" * 50 : "Item $i\n" * (i + 1));
  final List<GlobalKey> formKeyList = List<GlobalKey>.generate(10, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return FeedItem(
          content: items[index],
          formKey: formKeyList[index],
        );
      },
    );
  }
}

class FeedItem extends StatefulWidget {
  final String content;
  final GlobalKey formKey;

  FeedItem({required this.content, required this.formKey});

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  bool isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey[200],
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: LayoutBuilder(
              builder: (context, innerConstraints) {
                final TextSpan textSpan = TextSpan(
                  text: widget.content,
                  style: TextStyle(fontSize: 18),
                );

                final TextPainter textPainter = TextPainter(
                  text: textSpan,
                  textDirection: TextDirection.ltr,
                  maxLines: null,
                )..layout(maxWidth: innerConstraints.maxWidth);

                if (textPainter.size.height > innerConstraints.maxHeight && !isOverflowing) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!isOverflowing) {
                      setState(() {
                        isOverflowing = true;
                      });
                    }
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      key: widget.formKey,
                      children: [
                        Text(widget.formKey.currentContext?.size?.height.toString() ?? ''),
                        Text(
                          '2024-08-04',
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Sample Word',
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                          child: Column(
                            children: [
                              widget.content.isEmpty
                                  ? const SizedBox()
                                  : Wrap(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        child: Text("Meaning:  ",
                                            style: GoogleFonts.raleway(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Expanded(
                                        child: Text(widget.content,
                                            style: GoogleFonts.raleway(
                                              fontSize: 16,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 18),
                        maxLines: isOverflowing ? 5 : null,
                        overflow: isOverflowing ? TextOverflow.ellipsis : TextOverflow.visible,
                      ),
                    ),
                    if (isOverflowing)
                      Container(
                        width: double.infinity,
                        color: Colors.red,
                        child: Center(
                          child: Text("View More", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
