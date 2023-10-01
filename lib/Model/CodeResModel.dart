class CodeResModel {
  final int codeResId;
  final String code;
  final bool isFree;

  CodeResModel({required this.codeResId,required this.code,
  required this.isFree});

	factory CodeResModel.fromJson(Map<String, dynamic> json) {
    return CodeResModel(codeResId: json['codeResId'],code: json['code'],
    isFree: json['isFree']);
  }
}