import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/app/helper/navigation_helper.dart';

import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(
          AppPadding.p10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p20,
              ),
              child: SvgPicture.asset(
                IconAssets.appTitle,
                color: ColorManager.primary,
                width: AppSize.s120,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppPadding.p10,
                    ),
                    child: ListTile(
                      onTap: () {
                        NavigationHelper.pop(context);
                        if (index == 0) {
                          HelperFunctions.sendMail(
                            context: context,
                            mail: 'm.meshrif77@gmail.com',
                          );
                        } else {
                          String routeName = Routes.chatRoute;
                          NavigationHelper.pushNamed(context, routeName);
                          sl<AppShared>().setVal(
                            AppConstants.chatKey,
                            routeName,
                          );
                        }
                      },
                      tileColor: Colors.white,
                      minLeadingWidth: 10,
                      leading: Icon(
                        index == 0
                            ? Icons.mail_outline
                            : Icons.chat_bubble_outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      title: Text(
                        index == 0 ? AppStrings.sendProblem : AppStrings.chat,
                      ).tr(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
