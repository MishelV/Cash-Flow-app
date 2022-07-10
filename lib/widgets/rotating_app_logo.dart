import 'package:flutter/material.dart';

class RotatingAppLogo extends StatefulWidget {
  RotatingAppLogo({
    Key? key,
  }) : super(key: key);

  var _turns = 0.0;

  @override
  State<RotatingAppLogo> createState() => _RotatingAppLogoState();
}

class _RotatingAppLogoState extends State<RotatingAppLogo> {
  void _turn() {
    setState(() {
      widget._turns += 1.0 / 8.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _turn,
      child: AnimatedRotation(
        turns: widget._turns,
        duration: const Duration(milliseconds: 50),
        child: Image.asset(
          'assets/images/finance.png',
        ),
      ),
    );
  }
}
