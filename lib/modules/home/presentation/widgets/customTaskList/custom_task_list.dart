import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/task_to_do.dart';
import '../../controller/home_bloc.dart';
import '../customTask/custom_task_widget.dart';

class CustomTaskList extends StatelessWidget {
  final TaskCategory taskCategory;
  final List<TaskTodo> taskList;

  const CustomTaskList({
    Key? key,
    this.taskCategory = TaskCategory.all,
    required this.taskList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.kWhite,
      child: Column(
        children: taskList
            .map(
              (task) => Column(
                children: [
                  HelperFunctions.isExpired(task.date) && !task.done
                      ? task.later
                          ? const Padding(padding: EdgeInsets.zero)
                          : ClipRRect(
                              child: Banner(
                                message: AppStrings.expired.tr(),
                                location: BannerLocation.topEnd,
                                color: ColorManager.kBlack,
                                child: TaskWidget(taskTodo: task),
                              ),
                            )
                      : !task.done || taskCategory != TaskCategory.all
                          ? Dismissible(
                              key: UniqueKey(),
                              direction: taskCategory == TaskCategory.all
                                  ? DismissDirection.horizontal
                                  : taskCategory == TaskCategory.done
                                      ? DismissDirection.startToEnd
                                      : DismissDirection.endToStart,
                              background: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.p10),
                                color: ColorManager.kGreen,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      IconAssets.clipboard,
                                      width: AppSize.s20,
                                      color: ColorManager.kWhite,
                                    ),
                                    const SizedBox(width: AppSize.s10),
                                    Text(
                                      AppStrings.done,
                                      style:
                                          TextStyle(color: ColorManager.kWhite),
                                    ).tr(),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.p10),
                                color: ColorManager.kRed,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      IconAssets.later,
                                      width: AppSize.s20,
                                      color: ColorManager.kWhite,
                                    ),
                                    const SizedBox(width: AppSize.s10),
                                    Text(
                                      task.later
                                          ? AppStrings.laterAgain
                                          : AppStrings.later,
                                      style:
                                          TextStyle(color: ColorManager.kWhite),
                                    ).tr(),
                                  ],
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  BlocProvider.of<HomeBloc>(context).add(
                                    EditTaskEvent(
                                      taskTodo: task.copyWith(
                                        done: true,
                                        later: false,
                                      ),
                                    ),
                                  );
                                  return Future.value(false);
                                } else {
                                  String? pickTime;
                                  HelperFunctions.showDataPicker(
                                      context: context,
                                      onSave: () {
                                        NavigationHelper.pop(context);
                                        BlocProvider.of<HomeBloc>(context).add(
                                          EditTaskEvent(
                                            taskTodo: task.copyWith(
                                              later: true,
                                              date: pickTime ??
                                                  DateTime.now().toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      onTimeChanged: (date) =>
                                          pickTime = date.toString());
                                  return Future.value(false);
                                }
                              },
                              child: task.later
                                  ? ClipRRect(
                                      child: Banner(
                                        message: AppStrings.later.tr(),
                                        location: BannerLocation.topEnd,
                                        color: ColorManager.kRed,
                                        child: TaskWidget(taskTodo: task),
                                      ),
                                    )
                                  : TaskWidget(taskTodo: task),
                            )
                          : ClipRRect(
                              child: Banner(
                                message: AppStrings.done.tr(),
                                location: BannerLocation.topEnd,
                                color: ColorManager.kGreen,
                                child: TaskWidget(taskTodo: task),
                              ),
                            ),
                  Visibility(
                    visible: taskList.last != task,
                    child: const Divider(
                      height: AppConstants.twoVal,
                    ),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
