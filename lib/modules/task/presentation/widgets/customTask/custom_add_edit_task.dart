import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as format;

import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../task/domain/entities/task_to_do.dart';

class AddEditTaskWidget extends StatefulWidget {
  final TaskTodo? editTask;
  final void Function(TaskTodo task)? addFun;
  final void Function(TaskTodo task)? editFun;
  const AddEditTaskWidget({
    Key? key,
    this.addFun,
    this.editTask,
    this.editFun,
  }) : super(key: key);

  @override
  State<AddEditTaskWidget> createState() => _AddEditTaskWidgetState();
}

class _AddEditTaskWidgetState extends State<AddEditTaskWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode catFocusNode = FocusNode();
  FocusNode descpFocusNode = FocusNode();
  late TextEditingController taskNameController =
      TextEditingController(text: widget.editTask?.name);
  late TextEditingController categoryController =
      TextEditingController(text: widget.editTask?.category);
  late TextEditingController dateController = TextEditingController(
    text: widget.editTask == null
        ? null
        : format.DateFormat(AppConstants.dmyyyyhma).format(
            DateTime.parse(widget.editTask!.date),
          ),
  );
  late TextEditingController descriptionController =
      TextEditingController(text: widget.editTask?.description);
  late TaskPriority taskPriority =
      widget.editTask?.priority ?? TaskPriority.high;
  DateTime? dateTime;
  DateTime? tempTime;

  _datePicker() => HelperFunctions.showDataPicker(
        context: context,
        onSave: () {
          setState(
            () {
              if (tempTime == null) {
                dateTime = DateTime.now();
              } else {
                dateTime = tempTime;
              }
            },
          );
          dateController.text = format.DateFormat(
            AppConstants.dmyyyyhma,
            context.locale.languageCode,
          ).format(dateTime!);
          NavigationHelper.pop(context);
        },
        onTimeChanged: (value) => setState(() => tempTime = value),
        onclose: () {
          if (dateController.text.isNotEmpty) {
            FocusScope.of(context).requestFocus(descpFocusNode);
          }
        },
      );
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p15, vertical: AppPadding.p20),
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Form(
              key: _formKey,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: taskNameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(catFocusNode),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppStrings.enterTaskName.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: AppStrings.taskName.tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s10,
                    ),
                    TextFormField(
                      controller: categoryController,
                      textInputAction: TextInputAction.next,
                      focusNode: catFocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppStrings.enterTaskCategory.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) => _datePicker(),
                      decoration: InputDecoration(
                        labelText: AppStrings.category.tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s15,
                    ),
                    const Text(AppStrings.taskPriority).tr(),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: AppConstants.oneVal,
                            title: Text(
                              AppStrings.high,
                              style: TextStyle(fontSize: AppSize.s36.sp),
                            ).tr(),
                            leading: Radio<TaskPriority>(
                              value: TaskPriority.high,
                              activeColor: ColorManager.kRed,
                              groupValue: taskPriority,
                              onChanged: (value) => setState(
                                () => taskPriority = value!,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: AppConstants.oneVal,
                            title: Text(
                              AppStrings.medium,
                              style: TextStyle(fontSize: AppSize.s36.sp),
                            ).tr(),
                            leading: Radio<TaskPriority>(
                              value: TaskPriority.medium,
                              groupValue: taskPriority,
                              activeColor: ColorManager.kOrange,
                              onChanged: (value) => setState(
                                () => taskPriority = value!,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSize.s10),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: AppConstants.oneVal,
                            title: Text(
                              AppStrings.low,
                              style: TextStyle(fontSize: AppSize.s36.sp),
                            ).tr(),
                            leading: Radio<TaskPriority>(
                              value: TaskPriority.low,
                              activeColor: ColorManager.kYellow,
                              groupValue: taskPriority,
                              onChanged: (value) => setState(
                                () => taskPriority = value!,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSize.s10,
                    ),
                    TextFormField(
                      onTap: _datePicker,
                      readOnly: true,
                      controller: dateController,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppStrings.enterTaskDate.tr();
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: AppStrings.taskDate.tr(),
                        labelStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s10,
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      child: TextFormField(
                        maxLines: AppConstants.maxLines,
                        controller: descriptionController,
                        textInputAction: TextInputAction.done,
                        focusNode: descpFocusNode,
                        decoration: InputDecoration(
                          hintText: AppStrings.taskDescription.tr(),
                          contentPadding: const EdgeInsets.all(
                            AppPadding.p10,
                          ),
                          hintStyle: TextStyle(color: ColorManager.kBlack),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s70,
                    ),
                  ],
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  NavigationHelper.pop(context);
                  if (widget.editTask == null) {
                    widget.addFun!(
                      TaskTodo(
                        name: taskNameController.text,
                        description: descriptionController.text,
                        category: categoryController.text,
                        date: dateTime.toString(),
                        priority: taskPriority,
                        important: false,
                        speicalKey: UniqueKey().hashCode,
                      ),
                    );
                  } else {
                    widget.editFun!(widget.editTask!.copyWith(
                      name: taskNameController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      date: dateTime?.toString(),
                      priority: taskPriority,
                      speicalKey: UniqueKey().hashCode,
                    ));
                  }
                }
              },
              backgroundColor: ColorManager.primary,
              child: Icon(widget.editTask == null ? Icons.add : Icons.edit),
            )
          ],
        ),
      );
}
