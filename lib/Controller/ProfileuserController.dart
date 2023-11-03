import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';

class ProfileuserController extends GetxController{
 
  final user = Rxn<UsersModel>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  Future<void> fetchData() async { 
    final box= GetStorage(); 
    user.value=UsersModel(UserId: box.read('UserId'), Name: box.read('Name'), 
    Phone: box.read('Phone'), Address: box.read('Address'), FunctionPoint: box.read('FunctionPoint'));
  
  }
}