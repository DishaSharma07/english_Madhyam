class EditingModel{
  List<SelectionInfo> selectionInfo;
  EditingModel({required this.selectionInfo});
}
class SelectionInfo{
  int startingPoint;
  int endingPoint;
  SelectionInfo({required this.endingPoint,required this.startingPoint});
}