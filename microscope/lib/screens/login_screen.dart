// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:microscope/resources/auth_method.dart';
import 'package:microscope/screens/home_screen.dart';
import 'package:microscope/utils/colors.dart';
import 'package:microscope/widgets/custom_button.dart';
import 'package:microscope/widgets/custom_textfield.dart';
import 'package:microscope/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });
    bool res = await _authMethods.loginUser(
      context,
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //for Email
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      controller: _emailController,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // for Password
                  const Text('Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: white,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      controller: _passwordController,
                      isPassword: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(onTap: loginUser, text: "Login"),
                ],
              ),
            )),
    );
  }
}
