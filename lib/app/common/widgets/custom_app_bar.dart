import 'package:badges/badges.dart' as badge;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../modules/auth/presentation/controller/auth_bloc.dart';
import '../../../modules/task/presentation/controller/task_bloc.dart';
import '../../../modules/task/presentation/widgets/customTask/custom_add_edit_task.dart';
import '../../helper/helper_functions.dart';
import '../../helper/navigation_helper.dart';
import '../../helper/shared_helper.dart';
import '../../helper/tutorial_coach_helper.dart';
import '../../services/services_locator.dart';
import '../../utils/assets_manager.dart';
import '../../utils/constants_manager.dart';
import '../../utils/routes_manager.dart';
import '../../utils/values_manager.dart';
import '../models/notifiy_model.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    String? title,
    bool hideNotifyIcon = false,
    Widget? clearNotify,
  }) : super(
          key: key,
          leading: title != null
              ? null
              : BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthPopUpLoading) {
                      HelperFunctions.showPopUpLoading(context);
                    } else if (state is AuthFailure) {
                      NavigationHelper.pop(context);
                      HelperFunctions.showSnackBar(context, state.msg.tr());
                    } else if (state is AuthLogoutSuccess) {
                      sl<AppShared>().removeVal(AppConstants.authPassKey);
                      sl<AppShared>().setVal(AppConstants.authPassKey, false);
                      sl<FirebaseMessaging>().unsubscribeFromTopic(
                        AppConstants.toUser,
                      );
                      NavigationHelper.pushNamedAndRemoveUntil(
                        context,
                        Routes.authRoute,
                        (route) => false,
                      );
                    } else if (state is AuthDeleteSuccess) {
                      sl<TaskBloc>().add(DeleteAllTasksEvent());
                      sl<AppShared>().removeVal(AppConstants.authPassKey);
                      sl<AppShared>().setVal(AppConstants.authPassKey, false);
                      sl<FirebaseMessaging>().unsubscribeFromTopic(
                        AppConstants.toUser,
                      );
                      NavigationHelper.pushNamedAndRemoveUntil(
                        context,
                        Routes.authRoute,
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, _) => Transform(
                    alignment: Alignment.center,
                    transform:
                        Matrix4.rotationY(HelperFunctions.rotateVal(context)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p15),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: SvgPicture.asset(
                          IconAssets.menubar,
                        ),
                      ),
                    ),
                  ),
                ),
          centerTitle: hideNotifyIcon,
          title: title != null
              ? Text(title).tr()
              : SvgPicture.asset(
                  IconAssets.appTitle,
                  width: AppSize.s120,
                ),
          actions: [
            Builder(builder: (context) {
              var notificationList = Hive.box(AppConstants.notificaionKey);
              return ValueListenableBuilder(
                valueListenable: notificationList.listenable(),
                builder: (context, _, __) {
                  String uid = HelperFunctions.getSavedUser().id;
                  List<ReceivedNotifyModel> savedList = notificationList.values
                      .map((e) => ReceivedNotifyModel.fromJson(
                          Map<String, dynamic>.from(e)))
                      .toList();
                  List<ReceivedNotifyModel> items =
                      savedList.where((e) => e.to == uid).toList();
                  items.sort((a, b) => b.date!.compareTo(a.date!));
                  List<ReceivedNotifyModel> notOpenedList =
                      items.where((e) => !e.isOpened).toList();
                  return clearNotify != null && items.isNotEmpty
                      ? clearNotify
                      : hideNotifyIcon
                          ? const Padding(padding: EdgeInsets.zero)
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p10,
                              ),
                              child: badge.Badge(
                                position: badge.BadgePosition.topEnd(
                                  top: AppSize.s12,
                                  end: AppSize.s15,
                                ),
                                showBadge: notOpenedList.isNotEmpty,
                                child: GestureDetector(
                                  onTap: () => NavigationHelper.pushNamed(
                                    context,
                                    Routes.notificationRoute,
                                    arguments: items,
                                  ),
                                  child: SvgPicture.asset(
                                    IconAssets.alarm,
                                    width: AppSize.s25,
                                  ),
                                ),
                              ),
                            );
                },
              );
            }),
            Visibility(
              visible: title == null,
              child: Builder(
                builder: (context) {
                  bool tutorialPass = sl<AppShared>().getVal(
                        AppConstants.tutorialCoachmarkKey,
                      ) ??
                      false;
                  return IconButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSize.s30.r),
                          topRight: Radius.circular(AppSize.s30.r),
                        ),
                      ),
                      builder: (context) => AddEditTaskWidget(
                        addFun: (task) => context.read<TaskBloc>().add(
                              AddTaskEvent(
                                taskTodo: task,
                              ),
                            ),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      IconAssets.add,
                      key: tutorialPass ? null : TutorialCoachHelper.addKey,
                      width: AppSize.s25,
                    ),
                  );
                },
              ),
            ),
          ],
        );
}
