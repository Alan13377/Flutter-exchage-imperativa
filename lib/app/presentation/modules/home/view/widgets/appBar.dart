import 'package:exchange_api/app/presentation/modules/home/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends ConsumerWidget with PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(homeProvider);
    return AppBar(
      title: repository.state.mapOrNull(
        loaded: (state) => Text(
          state.wsStatus.when(
            connecting: () => "connecting",
            connected: () => "connected",
            failed: () => "failed",
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
