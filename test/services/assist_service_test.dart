
import 'dart:convert';
import 'dart:io';

import 'package:abctechapp/model/assist.dart';
import 'package:abctechapp/provider/assist_provider.dart';
import 'package:abctechapp/services/assist_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'assist_service_test.mocks.dart';

@GenerateMocks([AssistProviderInterface])
void main() {
  late AssistService service;
  late MockAssistProviderInterface provider;

  setUp(() async {
    provider = MockAssistProviderInterface();
    service = AssistService(assistProvider: provider);

    String json = File('${Directory.current.path}/test/resources/assist_response.json').readAsStringSync();
    
    when(provider.getAssists()).thenAnswer((_) async => Future.sync(() => Response(statusCode: HttpStatus.ok, body: jsonDecode(json))));


  });

  test('Testando o retorno com sucesso', () async {
    List<Assist> lista = await service.getAssists();
    expect(lista.length, 3);
  });
}