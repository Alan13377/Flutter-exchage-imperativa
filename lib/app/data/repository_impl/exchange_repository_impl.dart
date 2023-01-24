import 'package:exchange_api/app/data/services/exchange_api.dart';
import 'package:exchange_api/app/domain/repositories/exchange_repository.dart';
import 'package:exchange_api/app/domain/results/get_prices/get_prices_result.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeApi _api;

  ExchangeRepositoryImpl(this._api);
  @override
  Future<GetPricesResult> getPrices(List<String> ids) {
    return _api.getPrices(ids);
  }
}
