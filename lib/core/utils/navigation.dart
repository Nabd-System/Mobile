import 'package:flutter/material.dart';

void pushTo(BuildContext context, Widget newScreen) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => newScreen));
}

void pushWithReplacement(BuildContext context, Widget newScreen) {
  Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (context) => newScreen));
}

void pushAndRemoveUntil(BuildContext context, Widget newScreen) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => newScreen),
    (route) => false,
  );
}
