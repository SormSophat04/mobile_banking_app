import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF3629B7).withAlpha(20),
      blurRadius: 30,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardSmall = [
    BoxShadow(
      color: const Color(0xFF3629B7).withAlpha(20),
      blurRadius: 30,
      offset: const Offset(0, -5),
    ),
  ];
}
