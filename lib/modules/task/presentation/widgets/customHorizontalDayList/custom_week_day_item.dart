import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class CustomWeekDayItem extends StatelessWidget {
  const CustomWeekDayItem({
    Key? key,
    required this.weekday,
    required this.dayNum,
    required this.isMark,
    this.onTap,
  }) : super(key: key);

  final String weekday;
  final int dayNum;
  final bool isMark;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekday,
              style: TextStyle(
                fontSize: AppSize.s38.sp,
                color: isMark ? Colors.grey[800] : Colors.grey[400],
              ),
            ).tr(),
            const SizedBox(height: AppSize.s5),
            Text(
              dayNum.toString(),
              style: TextStyle(
                fontSize: AppSize.s40.sp,
                fontWeight: FontWeight.bold,
                color: isMark ? ColorManager.kBlack : ColorManager.kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
