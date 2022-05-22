import 'package:flutter/material.dart';

abstract class Utils {
  static extractScreenArguments(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments;
}
