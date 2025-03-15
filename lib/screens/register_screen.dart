import 'package:cook_d/widgets/custom_button.dart';
import 'package:cook_d/widgets/custom_text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordHidden = true;
  bool isRePasswordHidden = true;

  TextEditingController emailController = TextEditingController(
    text: "adityatripathi.at04@gmail.com",
  );
  TextEditingController passwordController = TextEditingController(
    text: "1234567890",
  );
  TextEditingController rePasswordController = TextEditingController(
    text: "1234567890",
  );

  void registerUser() async {
    debugPrint("Registering user...");
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      AlertDialog.adaptive(
        title: Text("Error!"),
        content: Text(e.message ?? "An error occurred!"),
      );
    } catch (e) {
      print(e);
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
