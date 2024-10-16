import 'package:app_user_controller/common/button.dart';
import 'package:app_user_controller/common/infomessage.dart';
import 'package:app_user_controller/common/input.dart';
import 'package:app_user_controller/functions/authCallback.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Input(
              text: 'Nombre de usuario',
              controller: usernameController,
              obscureText: false,
            ),
            Input(
              text: 'Email',
              controller: emailController,
              obscureText: false,
            ),
            Input(
              text: 'Contraseña',
              controller: passwordController,
              obscureText: true,
            ),
            Input(
              text: 'Confirmar contraseña',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            Button(
              onPress: () async {
                List<String> texts = [
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                  confirmPasswordController.text,
                ];

                if (passwordController.text != confirmPasswordController.text) {
                  Infomessage(
                    message: 'Las contraseñas no coinciden',
                    color: Colors.red,
                    textColor: Colors.white,
                    icon: Icons.error,
                    size: 20,
                  ).show(context);
                  return;
                }

                if (texts.contains('')) {
                  Infomessage(
                    message: 'Por favor, rellene todos los campos',
                    color: Colors.red,
                    textColor: Colors.white,
                    icon: Icons.error,
                    size: 20,
                  ).show(context);
                  return;
                }

                if (!emailController.text.contains('@') ||
                    !emailController.text.contains('.')) {
                  Infomessage(
                    message: 'Por favor, introduzca un email válido',
                    color: Colors.red,
                    textColor: Colors.white,
                    icon: Icons.error,
                    size: 20,
                  ).show(context);
                  return;
                }

                bool isRegister = await registerCallback(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                  confirmPasswordController.text,
                );

                if (isRegister) {
                  Infomessage(
                    message: 'Registro exitoso',
                    color: Colors.green,
                    textColor: Colors.white,
                    icon: Icons.check,
                    size: 20,
                  ).show(context);
                  Navigator.pop(context);
                }
              },
              text: 'Registrarse',
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
