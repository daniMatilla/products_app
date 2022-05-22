import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool busy) {
    _isBusy = busy;
    notifyListeners();
  }

  Future working(Future action) async {
    isBusy = true;
    await action;
    isBusy = false;
  }
}
