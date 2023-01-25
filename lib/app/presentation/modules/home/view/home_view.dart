import 'package:exchange_api/app/presentation/modules/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(homeProvider);

    return Scaffold(
      body: repository.state.when<Widget>(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        failed: (failure) {
          final String message = failure.when(
            network: () => "Check your internet connection",
            notFound: () => "Resource not found",
            server: () => "server error",
            unauthorized: () => "unauthorized",
            badRequest: () => "bad request",
            local: () => "Unknow Error",
          );

          return Center(child: Text(message));
        },
        loaded: (cryptos) {
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
        },
      ),
    );
  }
}
