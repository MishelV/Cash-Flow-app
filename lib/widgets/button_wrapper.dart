import 'dart:math';

import 'package:flutter/material.dart';

class ButtonWrapper extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  bool inverse;

  ButtonWrapper(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.inverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            50,
          ),
          border: Border.all(
            color: inverse
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.primary,
            width: 4,
          ),
          color: Theme.of(context).colorScheme.background,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: Offset.fromDirection(1.5, 5),
            ),
          ],
        ),
        child: child);
  }
}
