import 'package:exchange_api/app/presentation/modules/home/providers/home_provider.dart';
import 'package:exchange_api/app/presentation/modules/home/view/widgets/appBar.dart';
import 'package:exchange_api/app/presentation/modules/home/view/widgets/error.dart';
import 'package:exchange_api/app/presentation/modules/home/view/widgets/loaded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(homeProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      body: repository.state.map<Widget>(
        loading: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        failed: (state) {
          return HomeError(failure: state.failure);
        },
        loaded: (state) {
          return HomeLoaded(
            cryptos: state.cryptos,
          );
        },
      ),
    );
  }
}
