import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/strings_manager.dart';

class CustomTextSearch extends StatelessWidget {
  final void Function(String val)? onChanged;
  final void Function()? onTap;
  const CustomTextSearch({Key? key, this.onTap, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 48.w),
      child: GestureDetector(
        onTap: onTap,
        child: TextFormField(
          autofocus: onTap == null ? true : false,
          enabled: onTap == null ? true : false,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppStrings.searchTask.tr(),
            suffixIconConstraints: BoxConstraints(maxWidth: 155.w),
            suffixIcon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(HelperFunctions.rotateVal(context)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SvgPicture.asset(IconAssets.search),
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
