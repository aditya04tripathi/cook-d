import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            OneTitle(
              context,
              "Introduction",
              "Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.",
            ),
            OneTitle(
              context,
              "Information We Collect",
              "• Personal Information: Name, email, profile details, and location (if shared).\n• Content: Photos and descriptions of food you post.\n• Usage Data: How you interact with the App (likes, messages, swipes).",
            ),
            OneTitle(
              context,
              "How We Use Your Information",
              "• To connect users for food-sharing.\n• To improve the App and personalize user experience.\n• To ensure safety and prevent fraud.\n• To communicate important updates and notifications.",
            ),
            OneTitle(
              context,
              "Sharing of Information",
              "We do not sell your data. However, we may share it:\n• With other users (only the information you choose to display).\n• With service providers for App maintenance and analytics.\n• If required by law enforcement or legal obligations.",
            ),
            OneTitle(
              context,
              "Data Security",
              "• We use encryption and security measures to protect your data.\n• However, no system is 100% secure, so use the App at your own risk.",
            ),
            OneTitle(
              context,
              "Cookies & Tracking",
              "We use cookies and analytics tools to improve the App's functionality. You can disable cookies in your browser settings.",
            ),
            OneTitle(
              context,
              "Your Rights",
              "• Access & Correction: You can review and update your data.\n• Account Deletion: You can request to delete your account and data.\n• Opt-Out: You can opt out of marketing communications.",
            ),
            OneTitle(
              context,
              "Third-Party Links",
              "The App may contain links to external sites. We are not responsible for their privacy policies or practices.",
            ),
            OneTitle(
              context,
              "Changes to Privacy Policy",
              "We may update this policy periodically. We will notify you of any significant changes.",
            ),
            OneTitle(
              context,
              "Contact Us",
              "For privacy concerns, contact us at privacy@cookd.com.",
            ),
          ],
        ),
      ),
    );
  }
}

Widget OneTitle(BuildContext context, String title, String desc) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(desc),
      SizedBox(height: 16),
    ],
  );
}
