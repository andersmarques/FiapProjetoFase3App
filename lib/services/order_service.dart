import 'package:abctechapp/model/order.dart';
import 'package:abctechapp/model/order_created.dart';
import 'package:abctechapp/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OrderServiceInterface {
  Future<OrderCreated> createOrder(Order order);
}

class OrderService extends GetxService implements OrderServiceInterface {
  final OrderProviderInterface _orderProviderInterface;
  OrderService(this._orderProviderInterface);

  @override
  Future<OrderCreated> createOrder(Order order) async {

    try {  
      Response response = await _orderProviderInterface.postOrder(order);
      if (response.hasError) {
        //return Future.error(ErrorDescription("Erro na conexao"));
        return Future.sync(() => OrderCreated(false, "Erro na conexao"));
      }

      return Future.sync(() => OrderCreated(true, ""));
    } catch (e) {
      e.printError();
      return Future.error(ErrorDescription("Erro não esperado"));
    }
  }
}