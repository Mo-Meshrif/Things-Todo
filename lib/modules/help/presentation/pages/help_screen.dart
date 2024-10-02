import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/common/widgets/custom_app_bar.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../auth/presentation/widgets/custom_or_divider.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String message = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.help,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p30,
            horizontal: AppPadding.p20,
          ),
          child: Column(
            children: [
              Center(
                child: Image.asset(IconAssets.helpDesk),
              ),
              const SizedBox(
                height: AppSize.s30,
              ),
              Column(
                children: [
                  Visibility(
                    visible: message.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppPadding.p10,
                      ),
                      child: ListTile(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          HelperFunctions.sendMail(
                            context: context,
                            mail: 'm.meshrif77@gmail.com',
                            message: message,
                          );
                        },
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        title: const Text(AppStrings.sendProblem).tr(),
                        trailing: const Icon(Icons.send),
                      ),
                    ),
                  ),
                  TextFormField(
                    maxLines: 8,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: AppStrings.problemDetails.tr(),
                      contentPadding: const EdgeInsets.all(AppPadding.p10),
                      hintStyle: const TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(
                      () => message = value,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p20,
                ),
                child: CustomOrDivider(),
              ),
              ListTile(
                onTap: () {
                  String routeName = Routes.chatRoute;
                  NavigationHelper.pushNamed(context, routeName);
                  sl<AppShared>().setVal(
                    AppConstants.chatKey,
                    routeName,
                  );
                },
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s5),
                  side: const BorderSide(color: Colors.grey),
                ),
                title: const Text(AppStrings.chat).tr(),
                trailing: const Icon(Icons.arrow_forward),
              )
            ],
          ),
        ),
      );
}
