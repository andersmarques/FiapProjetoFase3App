

import 'package:abctechapp/constants.dart';
import 'package:get/get_connect.dart';

abstract class AssistProviderInterface{
  Future<Response> getAssists();
}

class AssistProvider extends GetConnect implements AssistProviderInterface{
  @override
  Future<Response> getAssists() => get('${Constants.url}/assistance');
}