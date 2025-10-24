
 
 
class ImagesModel {
	int? imageId;
	String? imagePath;
	int? productsId;

	ImagesModel({this.imageId,this.imagePath,this.productsId});

	factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(imageId: json['imageId'],imagePath: json['imagePath'],productsId:json['productsId'] );
  }
}
