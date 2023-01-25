import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:exchange_api/app/domain/models/crypto.dart';
import "package:freezed_annotation/freezed_annotation.dart";

//*Nombre del archivo actual
part "home_state.freezed.dart";

//*Estados de la respuesta de la api
@freezed
class HomeState with _$HomeState {
  //*Clase-factoryConstructor //Nombre de Clase a generar
  factory HomeState.loading() = _Loading;
  factory HomeState.failed(HttpRequestFailure failure) = _Failed;
  factory HomeState.loaded(List<Crypto> cryptos) = _Loaded;
}
