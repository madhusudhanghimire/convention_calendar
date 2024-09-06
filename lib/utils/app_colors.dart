import 'package:flutter/material.dart';

class ColorConstants {
  static getColor(String value) {
    return Color(int.parse("0xff$value"));
  }

  static Color blue = getColor("104985");
  static Color grey100 = getColor("B3B8C1");
  static Color grey400 = getColor("555E6B");
  static Color error = getColor("e60026");
  static Color white = getColor("ffffff");
  static Color black800 = getColor('232323');
  static Color appScafoldColor = getColor("F5F5F5");
  static Color green = getColor("046244");
  static Color grey50 = getColor("dedee0");
  static Color warning = getColor("c4aa15");
  static Color blueAccent = getColor('2b74a1');
}
