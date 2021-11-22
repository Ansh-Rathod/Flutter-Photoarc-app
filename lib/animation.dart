import 'package:flutter/material.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(microseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
