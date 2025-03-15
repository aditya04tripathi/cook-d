import 'package:cook_d/screens/privacy_policy.dart';
import 'package:cook_d/screens/tnc_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        FirebaseAuth.instance.currentUser!.displayName!
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                    Text(
                      "${FirebaseAuth.instance.currentUser!.displayName}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(FirebaseAuth.instance.currentUser!.email!),
                  ],
                ),
              ),
            ),
            ProfileTile(
              title: 'Privacy Policy',
              onTap: () {
                Get.to(() => PrivacyPolicyScreen());
              },
              icon: Icons.privacy_tip_rounded,
            ),
            ProfileTile(
              title: 'Terms of Service',
              icon: Icons.info_rounded,
              onTap: () {
                Get.to(() => TncScreen());
              },
            ),
            ProfileTile(title: 'My Meetups', icon: Icons.people_rounded),
            Expanded(child: SizedBox()),
            ProfileTile(
              title: 'Sign Out',
              icon: Icons.logout_rounded,
              bgColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    this.bgColor,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor ?? Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
