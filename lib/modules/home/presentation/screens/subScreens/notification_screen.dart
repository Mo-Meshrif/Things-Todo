import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/common/models/alert_action_model.dart';
import '../../../../../app/common/models/notifiy_model.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/notification_services.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  final List<ReceivedNotifyModel> items;
  const NotificationScreen({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, innerState) => Scaffold(
          appBar: CustomAppBar(
            title: AppStrings.notifications,
            hideNotifyIcon: true,
            clearNotify: IconButton(
              onPressed: () => HelperFunctions.showAlert(
                context: context,
                content: const Text(AppStrings.deleteAllNotifications).tr(),
                actions: [
                  AlertActionModel(
                    title: AppStrings.cancel.tr(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AlertActionModel(
                    title: AppStrings.delete.tr(),
                    onPressed: () {
                      innerState(() => items.clear());
                      sl<NotificationServices>().deleteAllNotificationData();
                      NavigationHelper.pop(context);
                    },
                  ),
                ],
              ),
              icon: const Icon(Icons.delete),
            ),
          ),
          body: items.isEmpty
              ? Center(child: Lottie.asset(JsonAssets.empty))
              : ListView.separated(
                  itemCount: items.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      HelperFunctions.handleNotificationAction(
                        context,
                        items[index],
                        hideNotifyIcon: true,
                        fromNotScreen: true,
                      );
                      if (!items[index].isOpened) {
                        innerState(
                          () => items[index] = items[index].copyWith(true),
                        );
                      }
                    },
                    tileColor: ColorManager.kWhite,
                    horizontalTitleGap: 15,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    leading: Image.asset(
                      items[index].type == MessageType.task
                          ? IconAssets.task
                          : IconAssets.notify,
                    ),
                    title: Text(items[index].title!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[index].body!.isEmpty
                            ? AppStrings.noDescp.tr()
                            : items[index].body!),
                        Text(DateFormat(
                          AppConstants.dmyyyyhma,
                          context.locale.languageCode,
                        ).format(items[index].date!)),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: ColorManager.background,
                          child: InkWell(
                            child: const Icon(Icons.close),
                            onTap: () => HelperFunctions.showAlert(
                              context: context,
                              content: const Text(AppStrings.deleteNotify).tr(),
                              actions: [
                                AlertActionModel(
                                  title: AppStrings.cancel.tr(),
                                  onPressed: () =>
                                      NavigationHelper.pop(context),
                                ),
                                AlertActionModel(
                                  title: AppStrings.delete.tr(),
                                  onPressed: () {
                                    sl<NotificationServices>()
                                        .deleteNotificationData(
                                      items[index].id,
                                    );
                                    if (!items[index].isOpened) {
                                      sl<AwesomeNotifications>()
                                          .getGlobalBadgeCounter()
                                          .then(
                                        (value) {
                                          if (value > 0) {
                                            sl<AwesomeNotifications>()
                                                .setGlobalBadgeCounter(
                                                    value - 1);
                                          }
                                        },
                                      );
                                    }
                                    innerState(() => items.removeAt(index));
                                    NavigationHelper.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !items[index].isOpened,
                          child: CircleAvatar(
                            backgroundColor: ColorManager.kRed,
                            radius: 5,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
        ),
      );
}
