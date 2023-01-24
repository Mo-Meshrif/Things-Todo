import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as format;
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/task_to_do.dart';

class TaskDetailsWidget extends StatelessWidget {
  const TaskDetailsWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskTodo task;

  @override
  Widget build(BuildContext context) {
    bool noDescp = task.description.isEmpty;
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
        vertical: AppPadding.p30,
      ),
      children: <Widget>[
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppStrings.taskName.tr(),
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
            ),
          ),
          child: Text(task.name),
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppStrings.category.tr(),
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
            ),
          ),
          child: Text(task.category),
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: AppStrings.taskDate.tr(),
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s10),
            ),
          ),
          child: Text(format.DateFormat(
            AppConstants.dmyyyyhma,
            context.locale.languageCode,
          ).format(
            DateTime.parse(task.date),
          )),
        ),
        const SizedBox(
          height: AppSize.s20,
        ),
        SizedBox(
          height: ScreenUtil().screenHeight * AppSize.s038,
          child: InputDecorator(
            expands: true,
            textAlignVertical: noDescp ? null : TextAlignVertical.top,
            decoration: InputDecoration(
              labelText: AppStrings.taskDescription.tr(),
              labelStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppPadding.p10,
                horizontal: AppPadding.p12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
            ),
            child: Text(
              noDescp ? AppStrings.noDescp.tr() : task.description,
              textAlign: noDescp ? TextAlign.center : null,
            ),
          ),
        ),
      ],
    );
  }
}
