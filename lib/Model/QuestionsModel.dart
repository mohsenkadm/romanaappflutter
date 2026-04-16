// ignore_for_file: non_constant_identifier_names

class QuestionsModel{  
  final int questionId; 
  final String questionText; 
  final String answerText;
  final bool isShow;
  final int displayOrder;

  QuestionsModel({
    required this.questionId,
    required this.questionText,
    required this.answerText,
    required this.isShow,
    required this.displayOrder,
  });

  factory QuestionsModel.fromJson(Map<String, dynamic> json){
    return QuestionsModel(
      questionId: json['questionId'] ?? 0,
      questionText: json['questionText'] ?? '',
      answerText: json['answerText'] ?? '',
      isShow: json['isShow'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'answerText': answerText,
      'isShow': isShow,
      'displayOrder': displayOrder,
    };
  }
}