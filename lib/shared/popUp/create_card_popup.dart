// import 'package:flutter/material.dart';
// import 'package:vfxmoney/shared/model/form_field_Model.dart';
// import 'package:vfxmoney/shared/widgets/custom_dynamic_for_popup.dart';

// class CreateCardPopup extends StatelessWidget {
//   const CreateCardPopup({super.key});

//   void _openPopup(BuildContext context) {
//     DynamicFormPopup.show(
//       context: context,
//       title: 'Create New Card',
//       subtitle: 'Enter details for your new virtual card.',
//       fields: [
//         FormFieldData(
//           label: 'Card Name',
//           labelSuffix: '(Alias)',
//           hintText: 'Alias',
//           keyboardType: TextInputType.text,
//         ),
//         FormFieldData(
//           label: 'Card Type',
//           hintText: 'Virtual Card',
//           isDropdown: true,
//           dropdownItems: ['Virtual Card', 'Physical Card'],
//         ),
//       ],
//       footerText: 'Fees: Physical Card (Fee 100\$) or Virtual Card Fee 50%',
//       buttonText: 'Create Card',
//       onSubmit: (values) {
//         print('Create Card Values: $values');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openPopup(context),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.add, color: Colors.white, size: 20),
//             SizedBox(width: 8),
//             Text(
//               "Create Card",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: "Nunito",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
