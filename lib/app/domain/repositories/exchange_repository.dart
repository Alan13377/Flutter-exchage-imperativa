import 'package:exchange_api/app/data/repository_impl/exchange_repository_impl.dart';
import 'package:exchange_api/app/data/services/exchange_api.dart';
import 'package:exchange_api/app/domain/either/either.dart';
import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:exchange_api/app/domain/models/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//*Privder que recuperar los precios de la api
// abstract class ExchangeRepository {
//   Future<GetPricesResult> getPrices(List<String> ids);
// }

//*Error ---- Exito
typedef GetPricesFuture = Future<Either<HttpRequestFailure, List<Crypto>>>;

abstract class ExchangeRepository {
  GetPricesFuture getPrices(List<String> ids);
}

//*Implementacion del Repository
final exchangeRepository = Provider(
  (ref) => ExchangeRepositoryImpl(
    ExchangeApi(
      Client(),
    ),
  ),
);
