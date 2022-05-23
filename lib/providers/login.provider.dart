import 'package:products_app/providers/form.provider.dart';

class LoginProvider extends FormProvider {
  late String email;
  late String password;

  bool _isLoginPage = true;
  bool get isLoginPage => _isLoginPage;
  set isLoginPage(bool isLoginPage) {
    _isLoginPage = isLoginPage;
    notifyListeners();
  }

  @override
  bool isValid() {
    final isValid = super.isValid();
    if (isValid) print('$email - $password');
    return isValid;
  }
}
