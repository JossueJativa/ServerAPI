import 'package:app_user_controller/common/button.dart';
import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
import 'package:app_user_controller/common/link.dart';
import 'package:app_user_controller/functions/authCallback.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  bool isLoading = false;
  bool canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAuth();
  }

  Future<void> _checkBiometricAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      canCheckBiometrics = await auth.canCheckBiometrics;

      if (canCheckBiometrics) {
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Por favor, autentíquese para acceder',
        );

        if (didAuthenticate) {
          await _tryAutoLogin();
        }
      }
    }
  }

  Future<void> _tryAutoLogin() async {
    bool isRefreshed = await refreshAccessToken();
    if (isRefreshed) {
      Navigator.popAndPushNamed(context, '/home');
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input(
              text: 'Username',
              controller: usernameController,
              obscureText: false,
            ),
            Input(
              text: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            Button(
              onPress: isLoading ? () {} : _onLoginPressed,
              text: isLoading ? 'Cargando...' : 'Iniciar sesión',
              color: Colors.blue,
              textColor: Colors.white,
            ),
            Link(
              text: 'Registrarse',
              onPress: () => Navigator.pushNamed(context, '/register'),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginPressed() async {
    setState(() => isLoading = true);

    bool auth = await authCallback(
      usernameController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (auth) {
      Navigator.popAndPushNamed(context, '/home');
      Infomessage(
        message: 'Inicio de sesión exitoso',
        color: Colors.green,
        textColor: Colors.white,
        icon: Icons.check,
        size: 20,
      ).show(context);
    } else {
      Infomessage(
        message: 'Credenciales incorrectas',
        color: Colors.red,
        textColor: Colors.white,
        icon: Icons.error,
        size: 20,
      ).show(context);
    }
  }
}
