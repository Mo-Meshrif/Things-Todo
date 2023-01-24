import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../app/common/models/alert_action_model.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/task_to_do.dart';
import '../../controller/home_bloc.dart';
import '../../widgets/customTask/custom_add_edit_task.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/customTask/custom_task_details.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> args;
  const TaskDetailsScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskTodo tempTask = args['task'];
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is EditTaskLoaded) {
            tempTask = state.task!;
          } else if (state is DeleteTaskLLoaded) {
            NavigationHelper.pop(context);
          }
        },
        builder: (context, state) => Stack(
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight * AppSize.s03,
              child: CustomAppBar(
                title: AppStrings.taskDetails,
                hideNotifyIcon: args['hideNotifyIcon'],
              ),
            ),
            Card(
              elevation: AppConstants.twoVal,
              margin: EdgeInsets.symmetric(
                vertical: AppPadding.p230.h,
                horizontal: AppPadding.p15,
              ),
              child: ClipRRect(
                child:
                    HelperFunctions.isExpired(tempTask.date) && !tempTask.done
                        ? Banner(
                            message: AppStrings.expired.tr(),
                            location: BannerLocation.topEnd,
                            color: ColorManager.kBlack,
                            child: TaskDetailsWidget(task: tempTask),
                          )
                        : tempTask.done
                            ? Banner(
                                message: AppStrings.done.tr(),
                                location: BannerLocation.topEnd,
                                color: ColorManager.kGreen,
                                child: TaskDetailsWidget(task: tempTask),
                              )
                            : tempTask.later
                                ? Banner(
                                    message: AppStrings.later.tr(),
                                    location: BannerLocation.topEnd,
                                    color: ColorManager.kRed,
                                    child: TaskDetailsWidget(task: tempTask),
                                  )
                                : TaskDetailsWidget(task: tempTask),
              ),
            ),
            Positioned(
              bottom: AppConstants.zeroVal,
              left: AppConstants.zeroVal,
              right: AppConstants.zeroVal,
              child: Container(
                color: ColorManager.kWhite,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                      vertical: AppPadding.p15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
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
                                  BlocProvider.of<HomeBloc>(context).add(
                                    DeleteTaskEvent(taskId: tempTask.id!),
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
                        InkWell(
                          onTap: () {
                            if (!HelperFunctions.isExpired(tempTask.date)) {
                              if (tempTask.done) {
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
                                    editTask: tempTask,
                                    editFun: (value) =>
                                        context.read<HomeBloc>().add(
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
                        InkWell(
                          onTap: () {
                            if (!HelperFunctions.isExpired(tempTask.date)) {
                              if (tempTask.done) {
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
                                      BlocProvider.of<HomeBloc>(context).add(
                                        EditTaskEvent(
                                          taskTodo: tempTask.copyWith(
                                            later: true,
                                            date: pickTime ??
                                                DateTime.now().toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    onTimeChanged: (date) =>
                                        pickTime = date.toString());
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
                        InkWell(
                          onTap: () {
                            if (!HelperFunctions.isExpired(tempTask.date)) {
                              if (tempTask.done) {
                                HelperFunctions.showSnackBar(
                                  context,
                                  AppStrings.alreadyDone.tr(),
                                );
                              } else {
                                BlocProvider.of<HomeBloc>(context).add(
                                  EditTaskEvent(
                                    taskTodo: tempTask.copyWith(
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
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
