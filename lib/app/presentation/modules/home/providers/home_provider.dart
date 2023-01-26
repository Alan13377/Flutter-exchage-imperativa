import 'dart:async';

import 'package:exchange_api/app/domain/models/ws_status/ws_status.dart';
import 'package:exchange_api/app/domain/repositories/exchange_repository.dart';
import 'package:exchange_api/app/domain/repositories/ws_repository.dart';
import 'package:exchange_api/app/presentation/modules/home/providers/home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = ChangeNotifierProvider((ref) {
  final repository = ref.watch(exchangeRepository);
  final wsRepository = ref.watch(wsRepositoryProvider);

  return HomeProvider(
      exchangeRepository: repository, wsRepository: wsRepository)
    ..init();
});
StreamSubscription? _subscription, _wsSubscription;

class HomeProvider extends ChangeNotifier {
  //*Estado inicial

  HomeState _state = const HomeState.loading();
  final ExchangeRepository exchangeRepository;
  final WsRepository wsRepository;
  HomeState get state => _state;

  final _ids = [
    "bitcoin",
    "litecoin",
    "usd-coin",
    "dogecoin",
  ];

  HomeProvider({
    required this.exchangeRepository,
    required this.wsRepository,
  });

  Future<void> init() async {
    state.maybeWhen(
      loading: () {},
      orElse: () {
        _state = const HomeState.loading();
        notifyListeners();
      },
    );

    final result = await exchangeRepository.getPrices(_ids);
    _state = result.when(
      left: (failure) => _state = HomeState.failed(failure),
      right: (cryptos) {
        startPricesListening();
        return HomeState.loaded(
          cryptos: cryptos,
        );
      },
    );

    notifyListeners();
  }

  //*Conectarse al webSocket

  Future<bool> startPricesListening() async {
    final connected = await wsRepository.connect(_ids);
    state.mapOrNull(
      loaded: (state) {
        if (connected) {
          _onPriceChanged();
        }
        _state = state.copyWith(
          wsStatus:
              connected ? const WsStatus.connected() : const WsStatus.failed(),
        );
        notifyListeners();
      },
    );

    return connected;
  }

  void _onPriceChanged() {
    _subscription?.cancel();
    _wsSubscription?.cancel();
    _subscription = wsRepository.onPricesChanged.listen(
      (changes) {
        state.mapOrNull(
          loaded: (state) {
            final cryptos = [...state.cryptos];
            final keys = changes.keys;
            for (int i = 0; i < cryptos.length; i++) {
              final crypto = cryptos[i];
              if (keys.contains(crypto.id)) {
                cryptos[i] = crypto.copyWith(
                  price: changes[crypto.id]!,
                );
              }
            }
            _state = state.copyWith(cryptos: cryptos);
            notifyListeners();
          },
        );
      },
    );
    _wsSubscription = wsRepository.onStatusChanged.listen(
      (status) {
        state.mapOrNull(loaded: (state) {
          _state = state.copyWith(wsStatus: status);
        });
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _wsSubscription?.cancel();
    super.dispose();
  }
}
