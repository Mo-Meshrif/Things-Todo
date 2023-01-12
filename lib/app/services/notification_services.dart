import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../modules/home/domain/entities/task_to_do.dart';
import '../common/models/notifiy_model.dart';
import '../helper/helper_functions.dart';
import '../utils/color_manager.dart';
import '../utils/constants_manager.dart';

abstract class NotificationServices {
  Future<bool> init();
  Future<bool> sendNotification(NotifyActionModel notifyActionModel);
  Future<void> createBasicNotification(Map<String, dynamic> map);
  Future<void> createTaskReminderNotification(TaskTodo taskTodo);
  Future<void> cancelScheduledNotifications(int id);
  Future<void> saveNotificationData(
    Map<String, dynamic> notiMap,
    bool opened, {
    bool fromNotScreen = false,
  });
  Future<void> deleteNotificationData(key);
  Future<void> deleteAllNotificationData();
  Future<void> saveScheduledNotifications(
      List<NotificationModel> scheduledNotifications);
  Future<void> scheduledNotificationsAgain(String uid);
}

class NotificationServicesImpl implements NotificationServices {
  final AwesomeNotifications awesomeNotifications;
  NotificationServicesImpl(this.awesomeNotifications);
  
  @override
  Future<bool> init() => awesomeNotifications.initialize(
        'resource://drawable/app_icon',
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Notification channel for Basic',
            defaultColor: ColorManager.primary,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/alarm_clock',
            channelShowBadge: true,
            locked: true,
          ),
        ],
      );

  @override
  Future<bool> sendNotification(NotifyActionModel notifyActionModel) async {
    var client = http.Client();
    var response = await client.post(
      Uri.parse(AppConstants.fcmLink),
      body: jsonEncode(
        {
          "to": notifyActionModel.to,
          "priority": "high",
          "data": {
            "content": {
              'id': notifyActionModel.id,
              "channelKey": "basic_channel",
              'title': notifyActionModel.title,
              'body': notifyActionModel.body,
            }
          }
        },
      ),
      headers: {
        "Authorization": "key=${AppConstants.serverKey}",
        "Content-Type": "application/json",
      },
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse['success'] == 1;
  }

  @override
  Future<void> createBasicNotification(Map<String, dynamic> map) =>
      awesomeNotifications.createNotificationFromJsonData(map);

  @override
  Future<void> createTaskReminderNotification(TaskTodo taskTodo) async {
    DateTime date = DateTime.parse(taskTodo.date);
    awesomeNotifications.createNotification(
      content: NotificationContent(
        id: taskTodo.id!,
        channelKey: 'basic_channel',
        title: taskTodo.name,
        body: taskTodo.description,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Alarm,
        autoDismissible: false,
        fullScreenIntent: true,
        wakeUpScreen: true,
        criticalAlert: true,
        showWhen: true,
        summary: 'Task',
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'MARK_DONE',
          label: 'Mark Done'.tr(),
        )
      ],
      schedule: NotificationCalendar(
        allowWhileIdle: true,
        year: date.year,
        month: date.month,
        day: date.day,
        weekday: date.weekday,
        hour: date.hour,
        minute: date.minute,
        second: 0,
        millisecond: 0,
      ),
    );
  }

  @override
  Future<void> cancelScheduledNotifications(int id) =>
      awesomeNotifications.cancel(id);

  @override
  Future<void> saveNotificationData(
    Map<String, dynamic> notiMap,
    bool opened, {
    bool fromNotScreen = false,
  }) async {
    late Map<String, dynamic> map;
    final list = Hive.box(AppConstants.notificaionKey);
    bool isExists = list.containsKey(notiMap['id']);
    if (isExists) {
      map = Map.from(list.get(notiMap['id']));
      map['isOpened'] = opened;
      if (!fromNotScreen) {
        map['date'] = DateTime.now();
      }
    } else {
      map = {
        'date': DateTime.now(),
        'isOpened': opened,
        'to': HelperFunctions.getSavedUser().id,
      };
    }
    await list.put(
        notiMap['id'],
        isExists ? map : map
          ..addAll(notiMap));
  }

  @override
  Future<void> deleteNotificationData(id) async {
    final not = Hive.box(AppConstants.notificaionKey);
    await not.delete(id);
  }

  @override
  Future<void> deleteAllNotificationData() async {
    final not = Hive.box(AppConstants.notificaionKey);
    await not.clear();
    await awesomeNotifications.resetGlobalBadge();
  }

  @override
  Future<void> saveScheduledNotifications(
      List<NotificationModel> scheduledNotifications) async {
    final list = Hive.box(AppConstants.scheduledNotKey);
    List tempList = scheduledNotifications
        .map((element) => {
              'content': element.content!.toMap(),
              'actionButtons':
                  element.actionButtons!.map((e) => e.toMap()).toList(),
              'schedule': element.schedule!.toMap(),
            })
        .toList();
    await list.put(
      HelperFunctions.getSavedUser().id,
      tempList,
    );
  }

  @override
  Future<void> scheduledNotificationsAgain(String uid) async {
    final list = Hive.box(AppConstants.scheduledNotKey);
    bool isExists = list.containsKey(uid);
    if (isExists) {
      List prevoiusNotifications = list.get(uid);
      for (var element in prevoiusNotifications) {
        Map schedule = element['schedule'];
        DateTime notifyDate = DateTime(
          schedule['year'],
          schedule['month'],
          schedule['day'],
          schedule['minute'],
        );
        if (notifyDate.isBefore(DateTime.now())) {
          saveNotificationData(element['content'], false);
          awesomeNotifications.incrementGlobalBadgeCounter();
        } else {
          awesomeNotifications.createNotificationFromJsonData(element);
        }
      }
    }
  }
}
