import 'dart:convert';
import 'dart:io';

import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:exchange_api/app/domain/models/crypto.dart';
import 'package:exchange_api/app/domain/results/get_prices/get_prices_result.dart';
import 'package:http/http.dart';

//**Peticion a la API */
class ExchangeApi {
  final Client _client;

  ExchangeApi(this._client);

  Future<GetPricesResult> getPrices(List<String> ids) async {
    try {
      final response = await _client.get(
        Uri.parse(
          "https://api.coincap.io/v2/assets?ids=${ids.join(',')}",
        ),
      );
      if (response.statusCode == 200) {
        //*Respuesta en string a map
        final json = jsonDecode(response.body);
        final cryptos = (json["data"] as List).map(
          (e) => Crypto(
            id: e["id"],
            symbol: e["symbol"],
            price: double.parse(
              e["priceUsd"],
            ),
          ),
        );
        print(cryptos.toList());
        return GetPricesSuccess(cryptos.toList());
      }
      if (response.statusCode == 404) {
        throw HttpRequestFailure.notFound;
      }
      if (response.statusCode >= 500) {
        throw HttpRequestFailure.server;
      }
      throw HttpRequestFailure.local;
    } catch (e) {
      late HttpRequestFailure failure;
      if (e is HttpRequestFailure) {
        failure = e;
      } else if (e is SocketException || e is ClientException) {
        //*Errores por conexion
        failure = HttpRequestFailure.network;
      } else {
        failure = HttpRequestFailure.local;
      }
      return GetPricesFailure(failure);
    }
  }
}
