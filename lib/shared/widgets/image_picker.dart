import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Maximum file size in bytes (20MB)
  static const int maxFileSizeInBytes = 20 * 1024 * 1024;

  // Allowed file extensions
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

  static Future<String?> pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await showModalBottomSheet<XFile?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext sheetContext) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Profile Picture',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOption(
                        sheetContext,
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        onTap: () async {
                          final XFile? picked = await _picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext, picked);
                          }
                        },
                      ),
                      _buildOption(
                        sheetContext,
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        onTap: () async {
                          final XFile? picked = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext, picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // If user cancelled, return null
      if (pickedFile == null) return null;

      // ✅ Validate file type
      final String extension = pickedFile.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        if (context.mounted) {
          await _showInvalidFileTypeError(context, extension);
        }
        return null;
      }

      // ✅ Validate file size
      if (context.mounted) {
        final bool isValid = await _validateImageSize(context, pickedFile.path);
        if (!isValid) return null;
      }

      return pickedFile.path;
    } catch (e) {
      debugPrint('Error selecting image: $e');
      return null;
    }
  }

  static Future<bool> _validateImageSize(
    BuildContext context,
    String imagePath,
  ) async {
    try {
      final File imageFile = File(imagePath);
      final int fileSizeInBytes = await imageFile.length();

      debugPrint('Image file size: ${formatFileSize(fileSizeInBytes)}');

      if (fileSizeInBytes > maxFileSizeInBytes) {
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (context.mounted) {
          await _showFileSizeError(context, fileSizeInMB);
        }
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking file size: $e');
      return false;
    }
  }

  static Future<void> _showInvalidFileTypeError(
    BuildContext context,
    String extension,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400], size: 28),
              const SizedBox(width: 12),
              const Expanded(child: Text('Invalid File Type')),
            ],
          ),
          content: Text(
            'The selected file type “.$extension” is not supported.\n\n'
            'Please upload an image in one of the following formats:\n\n'
            '- JPG\n- JPEG\n- PNG',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> _showFileSizeError(
    BuildContext context,
    double actualSizeMB,
  ) async {
    final bool? tryAgain = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[400], size: 28),
              const SizedBox(width: 12),
              const Expanded(child: Text('Image Too Large')),
            ],
          ),
          content: Text(
            'The selected image is ${actualSizeMB.toStringAsFixed(2)} MB. '
            'Please select an image smaller than 20 MB.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    return tryAgain ?? false;
  }

  /// Helper method to format file size for display purposes.
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  static Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
