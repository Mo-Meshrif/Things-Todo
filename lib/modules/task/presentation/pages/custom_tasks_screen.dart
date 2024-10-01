import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/models/custom_task_args_model.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../app/common/widgets/custom_app_bar.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../domain/entities/task_to_do.dart';
import '../controller/task_bloc.dart';
import '../widgets/customTaskList/custom_task_list.dart';

class CustomTasksScreen extends StatefulWidget {
  final CustomTaskArgsModel args;
  const CustomTasksScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<CustomTasksScreen> createState() => _CustomTasksScreenState();
}

class _CustomTasksScreenState extends State<CustomTasksScreen> {
  bool showEmpty = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(
      GetCustomTasksEvent(widget.args.type),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: widget.args.appTitle,
        ),
        body: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is CustomTaskLoaded) {
              List<TaskTodo> customlaterTasks = state.customList
                  .where((task) =>
                      HelperFunctions.isExpired(task.date) && !task.done)
                  .toList();
              showEmpty = customlaterTasks.length == state.customList.length;
            } else if (state is EditTaskLoaded || state is DeleteTaskLLoaded) {
              BlocProvider.of<TaskBloc>(context).add(
                GetCustomTasksEvent(widget.args.type),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is CustomTaskLoaded || current is CustomTaskLoading,
          builder: (context, state) => state is CustomTaskLoaded
              ? state.customList.isNotEmpty && !showEmpty
                  ? SingleChildScrollView(
                      child: CustomTaskList(
                        taskList: state.customList,
                        fromCustomTasksScreen: true,
                      ),
                    )
                  : Center(child: Lottie.asset(JsonAssets.empty))
              : Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primary,
                  ),
                ),
        ),
      );
}
