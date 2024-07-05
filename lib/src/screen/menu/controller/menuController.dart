import 'package:get/get.dart';
import '../../../commonController/authenticationController.dart';


class CustomMenuController extends GetxController {
  //late final GuideController guideController;
  var loading=false.obs;
  var contentLoading=false.obs;
  var menuMenuList = <MenuItem>[].obs;
  final AuthenticationManager authenticationManager = Get.find();

  @override
  void onInit() {
    super.onInit();
    getChildMenu();
  }
  Future<void> getChildMenu() async {
    /*menuMenuList.add(MenuItem.createItem(
        title: "Settings", iconUrl: "assets/icon/shield.svg"));*/

    menuMenuList.add(MenuItem.createItem(
        title: "Extend Validity", iconUrl: "assets/icon/shield.svg"));

   /* menuMenuList.add(MenuItem.createItem(
        title: "Contact Us", iconUrl: "assets/icon/Calling.svg"));*/
    menuMenuList.add(MenuItem.createItem(
        title: "About us", iconUrl: "assets/icon/Document_fill.svg"));
    menuMenuList.add(MenuItem.createItem(
        title: "Terms & Condition", iconUrl: "assets/icon/Info Circle.svg"));
    menuMenuList.add(MenuItem.createItem(
        title: "Privacy Policy", iconUrl: "assets/icon/shield.svg"));

  }
}
class MenuItem{
  String? title;
  String? iconUrl;
  MenuItem.createItem({required this.title,required this.iconUrl});
}
