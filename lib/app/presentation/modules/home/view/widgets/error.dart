import 'package:exchange_api/app/domain/failures/http_request_failures.dart';
import 'package:flutter/material.dart';

class HomeError extends StatelessWidget {
  final HttpRequestFailure failure;
  const HomeError({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    final String message = failure.when(
      network: () => "Check your internet connection",
      notFound: () => "Resource not found",
      server: () => "server error",
      unauthorized: () => "unauthorized",
      badRequest: () => "bad request",
      local: () => "Unknow Error",
    );

    return Center(child: Text(message));
  }
}
