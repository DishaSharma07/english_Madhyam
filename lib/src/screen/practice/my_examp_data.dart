class MyExamData {
  String? questionId;
  String? isAttempt;
  MyOptionData? myOptionData;
  MyExamData(this.questionId, this.isAttempt, this.myOptionData);
}

class MyOptionData {
  String? selectedOptionId;
  String? checked;
}
