import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_text_form_field.dart';

class AuthInputs extends StatelessWidget {
  final bool isLogin;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthInputs(
      {Key? key,
      required this.isLogin,
      required this.nameController,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.border),
      ),
      child: Column(
        children: [
          Visibility(
            visible: !isLogin,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: nameController,
                  iconName: IconAssets.user,
                  hintText: AppStrings.userName.tr(),
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.enterName.tr();
                    } else {
                      return null;
                    }
                  },
                ),
                Divider(color: ColorManager.border),
              ],
            ),
          ),
          CustomTextFormField(
            controller: emailController,
            iconName: IconAssets.email,
            hintText: AppStrings.email.tr(),
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val!.isEmpty) {
                return AppStrings.enterEmail.tr();
              } else {
                return null;
              }
            },
          ),
          Divider(color: ColorManager.border),
          CustomTextFormField(
            controller: passwordController,
            iconName: IconAssets.password,
            hintText: AppStrings.password.tr(),
            textInputAction: TextInputAction.done,
            isPassword: true,
            validator: (val) {
              if (val!.isEmpty) {
                return AppStrings.enterPassword.tr();
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }
}
