import 'package:exchange_api/app/domain/models/crypto.dart';
import 'package:flutter/material.dart';

class HomeLoaded extends StatelessWidget {
  final List<Crypto> cryptos;
  const HomeLoaded({super.key, required this.cryptos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        final crypto = cryptos[index];
        return ListTile(
          title: Text(crypto.id),
          trailing: Text(
            crypto.price.toStringAsFixed(2),
          ),
          subtitle: Text(crypto.symbol),
        );
      },
    );
  }
}
