import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vfxmoney/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vfxmoney/shared/model/form_field_Model.dart';
import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';

class CreateCardPopup {
  /// Static method so you can call it anywhere:
  /// CreateCardPopup.show(context);
  static void show(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>(); // ✅ SAFE

    DynamicFormPopup.show(
      context: context,
      title: 'Create New Cards',
      subtitle: 'Enter details for your new virtual card.',
      showFeesButton: true,
      showFooterText: true,
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
      buttonText: 'Create Card',
      onSubmit: (values) {
        final alias = values['Card Name'] ?? '';
        final type = values['Card Type'] == 'Physical Card'
            ? 'physical'
            : 'virtual';

        // ✅ USE STORED BLOC (NOT CONTEXT)
        dashboardBloc.add(CreateCard(alias: alias, cardType: type));

    
      },
    );
  }
}
