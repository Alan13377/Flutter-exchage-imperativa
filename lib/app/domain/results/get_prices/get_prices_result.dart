import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:exchange_api/app/domain/models/crypto.dart';

abstract class GetPricesResult {}

//*Utilizar cuando la solicitud a la api sea exitosa
class GetPricesSuccess extends GetPricesResult {
  GetPricesSuccess(this.cryptos);
  //*Almacenar las monedas
  final List<Crypto> cryptos;
}

//*Utilizar cuando la solicitud a la api falle
class GetPricesFailure extends GetPricesResult {
  GetPricesFailure(this.failure);
  //*Guardamos el error
  final HttpRequestFailure failure;
}
