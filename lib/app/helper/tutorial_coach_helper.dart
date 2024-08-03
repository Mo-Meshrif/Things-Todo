import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../modules/task/domain/entities/task_to_do.dart';
import '../../modules/task/presentation/controller/task_bloc.dart';
import '../common/widgets/custom_coach_mark.dart';
import '../services/services_locator.dart';
import '../utils/constants_manager.dart';
import 'enums.dart';
import 'shared_helper.dart';

class TutorialCoachHelper {
  static GlobalKey addKey = GlobalKey();
  static GlobalKey taskKey = GlobalKey();
  static List<TargetFocus> _initHomeTarget() => [
        // add_Task
        TargetFocus(
          identify: "add-task",
          keyTarget: addKey,
          enableTargetTab: false,
          paddingFocus: 0,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => CustomCoachMark(
                text: "Use it to add a new task".tr(),
                onNext: () => controller.next(),
                onSkip: () => controller.skip(),
              ),
            ),
          ],
        ),
        //task
        TargetFocus(
          identify: "task",
          keyTarget: taskKey,
          shape: ShapeLightFocus.RRect,
          enableTargetTab: false,
          paddingFocus: 0,
          radius: 5,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => CustomCoachMark(
                hasDivider: true,
                child: Column(
                  children: [
                    Text(
                      'Done-coach'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/coach-mark/done-${context.locale.languageCode}.png',
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'later-coach'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/coach-mark/later-${context.locale.languageCode}.png',
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'double-tap-for-more'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/coach-mark/more.png',
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                finish: 'Finish',
                onNext: () => controller.next(),
                onSkip: () => controller.skip(),
              ),
            ),
          ],
        ),
      ];

  static bool _onPass(BuildContext context, TaskBloc taskBloc) {
    try {
      taskBloc.add(DeleteAllTasksEvent());
      sl<AppShared>().setVal(
        AppConstants.tutorialCoachmarkKey,
        true,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static homeTutorialCoachMark(BuildContext context) {
    TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    taskBloc.add(
      AddTaskEvent(
        taskTodo: TaskTodo(
          name: 'Test',
          category: 'just for test',
          description: '',
          date: DateTime.now().toString(),
          priority: TaskPriority.high,
          important: false,
          speicalKey: UniqueKey().hashCode,
        ),
      ),
    );
    var tutorialCoachMark = TutorialCoachMark(
      targets: _initHomeTarget(),
      pulseEnable: false,
      hideSkip: true,
      onSkip: () => _onPass(context, taskBloc),
      onFinish: () => _onPass(context, taskBloc),
    );
    tutorialCoachMark.show(context: context);
  }
}
