import 'package:flutter/material.dart';

class HelloWidget extends StatelessWidget {
  final String userName;

  const HelloWidget({
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      child: Text("Hello $userName!",
          style: Theme.of(context).textTheme.headline2),
    );
  }
}
