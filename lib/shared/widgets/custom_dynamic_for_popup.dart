import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';

class DynamicFormPopup extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<FormFieldData> fields;
  final String buttonText;
  final String? footerText;
  final bool showFeesButton;
  final bool showFooterText;
  final Function(Map<String, dynamic>) onSubmit;

  const DynamicFormPopup({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.buttonText,
    this.footerText,
    this.showFeesButton = false,
    this.showFooterText = false,
    required this.onSubmit,
  }) : super(key: key);

  static void show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<FormFieldData> fields,
    required String buttonText,
    String? footerText,
    required Function(Map<String, dynamic>) onSubmit,
    required bool showFeesButton,
    required bool showFooterText,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.zero,
            child: DynamicFormPopup(
              title: title,
              subtitle: subtitle,
              fields: fields,
              buttonText: buttonText,
              footerText: footerText,
              // <<< IMPORTANT: pass the flags into the widget
              showFeesButton: showFeesButton,
              showFooterText: showFooterText,
              onSubmit: onSubmit,
            ),
          ),
        );
      },
    );
  }

  @override
  State<DynamicFormPopup> createState() => _DynamicFormPopupState();
}

class _DynamicFormPopupState extends State<DynamicFormPopup> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _formValues = {};

  String? selectedCardType;

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field.label] = TextEditingController(text: field.hintText);
      _formValues[field.label] = field.hintText;
      if (field.label == 'Card Type') {
        selectedCardType = 'Virtual Card'; // Default selection
        _controllers[field.label]?.text = 'Virtual Card';
        _formValues[field.label] = 'Virtual Card';
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Center(
                  child: Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Form Fields
                ...widget.fields.map((field) => _buildFormField(field)),

                // Footer text
                if (widget.showFooterText)
                  Text(
                    selectedCardType == 'Physical Card'
                        ? 'A one-time activation fee of \$299.99 will be added to your first deposit, which must be at least \$15.'
                        : 'A one-time activation fee of \$99.99 will be added to your first deposit, which must be at least \$15.',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),

                const SizedBox(height: 24),
                if (widget.showFeesButton) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // open your route
                        Navigator.of(context).pop();
                        context.pushNamed(Routes.feesAndLimit.name);
                        // OR: context.pushNamed(Routes.feesAndLimit.name);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Fees & Limits",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSubmit(_formValues);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(FormFieldData field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: field.label,
            style: const TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (field.labelSuffix != null)
                TextSpan(
                  text: ' ${field.labelSuffix}',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Input Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: field.isFilePicker
              ? _buildFilePickerField(field)
              : field.isDropdown
              ? _buildDropdownField(field)
              : _buildTextField(field),
        ),
        // Helper text for file picker
        if (field.helperText != null) ...[
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: 'Click here  this link preview image ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              children: [
                TextSpan(
                  text: field.helperActionText ?? 'Click here',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(FormFieldData field) {
    return TextField(
      controller: _controllers[field.label],
      keyboardType: field.keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      onChanged: (value) {
        _formValues[field.label] = value;
      },
      decoration: InputDecoration(
        hintText: field.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        prefixText: field.prefixText,
        prefixStyle: const TextStyle(color: Colors.white, fontSize: 13),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      ),
    );
  }

  Widget _buildDropdownField(FormFieldData field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String value) {
          setState(() {
            _formValues[field.label] = value;
            _controllers[field.label]?.text = value;
            selectedCardType = value;
          });
        },
        itemBuilder: (BuildContext context) {
          return (field.dropdownItems ?? []).map<PopupMenuEntry<String>>((
            String value,
          ) {
            return PopupMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _formValues[field.label] ?? field.hintText ?? 'Select',
                  style: TextStyle(
                    color:
                        _formValues[field.label] != null &&
                            _formValues[field.label] != field.hintText
                        ? Colors.white
                        : Colors.grey.shade600,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ],
          ),
        ),
        offset: const Offset(0, -10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF2A2A2A),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
    );
  }

  Widget _buildFilePickerField(FormFieldData field) {
    return InkWell(
      onTap: () {
        // Handle file picker
        print('File picker tapped for ${field.label}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field.hintText ?? 'Choose file',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
            Icon(Icons.upload_outlined, color: Colors.grey.shade600, size: 20),
          ],
        ),
      ),
    );
  }
}
