import 'package:convention_calendar/src/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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

  DateTime _focusedDay = DateTime.now();
  String? selectedMonth;
  String? selectedYear;

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
    DateTime now = DateTime.now();
    selectedMonth = DateFormat('MMMM').format(now);
    selectedYear = now.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: TableCalendar(
        firstDay: DateTime(2000),
        lastDay: DateTime(2030),
        focusedDay: _focusedDay,
        onDaySelected: widget.onDaySelected,
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
          todayTextStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          todayDecoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: ColorConstants.blue, width: 2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8)),
          selectedDecoration: BoxDecoration(
            color: ColorConstants.blue,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
        ),
        daysOfWeekHeight: 40,
        headerVisible: true,
        headerStyle: HeaderStyle(
          leftChevronMargin: const EdgeInsets.all(0),
          leftChevronPadding: const EdgeInsets.all(0),
          rightChevronMargin: const EdgeInsets.all(0),
          rightChevronPadding: const EdgeInsets.all(0),
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
          headerMargin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          headerPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          formatButtonVisible: false,
          leftChevronIcon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          rightChevronIcon:
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
        ),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, date) => Row(
            children: [
              Expanded(
                flex: 6,
                child: CustomDropDownWidget(
                  width: 150,
                  items: months,
                  selectedValue: selectedMonth ?? "",
                  onSelected: (value) {
                    setState(() {
                      selectedMonth = value;
                    });
                    _updateFocusedDay();
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: CustomDropDownWidget(
                  items: years,
                  selectedValue: selectedYear ?? "",
                  onSelected: (value) {
                    setState(() {
                      selectedYear = value;
                    });
                    _updateFocusedDay();
                  },
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
                  style:
                      const TextStyle(color: Color(0xFFE60026), fontSize: 18),
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
          _focusedDay = focusedDay;
          selectedMonth = DateFormat('MMMM').format(focusedDay);
          selectedYear = focusedDay.year.toString();
        },
      ),
    );
  }

  void _updateFocusedDay() {
    if (selectedMonth != null && selectedYear != null) {
      int monthIndex = months.indexOf(selectedMonth!) + 1;
      DateTime newFocusedDay = DateTime(int.parse(selectedYear!), monthIndex);
      setState(() {
        _focusedDay = newFocusedDay;
      });
    }
  }
}
