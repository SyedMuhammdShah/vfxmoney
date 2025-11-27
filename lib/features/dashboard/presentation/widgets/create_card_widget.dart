import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';
import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';

class CreateCardPopup {
  /// Static method so you can call it anywhere:
  /// CreateCardPopup.show(context);
  static void show(BuildContext context) {
    DynamicFormPopup.show(
      context: context,
      title: 'Create New Card',
      subtitle: 'Enter details for your new virtual card.',
      fields: [
        FormFieldData(
          label: 'Card Name',
          labelSuffix: '(Alias)',
          hintText: 'Alias',
          keyboardType: TextInputType.text,
        ),
        FormFieldData(
          label: 'Card Type',
          hintText: 'Virtual Card',
          isDropdown: true,
          dropdownItems: ['Virtual Card', 'Physical Card'],
        ),
      ],
      footerText: 'Fees: Physical Card (Fee 100\$) or Virtual Card Fee 50%',
      buttonText: 'Create Card',
      onSubmit: (values) {
        print('Create Card Values: $values');
      },
    );
  }
}
