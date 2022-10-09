import 'package:abctechapp/model/assist.dart';
import 'package:abctechapp/services/assist_service.dart';
import 'package:get/get.dart';

class AssistController extends GetxController with StateMixin<List<Assist>>{
  
  late AssistService _service;
  
  @override
  void onInit(){
    super.onInit();
    change([], status: RxStatus.empty());
    _service = Get.find<AssistService>();
  }

  void getAssistList(){
    change([], status: RxStatus.loading());
    _service.getAssists()
          .then((value) => change(value, status:RxStatus.success()))
          .onError((error, stackTrace) => 
            change([], status: RxStatus.error(error.toString())));
  }
}