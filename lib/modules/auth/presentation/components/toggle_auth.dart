import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class ToggleAuth extends StatelessWidget {
  final bool isLogin;

  final void Function() toggleFun;
  const ToggleAuth({Key? key, required this.isLogin, required this.toggleFun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: toggleFun,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: isLogin
                  ? AppStrings.noAccount.tr()
                  : AppStrings.haveAccount.tr(),
            ),
            const WidgetSpan(
              child: SizedBox(
                width: AppSize.s5,
              ),
            ),
            TextSpan(
              text: isLogin ? AppStrings.signUp.tr() : AppStrings.login.tr(),
              style: TextStyle(color: ColorManager.primary),
            ),
          ],
        ),
      ),
    );
  }
}
