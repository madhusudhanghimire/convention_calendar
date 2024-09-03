import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ConventionCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final CalendarStyle? calendarStyle;
  final HeaderStyle? headerStyle;

  const ConventionCalendar({
    super.key,
    required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.headerStyle,
    this.calendarStyle,
  });

  @override
  ConventionCalendarState createState() => ConventionCalendarState();
}

class ConventionCalendarState extends State<ConventionCalendar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return TableCalendar(
                firstDay: widget.firstDay,
                lastDay: widget.lastDay,
                focusedDay: widget.focusedDay,
                onDaySelected: (selectedDay, focusedDay) {},
                calendarStyle: widget.calendarStyle ??
                    CalendarStyle(
                      defaultTextStyle: const TextStyle(
                        fontSize: 18,
                      ),
                      weekendTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      defaultDecoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      weekendDecoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      todayDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                    ),
                daysOfWeekHeight: 40,
                headerStyle: widget.headerStyle ??
                    HeaderStyle(
                      titleCentered: true,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              spreadRadius: 2.0,
                              color: Colors.grey.shade200,
                            )
                          ]),
                      headerMargin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      formatButtonVisible: false,
                      titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      leftChevronIcon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      rightChevronIcon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black),
                    ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    final text = DateFormat.E().format(day);
                    if (day.weekday == DateTime.saturday ||
                        day.weekday == DateTime.sunday) {
                      return Center(
                        child: Text(
                          text,
                          style: const TextStyle(
                              color: Color(0xFFE60026), fontSize: 18),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
                onPageChanged: (focusedDay) {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                },
              );
            }),
      ),
    );
  }
}
