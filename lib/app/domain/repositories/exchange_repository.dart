import 'package:exchange_api/app/data/repository_impl/exchange_repository_impl.dart';
import 'package:exchange_api/app/data/services/exchange_api.dart';
import 'package:exchange_api/app/domain/results/get_prices/get_prices_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//*Recuperar los precios de la api
abstract class ExchangeRepository {
  Future<GetPricesResult> getPrices(List<String> ids);
}

final exchangeRepository = Provider(
  (ref) => ExchangeRepositoryImpl(
    ExchangeApi(
      Client(),
    ),
  ),
);
