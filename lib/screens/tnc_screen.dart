import 'package:flutter/material.dart';

class TncScreen extends StatelessWidget {
  const TncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            OneTitle(
              context,
              "Introduction",
              "Cook'd is a social platform designed to connect people through food sharing. Users can post homemade meals, and others can express interest in sharing them by swiping right (\"Count Me In\").\nBy accessing or using our App, you agree to these Terms and Conditions. If you do not agree, please do not use the App.",
            ),
            OneTitle(
              context,
              "Eligibility",
              "• You must be 18 years or older to use the App.\n• By using the App, you confirm that you can enter a legally binding agreement.\n• You must not be prohibited by law from using such a service.",
            ),
            OneTitle(
              context,
              "User Responsibilities",
              "• Accurate Information: You must provide truthful details in your profile.\n• Food Safety & Quality: Users are responsible for ensuring their food is hygienically prepared and safe for consumption.\n• Respect & Decency: No offensive, harmful, or inappropriate content is allowed.\n• No Commercial Use: Selling food via the platform is prohibited. This is a community-sharing platform, not a marketplace.",
            ),
            OneTitle(
              context,
              "Prohibited Activities",
              "You agree NOT to:\n• Post false, misleading, or fraudulent content.\n• Share food that is expired, contaminated, or unsafe.\n• Harass, threaten, or harm other users.\n• Use the platform for commercial, promotional, or illegal activities.\n• Impersonate someone else or create fake profiles.",
            ),
            OneTitle(
              context,
              "Food Safety Disclaimer",
              "• We DO NOT monitor or verify the quality, safety, or ingredients of food shared on the platform.\n• Users must exercise their own judgment before consuming food.\n• We are not responsible for any allergic reactions, foodborne illnesses, or adverse effects from food consumed.",
            ),
            OneTitle(
              context,
              "User Content & License",
              "• You retain ownership of the content (photos, descriptions) you post.\n• By posting, you grant us a non-exclusive, royalty-free, worldwide license to display and share your content within the App.\n• We may remove content that violates our guidelines.",
            ),
            OneTitle(
              context,
              "Account Termination",
              "We reserve the right to suspend or delete accounts that:\n• Violate these Terms & Conditions.\n• Engage in fraudulent or harmful behavior.\n• Are inactive for an extended period.",
            ),
            OneTitle(
              context,
              "Limitation of Liability",
              "• We provide the App \"as is\" with no guarantees.\n• We are not responsible for any disputes, illnesses, damages, or losses arising from the use of the App.\n• You use the App at your own risk.",
            ),
            OneTitle(
              context,
              "Changes to Terms",
              "We may update these Terms at any time. Continued use of the App means you accept the revised Terms.",
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
