import 'package:flutter/material.dart';

class Utils {

  static bool forLargeScreens(BuildContext context) {
    var forLargeScreens = MediaQuery.of(context).size.shortestSide > 600;
    return forLargeScreens;
  }
}