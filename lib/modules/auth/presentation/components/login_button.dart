import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_elevated_loading.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final bool isLogin;
  final GlobalKey<FormState> authKey;
  final bool Function() inputsCheck;
  final void Function() loginFun;
  final void Function() signUpFun;

  const AuthButton({
    Key? key,
    required this.isLoading,
    required this.isLogin,
    required this.authKey,
    required this.inputsCheck,
    required this.loginFun,
    required this.signUpFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: AppSize.s144.h,
      child: isLoading
          ? const CustomElevatedLoading()
          : ElevatedButton(
              onPressed: () {
                if (authKey.currentState!.validate()) {
                  authKey.currentState!.save();
                  if (inputsCheck()) {
                    if (isLogin) {
                      loginFun();
                    } else {
                      signUpFun();
                    }
                  }
                }
              },
              child: Text(
                isLogin
                    ? AppStrings.loginButton.tr()
                    : AppStrings.signUpButton.tr(),
              ),
            ),
    );
  }
}
