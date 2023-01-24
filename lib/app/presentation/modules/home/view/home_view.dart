import 'package:exchange_api/app/presentation/modules/home/providers/home_provider.dart';
import 'package:exchange_api/app/presentation/modules/home/providers/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(homeProvider);

    return Scaffold(
      body: () {
        final state = repository.state;

        if (state is HomeStateLoading) {
          print(state);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HomeStateLoaded) {
          return ListView.builder(
            itemCount: state.cryptos.length,
            itemBuilder: (context, index) {
              final crypto = state.cryptos[index];
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
        return const Center(
          child: Text("Error"),
        );
      }(),
    );
  }
}
