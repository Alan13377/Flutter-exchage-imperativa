import 'package:exchange_api/app/domain/repositories/exchange_repository.dart';
import 'package:exchange_api/app/presentation/modules/home/providers/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = ChangeNotifierProvider((ref) {
  final repository = ref.watch(exchangeRepository);
  return HomeProvider(exchangeRepository: repository)..init();
});

class HomeProvider extends ChangeNotifier {
  //*Estado inicial

  HomeState _state = HomeState.loading();
  final ExchangeRepository exchangeRepository;
  HomeState get state => _state;

  HomeProvider({
    required this.exchangeRepository,
  });

  Future<void> init() async {
    state.maybeWhen(
      loading: () {},
      orElse: () {
        _state = HomeState.loading();
        notifyListeners();
      },
    );

    final result = await exchangeRepository.getPrices(
      [
        "bitcoin",
        "litecoin",
        "usd-coin",
        "dogecoin",
      ],
    );
    _state = result.when(
        left: (failure) => _state = HomeState.failed(failure),
        right: (cryptos) => _state = HomeState.loaded(cryptos));

    notifyListeners();
  }
}
