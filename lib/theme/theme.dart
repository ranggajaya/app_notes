import 'package:flutter/material.dart';

Text subheading(String title) {
  return Text(
    title,
    style: const TextStyle(
        color: Color.fromRGBO(68, 181, 255, 1.0),
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2),
  );
}
