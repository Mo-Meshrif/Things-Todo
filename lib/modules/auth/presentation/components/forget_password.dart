import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/common/models/alert_action_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/navigation_helper.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../controller/auth_bloc.dart';
import '../widgets/custom_text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  final TextEditingController forgetPassController;
  const ForgetPassword({
    Key? key,
    required this.forgetPassController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () {
          final GlobalKey<FormState> _forgetKey = GlobalKey<FormState>();
          HelperFunctions.showAlert(
            context: context,
            forceAndroidStyle: true,
            title: AppStrings.forgetPassword.tr(),
            content: Form(
              key: _forgetKey,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.border),
                ),
                child: CustomTextFormField(
                  controller: forgetPassController,
                  iconName: IconAssets.email,
                  hintText: AppStrings.email.tr(),
                  textInputAction: TextInputAction.done,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.enterEmail.tr();
                    } else if (!HelperFunctions.isEmailValid(val.toString())) {
                      return AppStrings.notVaildEmail.tr();
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            actions: [
              AlertActionModel(
                title: AppStrings.cancel,
                onPressed: () => NavigationHelper.pop(context),
              ),
              AlertActionModel(
                title: AppStrings.rest,
                onPressed: () {
                  if (_forgetKey.currentState!.validate()) {
                    _forgetKey.currentState!.save();
                    NavigationHelper.pop(context);
                    context.read<AuthBloc>().add(
                          ForgetPasswordEvent(
                            email: forgetPassController.text,
                          ),
                        );
                  }
                },
              ),
            ],
          );
        },
        style: TextButton.styleFrom(foregroundColor: ColorManager.border),
        child: Text(AppStrings.forgetPassword.tr()),
      );
}
