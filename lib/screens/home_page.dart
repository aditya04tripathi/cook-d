import 'package:cook_d/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
          title: "Logout",
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
