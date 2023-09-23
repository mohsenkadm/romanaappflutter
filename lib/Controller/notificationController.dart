import 'package:get/get.dart';
import 'package:romanaappflutter/Model/NotifModel.dart';

class notificationController extends GetxController{

   var items=[].obs;
  RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }

  Future<void> fetchData() async {
    isloded.value=true;
    await Future.delayed(Duration(seconds: 2));
     items.add(NotifModel("Item 1", "Description 1 Description 1 Description 1 Description 1 Description 1 Description 1"
    ,DateTime.now().toString(), "assets/images/img1.png"));
    items.add(NotifModel("Item 2", "Description 2",DateTime.now().toString(), "assets/images/img2.png"));
    items.add(NotifModel("Item 3", "Description 4",DateTime.now().toString(),  "assets/images/img3.png"));
   items.add( NotifModel("Item 3", "Description 3",DateTime.now().toString(),  "assets/images/img3.png"));
   items.add( NotifModel("Item 3", "Description 3",DateTime.now().toString(),  "assets/images/img3.png"));
   items.add( NotifModel("Item 3", "Description 3",DateTime.now().toString(),  "assets/images/img3.png"));
  items.add(  NotifModel("Item 3", "Description 3",DateTime.now().toString(),  "assets/images/img3.png"));
  isloded.value=false;
  }
}