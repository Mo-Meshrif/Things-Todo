import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import 'custom_week_day_item.dart';

class CustomHorizontalDayList extends StatelessWidget {
  const CustomHorizontalDayList({
    Key? key,
    required this.dayList,
    required this.getSelectedIndex,
    required this.previousIndex,
  }) : super(key: key);
  final int previousIndex;
  final List<int> dayList;
  final Function(int day) getSelectedIndex;
  @override
  Widget build(BuildContext context) {
    List<String> weekList = [
      AppStrings.monday,
      AppStrings.tuesday,
      AppStrings.wednesday,
      AppStrings.thursday,
      AppStrings.friday,
      AppStrings.saturaday,
      AppStrings.sunday,
    ];
    DateTime dateTime = DateTime.now();
    String month = HelperFunctions.getMonth(dateTime.month);
    String year = HelperFunctions.getlocaleNumber(context, dateTime.year);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
          child: Text(
            month.tr() + ' ' + year,
            style: TextStyle(
              fontSize: AppSize.s50.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StatefulBuilder(
          builder: (context, innerState) => Container(
            height: AppSize.s176.h,
            width: double.infinity,
            color: ColorManager.primary,
            alignment: Alignment.center,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: weekList.length,
              itemBuilder: (BuildContext context, int index) {
                int dayNum = dayList[index];
                bool isMark = previousIndex == index ? true : false;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CustomWeekDayItem(
                      weekday: weekList[index],
                      dayNum: dayNum,
                      isMark: false,
                      onTap: () => getSelectedIndex(index),
                    ),
                    Visibility(
                      visible: isMark,
                      child: Positioned(
                        top: AppConstants.zeroVal,
                        child: ClipPath(
                          clipper: ClipPathClass(),
                          child: Container(
                            height: AppSize.s205.h,
                            padding: EdgeInsets.only(bottom: AppSize.s28.h),
                            color: Colors.white,
                            child: CustomWeekDayItem(
                              weekday: weekList[index],
                              dayNum: dayNum,
                              isMark: true,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height - 10);
    path.lineTo(-size.width / 2, size.height + 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
