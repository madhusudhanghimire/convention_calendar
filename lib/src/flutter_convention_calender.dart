import 'package:convention_calendar/src/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/app_colors.dart';

class ConventionCalendar extends StatefulWidget {
  final Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final DateTime? selectedDay;

  final CalendarStyle? calendarStyle;
  final HeaderStyle? headerStyle;
  final CalendarBuilders? calendarBuilders;

  const ConventionCalendar({
    super.key,
    required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.selectedDay,
    this.headerStyle,
    this.calendarStyle,
    this.calendarBuilders,
  });

  @override
  ConventionCalendarState createState() => ConventionCalendarState();
}

class ConventionCalendarState extends State<ConventionCalendar>
    with SingleTickerProviderStateMixin {
  CalendarFormat calendarFormat = CalendarFormat.month;
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
  DateTime? _selectedDay = DateTime.now();
  String? selectedMonth;

  DateTime? rangeStart;
  DateTime? rangeEnd;

  String? selectedYear;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectedMonth = DateFormat('MMMM').format(now);
    selectedYear = now.year.toString();
  }

  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedcircleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white,
      child: TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        pageAnimationEnabled: true,
        firstDay: widget.firstDay,
        lastDay: widget.lastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(widget.selectedDay ?? _selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          widget.onDaySelected!(selectedDay, focusedDay);
          rangeStart = null;
          rangeEnd = null;
          rangeSelectionMode = RangeSelectionMode.toggledOff;
          _updateFocusedDay();
        },
        pageJumpingEnabled: true,
        onDisabledDayTapped: (DateTime datetime) {
          setState(() {
            selectedMonth = DateFormat("MMMM").format(datetime);
            selectedYear = datetime.year.toString();

            _focusedDay = datetime;
            _selectedDay = datetime;

            _updateFocusedDay();
          });
        },
        onFormatChanged: (format) {
          if (calendarFormat != format) {
            setState(() {
              calendarFormat = format;
            });
          }
        },
        rangeSelectionMode: rangeSelectionMode,
        onRangeSelected: (start, end, focusedDay) {
          print('Start: $start, End: $end, Focused: $focusedDay');
          setState(() {
            _selectedDay = null;
            _focusedDay = focusedDay;
            rangeStart = start;
            rangeEnd = end;
            rangeSelectionMode = RangeSelectionMode.toggledOn;
          });
          _updateFocusedDay();
        },
        rangeEndDay: rangeEnd,
        rangeStartDay: rangeStart,
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(
            fontSize: 16,
          ),
          weekendTextStyle: TextStyle(
            color: ColorConstants.error,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          outsideDaysVisible: false,
          rangeStartDecoration: BoxDecoration(
            color: ColorConstants.blue,
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(8),
          ),
          rangeEndDecoration: BoxDecoration(
            color: ColorConstants.blue,
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(8),
          ),
          defaultDecoration: BoxDecoration(
            // color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.circle,
          ),
          weekendDecoration: BoxDecoration(
            // color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: BoxDecoration(
            color: ColorConstants.blue,
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(8),
          ),
          rangeHighlightColor: ColorConstants.blue,
          outsideDecoration: BoxDecoration(
            shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(8),
          ),
          withinRangeTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          todayTextStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          todayDecoration: BoxDecoration(
              color: Colors.grey.shade200,
              // border: Border.all(color: ColorConstants.blue, width: 2),
              shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(8)),
          selectedDecoration: BoxDecoration(
            color: (widget.selectedDay)?.weekday == DateTime.saturday ||
                    (widget.selectedDay)?.weekday == DateTime.sunday
                ? ColorConstants.error
                : ColorConstants.blue,
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Colors.white),
        ),
        daysOfWeekHeight: 40,
        headerVisible: true,
        headerStyle: const HeaderStyle(
          leftChevronMargin: EdgeInsets.all(0),
          leftChevronPadding: EdgeInsets.all(0),
          rightChevronMargin: EdgeInsets.all(0),
          rightChevronPadding: EdgeInsets.all(0),
          titleCentered: true,
          headerMargin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          headerPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          formatButtonVisible: false,
          leftChevronIcon:
              Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          rightChevronIcon:
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
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
                  style: const TextStyle(
                      color: Color(0xFFE60026),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              );
            }
            return Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
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
