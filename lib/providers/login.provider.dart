import 'package:products_app/providers/form.provider.dart';

class LoginProvider extends FormProvider {
  late String email;
  late String password;

  @override
  bool isValid() {
    final isValid = super.isValid();
    if (isValid) print('$email - $password');
    return isValid;
  }
}
