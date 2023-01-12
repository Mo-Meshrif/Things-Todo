import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../controller/home_bloc.dart';
import '/app/helper/extentions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/task_to_do.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.taskTodo,
  }) : super(key: key);

  final TaskTodo taskTodo;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.parse(taskTodo.date);
    return ListTile(
      title: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pushNamed(
          Routes.taskDetailsRoute,
          arguments: {
            'task': taskTodo,
            'hideNotifyIcon': false,
          },
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  HelperFunctions.getlocaleNumber(
                    context,
                    date.toClock(),
                  ),
                ),
                Text(date.toHourMark().tr()),
              ],
            ),
            const SizedBox(width: AppSize.s10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(taskTodo.name),
                Text(
                  taskTodo.category,
                  style: TextStyle(color: ColorManager.kGrey),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => BlocProvider.of<HomeBloc>(context).add(
              EditTaskEvent(
                taskTodo: taskTodo.copyWith(important: !taskTodo.important),
              ),
            ),
            child: taskTodo.important
                ? SvgPicture.asset(
                    IconAssets.importantColor,
                    width: AppSize.s25,
                  )
                : SvgPicture.asset(
                    IconAssets.importantWhite,
                    width: AppSize.s15,
                  ),
          ),
          SizedBox(width: taskTodo.important ? AppSize.s10 : AppSize.s15),
          CircleAvatar(
            radius: AppSize.s20.r,
            backgroundColor: taskTodo.priority.toColor(),
          ),
        ],
      ),
    );
  }
}
