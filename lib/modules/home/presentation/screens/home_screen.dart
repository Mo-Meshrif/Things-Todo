import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/common/models/notifiy_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/navigation_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/services/notification_services.dart';
import '../components/daily_task.dart';
import '../components/monthly_task.dart';
import '../components/weekly_task.dart';
import '../controller/home_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_text_search.dart';

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

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  void initState() {
    HelperFunctions.checkNotificationsPermission(context);
    //Handle Firebase Notifications
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic> map = event.data;
      if (HelperFunctions.checkNotificationDisplay(map)) {
        sl<NotificationServices>().createBasicNotification(map);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //Get Daily Tasks on Start
    BlocProvider.of<HomeBloc>(context).add(GetDailyTasksEvent());
    super.initState();
  }

  @override
  void dispose() {
    sl<AwesomeNotifications>().listScheduledNotifications().then((value) {
      sl<NotificationServices>().saveScheduledNotifications(value);
      sl<AwesomeNotifications>().cancelAllSchedules();
    });
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
      body: BlocConsumer<HomeBloc, HomeState>(
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
                BlocProvider.of<HomeBloc>(context).add(
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
