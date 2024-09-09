import 'package:convention_calendar/src/flutter_convention_calender.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class ConventionCalendarPicker  {

Future<DateTime?> showConventionCalendarPicker({
  required BuildContext context,
  required DateTime firstday,
  required DateTime lastDay,
  required DateTime focusedDay,
  Color? rangeHighLightColor,
  CalendarStyle? calendarStyle,
  HeaderStyle? headerStyle,
  CalendarBuilders? calendarBuilders,
  List<DateTime>? holidays,
}) async {
  return showDialog<DateTime?>(
    context: context,
    builder: (context) {
      return ConventionCalendar(
        firstDay: firstday,
        lastDay: lastDay,
        focusedDay: focusedDay,
        calendarStyle: calendarStyle,
        isRangeEnabled: false,
        headerStyle: headerStyle,
        calendarBuilders: calendarBuilders,
        rangeHighLightColor: rangeHighLightColor,
        holidays: holidays,
      );
    },
  );
}

Future<DateTime?> showConventionCalendarRangePicker({
  required BuildContext context,
  required DateTime firstday,
  required DateTime lastDay,
  required DateTime focusedDay,
  required bool isRangeEnabled,
  Color? rangeHighLightColor,
  CalendarStyle? calendarStyle,
  HeaderStyle? headerStyle,
  CalendarBuilders? calendarBuilders,
  List<DateTime>? holidays,
}) async {
  return showDialog<DateTime?>(
    context: context,
    builder: (context) {
      return ConventionCalendar.rangeSelection(
        firstDay: firstday,
        lastDay: lastDay,
        focusedDay: focusedDay,
        isRangeEnabled: isRangeEnabled,
        calendarStyle: calendarStyle,
        headerStyle: headerStyle,
        calendarBuilders: calendarBuilders,
        rangeHighLightColor: rangeHighLightColor,
        holidays: holidays,
      );
    },
  );
}


}