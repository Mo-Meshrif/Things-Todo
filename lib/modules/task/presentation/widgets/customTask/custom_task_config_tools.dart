import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/modules/task/domain/usecases/delete_task_use_case.dart';
import '../../../../../app/common/models/alert_action_model.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../task/domain/entities/task_to_do.dart';
import '../../../../task/presentation/controller/task_bloc.dart';
import 'custom_add_edit_task.dart';

class TaskConfigTools extends StatelessWidget {
  const TaskConfigTools({
    Key? key,
    required this.taskTodo,
  }) : super(key: key);

  final TaskTodo taskTodo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: 'Delete task'.tr(),
          child: InkWell(
            onTap: () => HelperFunctions.showAlert(
              context: context,
              content: const Text(AppStrings.deleteTask).tr(),
              actions: [
                AlertActionModel(
                  title: AppStrings.cancel.tr(),
                  onPressed: () => NavigationHelper.pop(context),
                ),
                AlertActionModel(
                  title: AppStrings.delete.tr(),
                  onPressed: () {
                    BlocProvider.of<TaskBloc>(context).add(
                      DeleteTaskEvent(
                        deleteTaskParameters: DeleteTaskParameters(
                          taskId: taskTodo.id!,
                          speicalKey: taskTodo.speicalKey,
                        ),
                      ),
                    );
                    NavigationHelper.pop(context);
                  },
                ),
              ],
            ),
            child: SvgPicture.asset(
              IconAssets.delete,
              width: AppSize.s15,
            ),
          ),
        ),
        Tooltip(
          message: 'Edit task'.tr(),
          child: InkWell(
            onTap: () {
              if (!HelperFunctions.isExpired(taskTodo.date)) {
                if (taskTodo.done) {
                  HelperFunctions.showSnackBar(
                    context,
                    AppStrings.noEditDone.tr(),
                  );
                } else {
                  showBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSize.s30.r),
                        topRight: Radius.circular(AppSize.s30.r),
                      ),
                    ),
                    builder: (context) => AddEditTaskWidget(
                      editTask: taskTodo,
                      editFun: (value) => context.read<TaskBloc>().add(
                            EditTaskEvent(
                              taskTodo: value,
                            ),
                          ),
                    ),
                  );
                }
              } else {
                HelperFunctions.showSnackBar(
                  context,
                  AppStrings.expiryTask.tr(),
                );
              }
            },
            child: SvgPicture.asset(
              IconAssets.edit,
              width: AppSize.s15,
            ),
          ),
        ),
        Tooltip(
          message: 'Mark later'.tr(),
          child: InkWell(
            onTap: () {
              if (!HelperFunctions.isExpired(taskTodo.date)) {
                if (taskTodo.done) {
                  HelperFunctions.showSnackBar(
                    context,
                    AppStrings.noChangeDone.tr(),
                  );
                } else {
                  String? pickTime;
                  HelperFunctions.showDataPicker(
                      context: context,
                      onSave: () {
                        NavigationHelper.pop(context);
                        BlocProvider.of<TaskBloc>(context).add(
                          EditTaskEvent(
                            taskTodo: taskTodo.copyWith(
                              later: true,
                              date: pickTime ?? DateTime.now().toString(),
                            ),
                          ),
                        );
                      },
                      onTimeChanged: (date) => pickTime = date.toString());
                }
              } else {
                HelperFunctions.showSnackBar(
                  context,
                  AppStrings.expiryTask.tr(),
                );
              }
            },
            child: SvgPicture.asset(
              IconAssets.later,
              width: AppSize.s20,
            ),
          ),
        ),
        Tooltip(
          message: 'Mark done'.tr(),
          child: InkWell(
            onTap: () {
              if (!HelperFunctions.isExpired(taskTodo.date)) {
                if (taskTodo.done) {
                  HelperFunctions.showSnackBar(
                    context,
                    AppStrings.alreadyDone.tr(),
                  );
                } else {
                  BlocProvider.of<TaskBloc>(context).add(
                    EditTaskEvent(
                      taskTodo: taskTodo.copyWith(
                        done: true,
                        later: false,
                      ),
                    ),
                  );
                }
              } else {
                HelperFunctions.showSnackBar(
                  context,
                  AppStrings.expiryTask.tr(),
                );
              }
            },
            child: SvgPicture.asset(
              IconAssets.done,
              width: AppSize.s20,
            ),
          ),
        ),
      ],
    );
  }
}
