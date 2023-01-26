import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:exchange_api/app/domain/models/crypto.dart';
import 'package:exchange_api/app/domain/models/ws_status/ws_status.dart';
import "package:freezed_annotation/freezed_annotation.dart";

//*Nombre del archivo actual
part "home_state.freezed.dart";

//*Estados de la respuesta de la api
@freezed
class HomeState with _$HomeState {
  //*Clase-factoryConstructor //Nombre de Clase a generar
  const factory HomeState.loading() = _Loading;
  const factory HomeState.failed(HttpRequestFailure failure) = _Failed;
  const factory HomeState.loaded({
    required List<Crypto> cryptos,
    @Default(WsStatus.connecting()) WsStatus wsStatus,
  }) = _Loaded;
}
