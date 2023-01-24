import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/app/utils/strings_manager.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/values_manager.dart';

class CustomAboutWidget extends StatelessWidget {
  const CustomAboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p20,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s15.r)),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p10),
          child: Column(
            children: [
              const SizedBox(height: AppSize.s10),
              SvgPicture.asset(
                IconAssets.appTitle,
                color: ColorManager.primary,
                width: AppSize.s120,
              ),
              const SizedBox(height: AppSize.s10),
              const Text(
                AppStrings.aboutText,
                textAlign: TextAlign.center,
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }
}
