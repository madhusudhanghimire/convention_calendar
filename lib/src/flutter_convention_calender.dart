import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

import '../utils/app_colors.dart';

class ConventionCalendar extends StatefulWidget {
  final Function(DateTime, DateTime) onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final CalendarStyle? calendarStyle;
  final HeaderStyle? headerStyle;
  final CalendarBuilders? calendarBuilders;
  final Function(DateTime)? onPageChanged;
  const ConventionCalendar({
    super.key,
    required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.headerStyle,
    this.calendarStyle,
    this.calendarBuilders,
    this.onPageChanged,
  });

  @override
  ConventionCalendarState createState() => ConventionCalendarState();
}

class ConventionCalendarState extends State<ConventionCalendar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  List<String> years = [
    "2014",
    "2015",
    "2016",
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030"
  ];
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  String? selectedMonthsValue;
  String? selectedYearValue;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2025),
                focusedDay: DateTime.now(),
                onDaySelected: (selectedDay, focusedDay) {},
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  weekendTextStyle: TextStyle(
                    color: ColorConstants.error,
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
                  todayDecoration: BoxDecoration(
                      color: ColorConstants.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8)),
                  selectedDecoration: BoxDecoration(
                    color: ColorConstants.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                ),
                daysOfWeekHeight: 40,
                headerVisible: true,
                headerStyle: HeaderStyle(
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
                  headerMargin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: ColorConstants.black800,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  leftChevronIcon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black),
                  rightChevronIcon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black),
                ),
                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, date) => Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: CustomDropdown(
                          initialItem:
                              DateFormat('MMMM').format(DateTime.now()),
                          items: months.map((item) => item).toList(),
                          onChanged: (value) {},
                          hideSelectedFieldWhenExpanded: false,
                          overlayHeight: MediaQuery.sizeOf(context).height / 3,
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: CustomDropdown(
                          initialItem: DateTime.now().year.toString(),
                          items: years.map((item) => item).toList(),
                          onChanged: (value) {},
                          hideSelectedFieldWhenExpanded: false,
                          overlayHeight: MediaQuery.sizeOf(context).height / 3,
                        ),
                      ),
                    ],
                  ),
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
