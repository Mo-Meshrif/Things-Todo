import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/helper/extentions.dart';
import '/app/helper/shared_helper.dart';
import '/app/utils/values_manager.dart';
import '../../app/helper/enums.dart';
import '../../modules/auth/domain/entities/user.dart';
import '../../modules/auth/presentation/controller/auth_bloc.dart';
import '../../modules/help/domain/entities/chat_message.dart';
import '../../modules/task/domain/entities/task_to_do.dart';
import '../../modules/task/presentation/controller/task_bloc.dart';
import '../app.dart';
import '../common/config/config_bloc.dart';
import '../common/models/alert_action_model.dart';
import '../common/models/custom_task_args_model.dart';
import '../common/models/drawer_item_model.dart';
import '../common/models/notifiy_model.dart';
import '../services/notification_services.dart';
import '../services/service_settings.dart';
import '../services/services_locator.dart';
import '../utils/assets_manager.dart';
import '../utils/color_manager.dart';
import '../utils/constants_manager.dart';
import '../utils/routes_manager.dart';
import '../utils/strings_manager.dart';
import 'navigation_helper.dart';
import 'update_checker.dart';

class HelperFunctions {
//checkArabic
  static bool checkArabic(String val) {
    if (val.isNotEmpty) {
      if (!val.contains(RegExp(r'[a-zA-Z]{1,}'))) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //isEmailValid
  static bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  //showSnackBar
  static showSnackBar(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: AppConstants.durationInSec),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
      );
  //showAlert
  static showAlert(
      {required BuildContext context,
      String? title,
      required Widget content,
      List<AlertActionModel>? actions,
      bool forceAndroidStyle = false}) {
    Platform.isAndroid || forceAndroidStyle
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              contentPadding: EdgeInsets.fromLTRB(
                24,
                title == null ? 20 : 10,
                24,
                5,
              ),
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  action.color ?? ColorManager.primary,
                            ),
                            onPressed: action.onPressed,
                            child: Text(action.title),
                          ))
                      .toList(),
            ),
          )
        : showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => CupertinoDialogAction(
                            textStyle: TextStyle(
                              color: action.color ?? ColorManager.primary,
                            ),
                            child: Text(action.title),
                            onPressed: action.onPressed,
                          ))
                      .toList(),
            ),
          );
  }

  //show popUp loading
  static showPopUpLoading(BuildContext context) => showAlert(
        context: context,
        content: SizedBox(
          height: AppSize.s80,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorManager.primary,
            ),
          ),
        ),
      );
  //Rotate value
  static double rotateVal(BuildContext context, {bool rotate = true}) {
    if (rotate && context.locale == AppConstants.arabic) {
      return math.pi;
    } else {
      return math.pi * 2;
    }
  }

  //getSavedUser
  static AuthUser getSavedUser() {
    var savedData = sl<AppShared>().getVal(AppConstants.userKey);
    return savedData is Map
        ? AuthUser(
            id: savedData['id'],
            name: savedData['name'] ?? '',
            email: savedData['email'] ?? '',
            password: savedData['password'],
            pic: savedData['pic'],
            deviceToken: savedData['deviceToken'] ?? '',
            isLocal: savedData['isLocal'] ?? false,
          )
        : savedData;
  }

  //getSignType
  static SignType getSignType(AuthUser authUser) =>
      authUser.password != null ? SignType.email : SignType.social;

  //getLastUserName
  static String lastUserName() {
    AuthUser user = getSavedUser();
    return user.name.split(' ').last;
  }

  //get welcome string
  static String welcome() {
    String mark = DateTime.now().toHourMark();
    return mark == AppStrings.am
        ? AppStrings.goodMorning
        : AppStrings.goodNight;
  }

  //getTasksOnTab
  static getTasksOnTab(BuildContext ctx, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<TaskBloc>(ctx).add(
          GetDailyTasksEvent(),
        );
        break;
      case 1:
        BlocProvider.of<TaskBloc>(ctx).add(
          GetWeeklyTasksEvent(),
        );
        break;
      case 2:
        BlocProvider.of<TaskBloc>(ctx).add(
          GetMonthlyTasksEvent(
            date: DateTime.now(),
          ),
        );
        break;
      default:
    }
  }

  // getDoneTaskLength
  static String doneTasksLength(BuildContext context, List<TaskTodo> tasks) {
    var temp = tasks.where((task) => task.done).toList();
    return getlocaleNumber(context, temp.length);
  }

  // toClock
  static String getlocaleNumber(BuildContext context, number) {
    if (context.locale == AppConstants.arabic) {
      return ArabicNumbers().convert(number);
    } else {
      return number.toString();
    }
  }

  //isExpired
  static bool isExpired(String date) {
    DateTime dateTime = DateTime.parse(date).zeroTime();
    DateTime now = DateTime.now().zeroTime();
    return dateTime.isBefore(now);
  }

  //datePicker
  static showDataPicker(
      {required BuildContext context,
      required void Function() onSave,
      required void Function(DateTime) onTimeChanged,
      void Function()? onclose}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Material(
        color: ColorManager.kWhite,
        child: SizedBox(
          height: ScreenUtil().screenHeight * AppSize.s035,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(
                height: AppConstants.zeroVal,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  onDateTimeChanged: onTimeChanged,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now().subtract(
                    const Duration(seconds: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then(
      (_) => onclose == null ? () {} : onclose(),
    );
  }

  //change language
  static toggleLanguage(BuildContext context) {
    if (context.locale == AppConstants.arabic) {
      context.setLocale(AppConstants.english);
    } else {
      context.setLocale(AppConstants.arabic);
    }
  }

  //convert ringTone to Uint8List
  static Future<Uint8List> getAssetRingToneData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  //getNumberOfDayByIndex
  static DateTime getDateByIndex(int index) {
    DateTime now = DateTime.now();
    return now.add(Duration(days: index + 1 - now.weekday));
  }

  //get month
  static String getMonth(int monthAsInt) {
    late String month;
    switch (monthAsInt) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return month;
  }

  //refactor taskList
  static List<Map<String, dynamic>> refactorTaskList(List<TaskTodo> taskList) {
    List<Map<String, dynamic>> tempList = [];
    for (var item in taskList) {
      DateTime date = DateTime.parse(item.date);
      int indexTemp =
          tempList.indexWhere((element) => element['day'] == date.day);
      if (indexTemp > -1) {
        (tempList[indexTemp]['tasks'] as List).add(item);
      } else {
        tempList.add(
          {
            'day': date.day,
            'month': date.month,
            'tasks': [item],
          },
        );
      }
    }
    tempList.sort((a, b) => a['day'].compareTo(b['day']));
    return tempList;
  }

  //get chatGroupId
  static String getChatGroupId(String peerId) {
    String uid = getSavedUser().id;
    if (uid.compareTo(peerId) > 0) {
      return '$uid - $peerId';
    } else {
      return '$peerId - $uid';
    }
  }

  //refactor chatList
  static List<ChatMessage> refactorChatList(
      List<ChatMessage> oldList, List<ChatMessage> snapList, String uid) {
    if (oldList.isEmpty || snapList.isEmpty) {
      return snapList;
    } else {
      for (var element in snapList) {
        int tempIndex = oldList.indexWhere(
          (e) => e.idFrom == uid && e.timestamp == element.timestamp,
        );
        if (tempIndex > -1) {
          oldList[tempIndex] = oldList[tempIndex].copyBaseWith(
            content: element.content,
            isLoading: false,
            isLocal: false,
          );
        } else {
          oldList.add(element);
        }
      }
      return oldList;
    }
  }

  //Check notifications permission
  static checkNotificationsPermission(
      BuildContext context, Function applyAfter) {
    sl<AwesomeNotifications>().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        if (Platform.isIOS) {
          sl<AwesomeNotifications>()
              .requestPermissionToSendNotifications()
              .then((_) => applyAfter());
        } else {
          showAlert(
            context: context,
            title: 'Allow Notifications',
            content: const Text('Our app would like to send you notifications'),
            actions: [
              AlertActionModel(
                title: 'Allow',
                onPressed: () => sl<AwesomeNotifications>()
                    .requestPermissionToSendNotifications()
                    .then((_) {
                  Navigator.pop(context);
                  applyAfter();
                }),
              ),
              AlertActionModel(
                title: 'Don\'t Allow',
                onPressed: () {
                  Navigator.pop(context);
                  applyAfter();
                },
              ),
            ],
          );
        }
      } else {
        applyAfter();
      }
    });
  }

  //notification action
  static handleNotificationAction(
    BuildContext context,
    ReceivedNotifyModel event, {
    bool hideNotifyIcon = false,
  }) {
    if (event.type == MessageType.task) {
      //Local Notifications
      debugPrint('Local Notifications action');
      if (event.buttonKeyPressed!.isNotEmpty && !event.isOpened) {
        debugPrint('Notification key pressed: ${event.buttonKeyPressed}');
        BlocProvider.of<TaskBloc>(context).add(
          GetTaskByIdEvent(
            taskId: int.parse(event.payload!['taskId']),
            withNav: false,
          ),
        );
      } else {
        BlocProvider.of<TaskBloc>(context).add(
          GetTaskByIdEvent(
            taskId: int.parse(event.payload!['taskId']),
            withNav: true,
            hideNotifyIcon: hideNotifyIcon,
          ),
        );
      }
    } else if (event.type == MessageType.problem) {
      //Remote notification
      debugPrint('Remote Notifications action');
      navigatorKey.currentState?.pushNamed(
        Routes.tempNotifyScreenRoute,
        arguments: event,
      );
    } else {
      //Remote notification
      debugPrint('Remote Notifications action');
      navigatorKey.currentState?.pushNamed(
        Routes.chatRoute,
      );
    }
    if (!event.isOpened) {
      sl<NotificationServices>().saveNotificationData(
        event.toJson(),
      );
      sl<AwesomeNotifications>().getGlobalBadgeCounter().then(
        (value) {
          if (value > 0) {
            sl<AwesomeNotifications>().setGlobalBadgeCounter(value - 1);
          }
        },
      );
    }
  }

  //Display notification or not
  static bool checkNotificationDisplay(Map<String, dynamic> map) {
    ReceivedNotifyModel receivedNotify = ReceivedNotifyModel.fromJson(
      map['content'] is String ? jsonDecode(map['content']) : map['content'],
    );
    if (receivedNotify.type != MessageType.problem) {
      String val = sl<AppShared>().getVal(AppConstants.chatKey) ?? '';
      if (val.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  //update app
  static checkUpdate(BuildContext context) {
    if (sl<AppShared>().getVal(AppConstants.tutorialCoachmarkKey) != null) {
      if (sl<AppShared>().getVal(AppConstants.updateAlertkKey) == null) {
        sl<ServiceSettings>().getServiceSettings().then((config) {
          if (config != null) {
            sl<ConfigBloc>().add(UpdateConfigData(config: config));
            bool forceUpdate = config.version.forceUpdate;
            String? remoteDescription =
                config.version.description[context.locale.languageCode];
            String localDescription = forceUpdate
                ? AppStrings.requiredUpdateDescription.tr()
                : AppStrings.recommededUpdateDescription.tr();
            UpdateChecker.displayUpdateAlert(
              context,
              forceUpdate: forceUpdate,
              title: AppStrings.updateTitle.tr(),
              description: remoteDescription ?? localDescription,
              updateButtonLabel: AppStrings.updateButtonLabel.tr(),
              closeButtonLabel: AppStrings.closeButtonLabel.tr(),
              ignoreButtonLabel: AppStrings.ignoreButtonLabel.tr(),
              onOpenAlert: () => sl<AppShared>().setVal(
                AppConstants.updateAlertkKey,
                true,
              ),
              onExitAlert: () => sl<AppShared>().removeVal(
                AppConstants.updateAlertkKey,
              ),
            );
          }
        });
      }
    }
  }

  //encrptPassword
  static String encrptPassword(String password) => DBCrypt().hashpw(
        password,
        DBCrypt().gensalt(),
      );

  static bool checkPassword(String plaintext, String hashed) =>
      DBCrypt().checkpw(plaintext, hashed);

  //getDrawerItemList
  static List<DrawerItemModel> getDrawerItemList(BuildContext context) {
    AuthUser user = getSavedUser();
    List<DrawerItemModel> pageList = [
      DrawerItemModel(
        title: AppStrings.important,
        icon: IconAssets.importantWhite,
        size: AppSize.s25,
        rotate: false,
        onTap: () => NavigationHelper.pushNamed(
          context,
          Routes.customRoute,
          arguments: CustomTaskArgsModel(
            appTitle: 'Important Tasks',
            type: 'important',
          ),
        ),
      ),
      DrawerItemModel(
        title: AppStrings.done,
        icon: IconAssets.done,
        size: AppSize.s25,
        rotate: false,
        onTap: () => NavigationHelper.pushNamed(
          context,
          Routes.customRoute,
          arguments: CustomTaskArgsModel(
            appTitle: 'Done Tasks',
            type: 'done',
          ),
        ),
      ),
      DrawerItemModel(
        title: AppStrings.later,
        icon: IconAssets.later,
        size: AppSize.s25,
        rotate: false,
        onTap: () => NavigationHelper.pushNamed(
          context,
          Routes.customRoute,
          arguments: CustomTaskArgsModel(
            appTitle: 'Later Tasks',
            type: 'later',
          ),
        ),
      ),
      DrawerItemModel(
        title: AppStrings.settings,
        icon: IconAssets.settings,
        size: AppSize.s25,
        rotate: false,
        onTap: () => NavigationHelper.pushNamed(
          context,
          Routes.settingsRoute,
        ),
      ),
      DrawerItemModel(
        title: AppStrings.logout,
        icon: IconAssets.logout,
        size: AppSize.s20,
        rotate: true,
        onTap: () => sl<AuthBloc>().add(
          LogoutEvent(uid: user.id),
        ),
      ),
    ];
    if (user.isLocal) {
      pageList.removeLast();
    }
    return pageList;
  }

  //contact with mail
  static sendMail({
    required BuildContext context,
    required String mail,
    String message = '',
  }) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: mail,
      query: Uri.encodeFull(
        'subject=${AppConstants.appName} Problem&body=$message',
      ),
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      showSnackBar(
        context,
        AppStrings.later.tr(),
      );
    }
  }
}
