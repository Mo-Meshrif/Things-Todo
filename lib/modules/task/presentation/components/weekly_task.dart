import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../app/common/widgets/custom_scroll_to_top.dart';
import '../controller/task_bloc.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../widgets/customHorizontalDayList/custom_horizontal_day_list.dart';
import '../widgets/customTaskList/cutom_task_list_tile.dart';

class WeeklyTask extends StatelessWidget {
  const WeeklyTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List<DateTime> dayTimeList = List.generate(
      7,
      (index) => HelperFunctions.getDateByIndex(index),
    );
    List<Map<String, dynamic>> tempList = [];
    DateTime today = DateTime.now();
    int selectedIndex =
        dayTimeList.indexWhere((element) => element.day == today.day);
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (ctx, state) {
        if (state is AddTaskLoaded ||
            state is EditTaskLoaded ||
            state is DeleteTaskLLoaded) {
          BlocProvider.of<TaskBloc>(ctx).add(GetWeeklyTasksEvent());
        } else if (state is WeeklyTaskLoaded) {
          tempList = [];
        }
      },
      buildWhen: (previous, current) =>
          current is WeeklyTaskLoaded || current is WeeklyTaskLoading,
      builder: (ctx, state) => state is WeeklyTaskLoaded
          ? StatefulBuilder(
              builder: (context, weeklyState) {
                if (tempList.isEmpty) {
                  tempList = HelperFunctions.refactorTaskList(
                    state.weeklyList,
                  );
                }
                int searchDay = selectedIndex == -1
                    ? today.day
                    : dayTimeList[selectedIndex].day;
                int index = tempList
                    .indexWhere((element) => element['day'] == searchDay);
                List<Map<String, dynamic>> subList =
                    index == -1 ? [] : tempList.sublist(index);
                return Column(
                  children: [
                    CustomHorizontalDayList(
                      dayList: dayTimeList.map((e) => e.day).toList(),
                      previousIndex: selectedIndex,
                      getSelectedIndex: (index) =>
                          weeklyState(() => selectedIndex = index),
                    ),
                    Expanded(
                      child: subList.isEmpty
                          ? dayTimeList[selectedIndex].isAfter(today)
                              ? Lottie.asset(JsonAssets.addTask)
                              : Lottie.asset(JsonAssets.empty)
                          : CustomScrollToTop(
                              builder: (context, properties) =>
                                  SingleChildScrollView(
                                    controller: properties.scrollController,
                                    scrollDirection: properties.scrollDirection,
                                    reverse: properties.reverse,
                                    primary: properties.primary,
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Column(
                                      children: List.generate(
                                        subList.length,
                                        (index) {
                                          Map<String, dynamic> item =
                                              subList[index];
                                          String number =
                                              HelperFunctions.getlocaleNumber(
                                                  context, '${item['day']}');
                                          String month =
                                              HelperFunctions.getMonth(
                                                  item['month']);
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: subList.indexOf(
                                                          subList.last) !=
                                                      index
                                                  ? 5
                                                  : 0,
                                            ),
                                            child: CustomTaskListTile(
                                              title: item['day'] == today.day
                                                  ? 'Today'.tr()
                                                  : number + ' ' + month.tr(),
                                              taskList: item['tasks'],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: ColorManager.primary,
              ),
            ),
    );
  }
}
