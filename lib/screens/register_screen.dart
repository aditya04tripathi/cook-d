import 'package:cook_d/screens/login_page.dart';
import 'package:cook_d/widgets/custom_button.dart';
import 'package:cook_d/widgets/custom_text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordHidden = true;
  bool isRePasswordHidden = true;

  TextEditingController emailController = TextEditingController(
    text: "atri0048@student.monash.edu",
  );
  TextEditingController passwordController = TextEditingController(
    text: "1234567890",
  );
  TextEditingController rePasswordController = TextEditingController(
    text: "1234567890",
  );

  void registerUser() async {
    try {
      if (passwordController.text != rePasswordController.text) {
        Get.snackbar("Error", "Passwords do not match!");
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

      await userCredential.user!.updateDisplayName(
        emailController.text.split("@").first,
      );

      emailController.clear();
      passwordController.clear();
      rePasswordController.clear();

      Get.snackbar("Success", "You have successfully registered!");

      Get.to(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message!);
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset("assets/images/logo.png"),
              ),
              SizedBox(height: 24),
              CustomTextInput(
                controller: emailController,
                hintText: "Email address",
                prefixIcon: Icons.email_rounded,
                obscureText: false,
              ),
              SizedBox(height: 16),
              CustomTextInput(
                controller: passwordController,
                hintText: "Password",
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
                obscureText: isRePasswordHidden,
                onToggleVisibility: () {
                  setState(() {
                    isRePasswordHidden = !isRePasswordHidden;
                  });
                },
              ),
              SizedBox(height: 16),
              CustomTextInput(
                controller: rePasswordController,
                hintText: "Confirm Password",
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
                obscureText: isPasswordHidden,
                onToggleVisibility: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
              SizedBox(height: 16),
              CustomButton(onPressed: registerUser, title: "Register"),
            ],
          ),
        ),
      ),
    );
  }
}
