import 'package:flutter/material.dart';

abstract class Ui {
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    String? suffixText,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: MaterialStateColor.resolveWith((states) {
            final Color color = states.contains(MaterialState.error)
                ? Colors.red[800]!
                : Colors.teal;
            return color;
          }),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red[800]!,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: Colors.red[800]!,
        ),
      ),
      hintText: hintText,
      floatingLabelStyle:
          MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.error)
            ? Colors.red[800]!
            : Colors.teal;
        return TextStyle(color: color);
      }),
      labelText: labelText,
      suffixText: suffixText,
      suffixStyle: TextStyle(
        color: Colors.teal[500],
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(milliseconds: 500),
    Color backgroundColor = Colors.teal,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
