 class CarouselModel{ int? carouseId;
    final String image;
    final String url;
    final bool isShow;

    CarouselModel({
      required
    this.carouseId, required
    this.image,required
     this.url,required
      this.isShow}); 

    factory CarouselModel.fromJson(Map<String, dynamic> json) {
      return CarouselModel(
        carouseId : json['carouseId'],
        image : json['image'],
        url : json['url'],
        isShow : json['isShow']);
    }
 }