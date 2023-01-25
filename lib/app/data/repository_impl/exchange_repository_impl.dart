import 'package:exchange_api/app/data/services/exchange_api.dart';
import 'package:exchange_api/app/domain/repositories/exchange_repository.dart';

//*Implementacion del Repository
class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeApi _api;

  ExchangeRepositoryImpl(this._api);

  @override
  GetPricesFuture getPrices(List<String> ids) {
    return _api.getPrices(ids);
  }
}
// class ExchangeRepositoryImpl implements ExchangeRepository {
//   final ExchangeApi _api;

//   ExchangeRepositoryImpl(this._api);
//   @override
//   Future<GetPricesResult> getPrices(List<String> ids) {
//     return _api.getPrices(ids);
//   }
// }
