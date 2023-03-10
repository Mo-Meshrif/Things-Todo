import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:need_resume/need_resume.dart';
import '../../models/notifiy_model.dart';
import '../../../helper/helper_functions.dart';
import '../../../helper/navigation_helper.dart';
import '../../../helper/shared_helper.dart';
import '../../../helper/tutorial_coach_helper.dart';
import '../../../services/services_locator.dart';
import '../../../utils/color_manager.dart';
import '../../../utils/constants_manager.dart';
import '../../../utils/routes_manager.dart';
import '../../../utils/strings_manager.dart';
import '../../../services/notification_services.dart';
import '../../../../modules/task/presentation/controller/task_bloc.dart';
import '../../../../modules/task/presentation/components/daily_task.dart';
import '../../../../modules/task/presentation/components/monthly_task.dart';
import '../../../../modules/task/presentation/components/weekly_task.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_text_search.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  Map<String, dynamic> map = event.data;
  if (HelperFunctions.checkNotificationDisplay(map)) {
    AwesomeNotifications().createNotificationFromJsonData(map);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ResumableState<HomeScreen> {
  int index = 0;
  @override
  void initState() {
    HelperFunctions.checkNotificationsPermission(context, _applyAfterCheck);
    //Handle Firebase Notifications
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic> map = event.data;
      if (HelperFunctions.checkNotificationDisplay(map)) {
        sl<NotificationServices>().createBasicNotification(map);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    super.initState();
  }

  _applyAfterCheck() {
    if (sl<AppShared>().getVal(AppConstants.tutorialCoachmarkKey) == null) {
      //TutorialCoachmark
      TutorialCoachHelper.homeTutorialCoachMark(context);
    } else {
      //Get Daily Tasks on Start
      BlocProvider.of<TaskBloc>(context).add(GetDailyTasksEvent());
    }
  }

  @override
  void onResume() {
    //check version update after every resume
    HelperFunctions.checkUpdate(context);
  }

  @override
  void dispose() {
    sl<NotificationServices>().saveScheduledNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //This line to update TabBar localization
    context.locale.languageCode;
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is GetTaskByIdLoaded) {
            if (state.task != null) {
              if (state.withNav) {
                NavigationHelper.pushNamed(
                  context,
                  Routes.taskDetailsRoute,
                  arguments: {
                    'task': state.task,
                    'hideNotifyIcon': state.hideNotifyIcon,
                  },
                );
              } else {
                BlocProvider.of<TaskBloc>(context).add(
                  EditTaskEvent(
                    taskTodo: state.task!.copyWith(
                      done: true,
                      later: false,
                    ),
                  ),
                );
              }
            } else {
              NavigationHelper.pushNamed(
                context,
                Routes.tempNotifyScreenRoute,
                arguments: ReceivedNotifyModel(id: -1),
              );
            }
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: AppConstants.homeTabLength,
            child: Column(
              children: [
                CustomTextSearch(
                  onTap: () => NavigationHelper.pushNamed(
                    context,
                    Routes.searchRoute,
                  ),
                ),
                TabBar(
                  onTap: (val) {
                    if (index != val) {
                      setState(() {
                        index = val;
                      });
                      HelperFunctions.getTasksOnTab(context, index);
                    }
                  },
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  indicatorColor: Colors.white,
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(text: AppStrings.daily.tr()),
                    Tab(text: AppStrings.weekly.tr()),
                    Tab(text: AppStrings.monthly.tr()),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: ColorManager.background,
                    child: const TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        DailyTask(),
                        WeeklyTask(),
                        MonthlyTask(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
