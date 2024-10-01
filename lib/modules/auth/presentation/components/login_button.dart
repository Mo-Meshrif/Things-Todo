import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_elevated_loading.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final bool isLogin;
  final void Function() tapFun;

  const AuthButton({
    Key? key,
    required this.isLoading,
    required this.isLogin,
    required this.tapFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: AppSize.s144.h,
        child: isLoading
            ? const CustomElevatedLoading()
            : ElevatedButton(
                onPressed: tapFun,
                child: Text(
                  isLogin
                      ? AppStrings.loginButton.tr()
                      : AppStrings.signUpButton.tr(),
                ),
              ),
      );
}
