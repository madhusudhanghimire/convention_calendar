import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ConventionCalendar extends StatelessWidget {
  final Function(DateTime) onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;

  const ConventionCalendar({
    super.key,
    required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TableCalendar(
        locale: "en_US",
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay);
        },
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
        calendarBuilders: const CalendarBuilders(),
      ),
    );
  }
}
