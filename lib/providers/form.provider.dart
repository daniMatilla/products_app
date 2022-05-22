import 'package:flutter/material.dart';
import 'package:products_app/providers/base.provider.dart';

abstract class FormProvider extends BaseProvider {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isValid() => key.currentState?.validate() ?? false;
}
