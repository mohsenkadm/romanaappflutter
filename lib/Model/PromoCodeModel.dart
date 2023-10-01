class PromoCodeModel{
  final int PromoCodeId;
  final String PromoName;
  final int Percentage;
  PromoCodeModel({
    required this.PromoCodeId,required this.PromoName,required this.Percentage
  });

  factory PromoCodeModel.fromJson(Map<String,dynamic> json){
   return PromoCodeModel(PromoCodeId: json['promoCodeId'],
    PromoName: json['promoName'], Percentage: json['percentage']);
  }
}