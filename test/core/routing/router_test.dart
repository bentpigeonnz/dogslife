import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:dogsLife/router.dart';

void main() {
  test('Router initial location is /', () {
    final GoRouter router = appRouter;
    expect(router.routeInformationProvider.value.location, '/');
  });
}
