import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

BoxDecoration tapindicator = BoxDecoration(
    gradient: const LinearGradient(colors: [
      Color.fromRGBO(235, 149, 230, 0.33),
      Color.fromRGBO(175, 136, 235, 0.38),
      Color.fromRGBO(143, 165, 243, 0.31),
    ]),
    borderRadius: BorderRadius.circular(25.0));

Gradient textGradient = const LinearGradient(colors: [
  Color.fromRGBO(255, 255, 255, 1),
  Color.fromRGBO(255, 255, 255, 1),
  Color.fromARGB(79, 195, 159, 231)
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

Image Distance(BuildContext context) {
  return Image.asset('image/distance.png',
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);
}

Image Running_duration(BuildContext context) {
  return Image.asset('image/hourglass.png',
      color: Colors.black.withOpacity(0.7),
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);
}

Image Running_pace(BuildContext context) {
  return Image.asset('image/running-shoe.png',
      color: Colors.black.withOpacity(0.7),
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.width * 0.1);
}

BoxDecoration boxdeco = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      const Color.fromARGB(179, 100, 40, 211).withOpacity(0.74),
      const Color.fromARGB(145, 43, 143, 193)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  color: Colors.amber.shade100,
  borderRadius: const BorderRadius.all(
    Radius.circular(20.0),
  ),
);