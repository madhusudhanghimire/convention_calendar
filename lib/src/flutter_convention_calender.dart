import 'package:convention_calendar/src/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/app_colors.dart';

class ConventionCalendar extends StatefulWidget {
  final Function(DateTime? rangeStart, DateTime? rangeEnd)? onRangeSelected;
  final Function(DateTime? date)? onDateSelected;

  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;

  final bool isRangeEnabled;
  final Color? rangeHighLightColor;
  final CalendarStyle? calendarStyle;
  final HeaderStyle? headerStyle;
  final CalendarBuilders? calendarBuilders;
  final List<DateTime>? holidays;

  const ConventionCalendar({
    super.key,
    // required this.onDaySelected,
    this.onRangeSelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.onDateSelected,
    this.headerStyle,
    this.calendarStyle,
    this.calendarBuilders,
    this.isRangeEnabled = false,
    this.rangeHighLightColor,
    this.holidays,
  });

  const ConventionCalendar.rangeSelection({
    super.key,
    // required this.onDaySelected,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.onRangeSelected,
    this.headerStyle,
    this.onDateSelected,
    this.calendarStyle,
    this.calendarBuilders,
    this.isRangeEnabled = false,
    this.rangeHighLightColor,
    this.holidays,
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

  List<String> years = [];

  List<String> _generateYears(DateTime firstDate, DateTime lastDate) {
    List<String> yearRange = [];
    for (int year = firstDate.year; year <= lastDate.year; year++) {
      yearRange.add(year.toString());
    }
    return yearRange;
  }

  getRangedDate({required DateTime rangeStart, required DateTime rangeEnd}) {}

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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
    years = _generateYears(widget.firstDay, widget.lastDay);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationCurve: Curves.bounceIn,
      insetAnimationDuration: const Duration(milliseconds: 300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                pageAnimationEnabled: true,
                firstDay: widget.firstDay,
                lastDay: widget.lastDay,
                focusedDay: _focusedDay,
                holidayPredicate: (day) {
                  for (DateTime i in widget.holidays ?? []) {
                    if (i.year == day.year &&
                        i.month == day.month &&
                        i.day == day.day) {
                      return true;
                    }
                  }
                  return false;
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
              
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    // widget.onDaySelected!(selectedDay, focusedDay);
                    rangeStart = null;
                    rangeEnd = null;
                  });
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
                rangeSelectionMode: widget.isRangeEnabled
                    ? RangeSelectionMode.enforced
                    : RangeSelectionMode.disabled,
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _selectedDay = null;
                    _focusedDay = focusedDay;
                    rangeStart = start;
                    rangeEnd = end;
                    widget.isRangeEnabled
                        ? RangeSelectionMode.enforced
                        : RangeSelectionMode.disabled;
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
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: ColorConstants.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  defaultDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  isTodayHighlighted: true,
                  weekendDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  withinRangeDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  rangeHighlightColor:
                      widget.rangeHighLightColor ?? Colors.white,
                  outsideDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  withinRangeTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  todayTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
      
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
                  headerMargin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  headerPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black),
                  rightChevronIcon: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black),
                ),
                calendarBuilders: CalendarBuilders(
                  holidayBuilder: (context, day, focusedDay) {
                    return Tooltip(
                      message: "Some Holidays Message",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.error,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: ColorConstants.error,
                              radius: 2,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: (rangeStart == null || rangeEnd == null)
                            ?  Colors.grey.shade200
                            : null,
                          
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child :   Text(
                        day.day.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    );
                  },
                  rangeStartBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _selectedDay?.weekday == DateTime.saturday ||
                            _selectedDay?.weekday == DateTime.sunday
                        ? ColorConstants.error
                        : ColorConstants.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                  rangeEndBuilder: (context, day, focusedDay) {
                    return Container(
                      decoration: BoxDecoration(
                        color: ColorConstants.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
                  rangeHighlightBuilder: (context, day, isWithinRange) {
                    return isWithinRange &&
                            !(day == rangeStart || day == rangeEnd)
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          )
                        : const SizedBox();
                  },
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: ColorConstants.error,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                const SizedBox(
                  width: 12,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: ColorConstants.blue,
                  ),
                  onPressed: () {
                    if (widget.isRangeEnabled == true) {
                      widget.onRangeSelected!(rangeStart, rangeEnd);
                      Navigator.of(context).pop();
                    } else {
                      widget.onDateSelected!(_selectedDay);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Select'),
                ),
                const SizedBox(
                  width: 24,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
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
