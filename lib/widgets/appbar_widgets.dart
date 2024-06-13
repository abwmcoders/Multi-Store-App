import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Acme',
          letterSpacing: 1.5,
          fontSize: 26),
    );
  }
}

class AppbarBackButton extends StatelessWidget {
  const AppbarBackButton({
    Key? key, this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: color ?? Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
