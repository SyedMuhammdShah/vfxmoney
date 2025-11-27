import 'package:flutter/material.dart';
import 'package:vfxmoney/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:vfxmoney/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

import 'package:vfxmoney/shared/widgets/push_button.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', implyLeading: true),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Profile header (Image + Name + Email)
              const ProfileHeader(
                imagePath:
                    "https://img.icons8.com/?size=128&id=tZuAOUGm9AuS&format=png",
                name: "Jacob Jones",
                email: "testing547@gmail.com",
              ),

              const SizedBox(height: 10),

              /// Divider (thin like in screenshot)
              Container(height: 0.6, color: Colors.white.withOpacity(0.15)),

              const SizedBox(height: 24),

              /// All profile rows
              const ProfileInfoRow(label: "User Name:", value: "Jacob Jones"),
              const ProfileInfoRow(
                label: "Email Address:",
                value: "jacobjones@gmail.com",
              ),
              const ProfileInfoRow(
                label: "Phone Number:",
                value: "+00 0000 00000",
              ),
              const ProfileInfoRow(
                label: "Address:",
                value: "Street name, 123",
              ),
              const ProfileInfoRow(label: "City:", value: "Moscow"),
              const ProfileInfoRow(label: "Employee ID", value: "589778"),
              const ProfileInfoRow(label: "Occupation", value: "Business"),
              const ProfileInfoRow(
                label: "Identification Num",
                value: "98765432",
              ),

              const SizedBox(height: 30),

              /// Edit Button
              AppSubmitButton(title: "Edit", onTap: () {}),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
