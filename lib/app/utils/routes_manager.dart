import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../modules/home/presentation/screens/subScreens/custom_tasks_screen.dart';
import '../../modules/home/presentation/screens/subScreens/help_screen.dart';
import '../../modules/home/presentation/screens/subScreens/temp_notify_screen.dart';
import '../../modules/home/presentation/screens/subScreens/notification_screen.dart';
import '../../modules/home/presentation/screens/subScreens/search_screen.dart';
import '../../modules/home/presentation/screens/subScreens/settings_screen.dart';
import '../../modules/home/presentation/screens/subScreens/task_details_screen.dart';
import '../common/models/custom_task_args_model.dart';
import '../common/models/notifiy_model.dart';
import '../helper/shared_helper.dart';
import '../services/services_locator.dart';
import '/modules/home/presentation/screens/home_screen.dart';
import '../../modules/auth/presentation/screens/auth_screen.dart';
import 'constants_manager.dart';

class Routes {
  static const String authRoute = "/auth";
  static const String homeRoute = "/main";
  static const String notificationRoute = "/notification";
  static const String searchRoute = "/searchRoute";
  static const String taskDetailsRoute = "/taskDetailsRoute";
  static const String customRoute = "/custom";
  static const String settingsRoute = "/settings";
  static const String helpRoute = "/help";
  static const String tempNotifyScreenRoute = "/tempNotifyScreen";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.authRoute:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.notificationRoute:
        return MaterialPageRoute(
          builder: (_) => NotificationScreen(
            items: settings.arguments as List<ReceivedNotifyModel>,
          ),
        );
      case Routes.searchRoute:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case Routes.taskDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => TaskDetailsScreen(
            args: settings.arguments as Map<String, dynamic>,
          ),
        );
      case Routes.customRoute:
        return MaterialPageRoute(
          builder: (_) => CustomTasksScreen(
            args: settings.arguments as CustomTaskArgsModel,
          ),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.helpRoute:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case Routes.tempNotifyScreenRoute:
        return MaterialPageRoute(
          builder: (_) => TempNotifyScreen(
            receivedNotifyModel: settings.arguments as ReceivedNotifyModel,
          ),
        );
      default:
        return controlRoute();
    }
  }

  static Route<dynamic> controlRoute() {
    return MaterialPageRoute(
      builder: (_) {
        FlutterNativeSplash.remove();
        AppShared appShared = sl<AppShared>();
        bool authPass = appShared.getVal(AppConstants.authPassKey) ?? false;
        return authPass ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}
