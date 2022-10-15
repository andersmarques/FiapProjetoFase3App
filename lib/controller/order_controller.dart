import 'package:abctechapp/model/assist.dart';
import 'package:abctechapp/model/order.dart';
import 'package:abctechapp/model/order_created.dart';
import 'package:abctechapp/model/order_location.dart';
import 'package:abctechapp/services/geolocation_service.dart';
import 'package:abctechapp/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

enum OrderState { creating, started, finished }

class OrderController extends GetxController with StateMixin<OrderCreated> {
  final GeolocationServiceInterface _geolocationService;
  final OrderService _orderService;
  final formKey = GlobalKey<FormState>();
  final operatorIdController = TextEditingController();
  final selectedAssists = <Assist>[].obs;
  final screenState = OrderState.creating.obs;
  late Order _order;

  OrderController(this._geolocationService, this._orderService);

  @override
  void onInit() {
    super.onInit();
    _geolocationService.start();
    change(null, status: RxStatus.success());
  }

  OrderLocation orderLocationFromPosition(Position position) {
    return OrderLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        dateTime: DateTime.now());
  }

  List<int> servicesIdArrayFromServices() {
    return selectedAssists.map((element) => element.id).toList();
  }

  finishStartOrder() {
    switch (screenState.value) {
      case OrderState.creating:
        _geolocationService.getPosition().then((value) {
          var start = orderLocationFromPosition(value);

          _order = Order(
              operatorId: int.parse(operatorIdController.text),
              assists: servicesIdArrayFromServices(),
              start: start,
              end: null);
        });
        screenState.value = OrderState.started;
        break;
      case OrderState.started:
        change(null, status: RxStatus.loading());
        _geolocationService.getPosition().then((value) {
          var end = orderLocationFromPosition(value);

          _order.end = end;
          _createOrder();
        });

        break;
      default:
    }
  }

  void _createOrder() {
    screenState.value = OrderState.finished;
    _orderService.createOrder(_order).then((value) {
      if (value.success) {
        Get.snackbar("Sucesso", "Ordem de serviço criada com sucesso");
        clearForm();
      }
    }).catchError((error) {
      Get.snackbar("Erro", error.toString());
    });
  }

  void clearForm() {
    screenState.value = OrderState.creating;
    selectedAssists.clear();
    operatorIdController.text = "";
    change(null, status: RxStatus.success());
  }

  editAssists() {
    if (screenState.value != OrderState.creating) {
      return null;
    }
    Get.toNamed("/assists", arguments: selectedAssists);
  }
}