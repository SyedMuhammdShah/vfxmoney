import 'package:flutter/material.dart';

class ProfileRequestTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subtitle;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  final bool isBottomLayout; // new flag to switch layout

  const ProfileRequestTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    this.radius = 30,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.isBottomLayout = false,
  });

  /// Factory constructor for bottom layout
  factory ProfileRequestTile.bottom({
    Key? key,
    required String imageUrl,
    required String name,
    required String subtitle,
    double radius = 30,
    VoidCallback? onTap,
    VoidCallback? onAccept,
    VoidCallback? onReject,
  }) {
    return ProfileRequestTile(
      key: key,
      imageUrl: imageUrl,
      name: name,
      subtitle: subtitle,
      radius: radius,
      onTap: onTap,
      onAccept: onAccept,
      onReject: onReject,
      isBottomLayout: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameParts = name.split(" ");

    if (isBottomLayout) {
      // 🔹 Alternative layout (buttons at bottom with text)
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row: Image + Name + Subtitle
              Row(
                children: [
                  CircleAvatar(
                    radius: radius,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nameParts.isNotEmpty ? nameParts.first : "",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            if (nameParts.length > 1)
                              Text(
                                nameParts.sublist(1).join(" "),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Bottom Row: Text Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        "Reject",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // 🔹 Original layout (icon buttons inline)
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: radius,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: nameParts.isNotEmpty ? nameParts.first : "",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        if (nameParts.length > 1)
                          TextSpan(
                            text: " ${nameParts.sublist(1).join(" ")}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Row(
              spacing: 6,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 25,
                  ),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 1),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onReject,
                ),
                IconButton.filled(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 25,
                  ),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  onPressed: onAccept,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
