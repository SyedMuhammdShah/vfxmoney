import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/delete_bloc/delete_account_bloc.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/shared/widgets/custom_loader.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final List<String> reasons = [
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Lorem ipsum dolor sit amet",
    "Other",
  ];

  final String? usertoken = locator<StorageService>().getToken;
  String? selectedReason;
  final TextEditingController otherController = TextEditingController();

  String get _finalReason {
    if (selectedReason?.contains("Other") == true) {
      return otherController.text.trim().isEmpty
          ? "Other"
          : otherController.text.trim();
    }
    return selectedReason?.split("-").first ?? "";
  }

  final loader = CustomLoader();
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAccountBloc, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountLoading) {
          loader.show(context);
        } else {
          loader.hide();
        }

        if (state is DeleteAccountError) {
          showToast(msg: state.message);
        }

        if (state is DeleteAccountOtpSent) {
          context.pushNamed(
            Routes.deleteOtp.name,
            extra: {'reason': _finalReason},
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          // appBar: RoundedAppBarWithProfile(
          //   showBackButton: true,
          //   height: 50,
          //   title: "Delete Account",
          //   alignTitleCenter: true,
          //   showNameLocation: false,
          //   showProfileImage: false,
          //   showIcons: true,
          //   titleColor: Colors.white,
          // ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Please specify the reason:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: reasons.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 0,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, index) {
                      final reason = reasons[index];
                      final value = "$reason-$index";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<String>(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              reason,
                              style: const TextStyle(fontSize: 14),
                            ),
                            value: value,
                            groupValue: selectedReason,
                            onChanged: (val) {
                              setState(() {
                                selectedReason = val;
                              });
                            },
                          ),
                          if (reason == "Other" &&
                              selectedReason?.contains("Other") == true)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: AppInputField(
                                validator: FormValidators.validateFullName,
                                controller: otherController,
                                hintText: "Write here",
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AppSubmitButton(
                  title: "Submit",
                  onTap: () {
                    if (selectedReason == null) {
                      showToast(msg: "Please select a reason first");

                      return;
                    }

                    final token = usertoken; // get from storage
                    context.read<DeleteAccountBloc>().add(
                      SendDeleteOtpEvent(token!),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
