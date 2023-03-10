import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/app/utils/theme_manager.dart';
import 'common/config/config_bloc.dart';
import 'common/models/notifiy_model.dart';
import 'helper/helper_functions.dart';
import 'services/notification_services.dart';
import 'services/services_locator.dart';
import 'utils/constants_manager.dart';
import 'utils/routes_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp._internal();
  static const MyApp _instance = MyApp._internal();
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    sl<ConfigBloc>().add(GetConfigData());
    sl<AwesomeNotifications>().displayedStream.listen(
          (event) => sl<NotificationServices>().saveNotificationData(
            event.toMap(),
          ),
        );
    sl<AwesomeNotifications>().actionStream.listen(
          (event) => HelperFunctions.handleNotificationAction(
            context,
            ReceivedNotifyModel.fromJson(event.toMap()),
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    sl<AwesomeNotifications>().displayedSink.close();
    sl<AwesomeNotifications>().actionSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(1080, 1920),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: AppConstants.appName,
          theme: ThemeManager.lightTheme(),
          onGenerateRoute: RouteGenerator.getRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      );
}
