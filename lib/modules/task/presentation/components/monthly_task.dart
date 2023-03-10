import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '/app/helper/extentions.dart';
import '../../../../app/common/widgets/custom_scroll_to_top.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../controller/task_bloc.dart';
import '../widgets/customTaskList/cutom_task_list_tile.dart';

class MonthlyTask extends StatelessWidget {
  const MonthlyTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tappedDate = DateTime.now();
    DateTime selectedDate = DateTime.now();
    List<Map<String, dynamic>> tempList = [];
    CalendarFormat calendarFormat = CalendarFormat.month;
    bool hideTask = false;
    return StatefulBuilder(
      builder: (context, monthlyState) => CustomScrollToTop(
          builder: (context, properties) => SingleChildScrollView(
                controller: properties.scrollController,
                scrollDirection: properties.scrollDirection,
                reverse: properties.reverse,
                primary: properties.primary,
                child: Column(
                  children: [
                    Container(
                      color: ColorManager.kWhite,
                      child: TableCalendar(
                        locale: context.locale.toString(),
                        rowHeight: 110.h,
                        daysOfWeekHeight: 60.h,
                        firstDay:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: tappedDate,
                        currentDay: selectedDate,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarFormat: calendarFormat,
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: false,
                          tablePadding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          headerPadding: EdgeInsets.zero,
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronMargin: EdgeInsets.zero,
                          rightChevronMargin: EdgeInsets.zero,
                          leftChevronIcon: Icon(
                            Icons.arrow_back_ios,
                            color: ColorManager.kGrey,
                          ),
                          rightChevronIcon: Icon(
                            Icons.arrow_forward_ios,
                            color: ColorManager.kGrey,
                          ),
                          titleTextStyle: TextStyle(
                            fontSize: AppSize.s50.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration:
                              BoxDecoration(color: ColorManager.background),
                        ),
                        onDaySelected: (selectedDay, _) => monthlyState(
                          () {
                            hideTask = false;
                            selectedDate = selectedDay;
                          },
                        ),
                        onHeaderTapped: (date) {
                          monthlyState(
                            () {
                              if (calendarFormat == CalendarFormat.week) {
                                calendarFormat = CalendarFormat.month;
                              } else {
                                calendarFormat = CalendarFormat.week;
                              }
                            },
                          );
                          BlocProvider.of<TaskBloc>(context).add(
                            GetMonthlyTasksEvent(
                              date: date,
                              sortedByMonth:
                                  calendarFormat == CalendarFormat.month,
                            ),
                          );
                        },
                        onPageChanged: (date) {
                          BlocProvider.of<TaskBloc>(context).add(
                            GetMonthlyTasksEvent(
                              date: date,
                              sortedByMonth:
                                  calendarFormat == CalendarFormat.month,
                            ),
                          );
                          monthlyState(
                            () => tappedDate = date,
                          );
                        },
                      ),
                    ),
                    BlocConsumer<TaskBloc, TaskState>(
                      listener: (ctx, state) {
                        if (state is AddTaskLoaded ||
                            state is EditTaskLoaded ||
                            state is DeleteTaskLLoaded) {
                          BlocProvider.of<TaskBloc>(ctx).add(
                            GetMonthlyTasksEvent(
                              date: tappedDate,
                            ),
                          );
                        } else if (state is MonthlyTaskLoaded) {
                          monthlyState(
                            () {
                              tempList = [];
                            },
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is MonthlyTaskLoaded ||
                          current is MonthlyTaskLoading,
                      builder: (context, state) {
                        if (tempList.isEmpty) {
                          if (state is MonthlyTaskLoaded) {
                            tempList = HelperFunctions.refactorTaskList(
                              state.monthlyList,
                            );
                          }
                        }
                        int index = tempList.indexWhere((element) =>
                            element['day'] == selectedDate.day &&
                            element['month'] == selectedDate.month);
                        var subList =
                            index == -1 ? [] : tempList.sublist(index);
                        if (calendarFormat == CalendarFormat.month) {
                          hideTask = selectedDate.month != tappedDate.month;
                        } else {
                          var selectedWeek = selectedDate.firstDayOfWeek();
                          var tappedWeek = tappedDate.firstDayOfWeek();
                          hideTask = selectedWeek != tappedWeek;
                        }
                        return hideTask == true
                            ? Lottie.asset(JsonAssets.tap)
                            : subList.isNotEmpty
                                ? Column(
                                    children: List.generate(
                                      subList.length,
                                      (index) {
                                        Map<String, dynamic> item =
                                            subList[index];
                                        String number =
                                            HelperFunctions.getlocaleNumber(
                                                context, '${item['day']}');
                                        String month = HelperFunctions.getMonth(
                                            item['month']);
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: index == 0 ? 5 : 0,
                                            bottom:
                                                subList.indexOf(subList.last) !=
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
                                  )
                                : selectedDate.isAfter(today)
                                    ? Lottie.asset(JsonAssets.addTask)
                                    : Lottie.asset(JsonAssets.empty);
                      },
                    ),
                  ],
                ),
              )),
    );
  }
}