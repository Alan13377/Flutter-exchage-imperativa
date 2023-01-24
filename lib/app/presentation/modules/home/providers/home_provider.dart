import 'package:exchange_api/app/domain/repositories/exchange_repository.dart';
import 'package:exchange_api/app/domain/results/get_prices/get_prices_result.dart';
import 'package:exchange_api/app/presentation/modules/home/providers/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = ChangeNotifierProvider((ref) {
  final repository = ref.watch(exchangeRepository);
  return HomeProvider(exchangeRepository: repository)..init();
});

class HomeProvider extends ChangeNotifier {
  //*Estado inicial
  HomeState _state = HomeStateLoading();
  final ExchangeRepository exchangeRepository;
  HomeState get state => _state;

  HomeProvider({
    required this.exchangeRepository,
  });

  Future<void> init() async {
    if (state is! HomeStateLoading) {
      _state = HomeStateLoading();
      notifyListeners();
    }
    final result = await exchangeRepository.getPrices(
      [
        "bitcoin",
        "litecoin",
        "usd-coin",
        "dogecoin",
      ],
    );

    if (result is GetPricesSuccess) {
      _state = HomeStateLoaded(result.cryptos);
    } else {
      _state = HomeStateFailed();
    }
    notifyListeners();
  }
}
