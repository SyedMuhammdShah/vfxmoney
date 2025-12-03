import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';
import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';

class UnloadMoneyPopup {
  static void show(BuildContext context) {
    DynamicFormPopup.show(
      showFeesButton: false,
      showFooterText: false,
      context: context,
      title: 'Unload Money',
      subtitle:
          'Enter the details to unload funds for\nCard **** **** **** 2375',
      fields: [
        FormFieldData(
          label: 'Amount',
          labelSuffix: '(USD)',
          hintText: '\$500',
          keyboardType: TextInputType.number,
          prefixText: '\$',
          isDropdown: true,
        ),
        FormFieldData(
          label: 'Wallet Address',
          labelSuffix: '(USD)',
          hintText: '0Xabc123',
          keyboardType: TextInputType.text,
        ),
        FormFieldData(
          label: 'Blockchain',
          hintText: 'Eg. Ethereum',
          isDropdown: true,
          dropdownItems: ['Ethereum', 'Bitcoin', 'Polygon', 'BSC'],
        ),
      ],
      buttonText: 'Confirm Unload Money',
      onSubmit: (values) {
        print('Unload Money Values: $values');
      },
    );
  }
}
