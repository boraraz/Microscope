import 'package:flutter/material.dart';
import 'package:microscope/screens/login_screen.dart';
import 'package:microscope/screens/signup_screen.dart';
import 'package:microscope/utils/colors.dart';
import 'package:microscope/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Microscope",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: primaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  text: "Log In"),
            ),
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, SignupScreen.routeName);
                },
                text: "Sign Up"),
          ],
        ),
      ),
    );
  }
}
