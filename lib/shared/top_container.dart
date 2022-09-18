import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets? padding;
  // ignore: use_key_in_widget_constructors
  const TopContainer(
      {required this.height,
      required this.width,
      required this.child,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null
          ? padding
          : const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(68, 181, 255, 1.0),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
