import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/common/models/drawer_item_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/navigation_helper.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../../../modules/auth/domain/entities/user.dart';
import 'image_builder.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser user = HelperFunctions.getSavedUser();
    List<DrawerItemModel> pageList = HelperFunctions.getDrawerItemList(
      context,
    );
    return Container(
      color: Colors.white,
      width: ScreenUtil().screenWidth * AppSize.s07,
      height: ScreenUtil().screenHeight,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: ColorManager.primary,
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SafeArea(
                  left: false,
                  right: false,
                  bottom: false,
                  child: Container(
                    width: AppSize.s220.r,
                    height: AppSize.s220.r,
                    margin: const EdgeInsets.all(AppSize.s5),
                    padding: const EdgeInsets.all(AppSize.s3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSize.s110.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s110.r),
                      child: ImageBuilder(
                        fit: BoxFit.cover,
                        imageUrl: user.pic ?? '',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.s10.h,
                ),
                Text(
                  user.name.isEmpty ? AppStrings.user.tr() : user.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                DrawerItemModel item = pageList[index];
                return ListTile(
                  onTap: () {
                    NavigationHelper.pop(context);
                    item.onTap();
                  },
                  leading: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                      HelperFunctions.rotateVal(
                        context,
                        rotate: item.rotate,
                      ),
                    ),
                    child: SvgPicture.asset(
                      item.icon,
                      color: Colors.black,
                      width: item.size,
                    ),
                  ),
                  title: Text(
                    item.title,
                  ).tr(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
