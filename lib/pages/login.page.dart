import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../ui/ui.dart';
import 'pages.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static String get routeName => '$LoginPage';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double heightHeader = size.height * .4;
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      body: Stack(
        children: [
          _Header(heightHeader: heightHeader),
          // Form
          SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              left: size.width * .1,
              right: size.width * .1,
              top: size.height * .3,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ChangeNotifierProvider<LoginProvider>(
                    create: (_) => LoginProvider(),
                    child: const _Form(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Crear una cuenta nueva',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Form(
      key: loginProvider.key,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Login',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                loginProvider.email = value;
              },
              validator: (value) {
                return value != null && value == 'dmatilla@email.com'
                    ? null
                    : 'email incorrecto';
              },
              decoration: Ui.inputDecoration(
                labelText: 'email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              onChanged: (value) {
                loginProvider.password = value;
              },
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'al menos 6 caracteres';
              },
              decoration: Ui.inputDecoration(
                labelText: 'password',
              ),
            ),
          ),
          MaterialButton(
            color: Colors.teal,
            textColor: Colors.white,
            minWidth: double.infinity,
            height: 50,
            elevation: 0,
            onPressed: loginProvider.isBusy
                ? null
                : () async {
                    if (!loginProvider.isValid()) return;

                    FocusScope.of(context).unfocus();

                    await loginProvider.working(
                      Future.delayed(
                        const Duration(seconds: 2),
                      ),
                    );

                    Navigator.pushReplacementNamed(
                        context, ProductsPage.routeName);
                  },
            child: Text(
              loginProvider.isBusy ? 'Espera...' : 'Ingresar',
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.heightHeader}) : super(key: key);

  final double heightHeader;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: heightHeader,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal,
                Colors.tealAccent,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(child: _Bubble(), top: 90, left: 60),
              Positioned(child: _Bubble(), top: -40, left: -30),
              Positioned(child: _Bubble(), top: 20, right: -20),
              Positioned(child: _Bubble(), bottom: -50, left: -10),
              Positioned(child: _Bubble(), bottom: 50, right: 30),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: heightHeader,
          child: const Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 56,
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(90, 255, 255, 255),
      ),
    );
  }
}
