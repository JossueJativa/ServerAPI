import 'package:app_user_controller/common/button.dart';
import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
import 'package:app_user_controller/common/link.dart';
import 'package:app_user_controller/functions/authCallback.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
              onPress: isLoading
                  ? () => {}
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      bool auth = await authCallback(
                        usernameController.text,
                        passwordController.text,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (auth) {
                        Infomessage(
                          message: 'Inicio de sesión exitoso',
                          color: Colors.green,
                          textColor: Colors.white,
                          icon: Icons.check,
                          size: 20,
                        ).show(context);
                        Navigator.popAndPushNamed(context, '/home');
                        
                      } else {
                        Infomessage(
                          message: 'Credenciales incorrectas',
                          color: Colors.red,
                          textColor: Colors.white,
                          icon: Icons.error,
                          size: 20,
                        ).show(context);
                      }
                    },
              text: isLoading ? 'Cargando...' : 'Iniciar sesión',
              color: Colors.blue,
              textColor: Colors.white,
            ),
            Link(
              text: 'Registrarse',
              onPress: () => {
                Navigator.pushNamed(context, '/register'),
              },
            ),
          ],
        ),
      ),
    );
  }
}
