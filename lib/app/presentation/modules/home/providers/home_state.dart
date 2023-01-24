import 'package:exchange_api/app/domain/models/crypto.dart';

abstract class HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateFailed extends HomeState {}

class HomeStateLoaded extends HomeState {
  //*Gu ardar las cryptos
  final List<Crypto> cryptos;

  HomeStateLoaded(this.cryptos);
}
