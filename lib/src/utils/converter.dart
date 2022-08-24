import 'package:html/parser.dart';
import 'package:html/dom.dart'as dom;
class HtmlConverter{

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }
  String parseHtmlString(String htmlString) {
    final String d="kjfdjhd";
    dom.Node node;
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}