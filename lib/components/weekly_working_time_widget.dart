import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:impeccablehome_helper/components/small_button.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart'; // For CupertinoDatePicker

class WeeklyWorkingTimeWidget extends StatefulWidget {
  final List<Map<String, String>> workingTime;

  const WeeklyWorkingTimeWidget({
    Key? key,
    required this.workingTime,
  }) : super(key: key);

  @override
  State<WeeklyWorkingTimeWidget> createState() => _WeeklyWorkingTimeWidgetState();
}

class _WeeklyWorkingTimeWidgetState extends State<WeeklyWorkingTimeWidget> {
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  void _showTimePicker(BuildContext context, bool isStartTime, Function(TimeOfDay) onTimePicked) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay tempSelectedTime = isStartTime
            ? (_selectedStartTime ?? TimeOfDay(hour: 9, minute: 0))
            : (_selectedEndTime ?? TimeOfDay(hour: 17, minute: 0));

        return Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  minuteInterval: 10,
                  use24hFormat: true,
                  initialDateTime: DateTime(0, 0, 0, tempSelectedTime.hour, tempSelectedTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    tempSelectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      onTimePicked(tempSelectedTime);
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showDialog(String day, {Map<String, String>? existingData}) {
    // Initialize start and end time for editing or default
    _selectedStartTime = existingData != null
        ? TimeOfDay(
            hour: int.parse(existingData['startTime']!.split(':')[0]),
            minute: int.parse(existingData['startTime']!.split(':')[1]),
          )
        : null;
    _selectedEndTime = existingData != null
        ? TimeOfDay(
            hour: int.parse(existingData['finishedTime']!.split(':')[0]),
            minute: int.parse(existingData['finishedTime']!.split(':')[1]),
          )
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingData == null ? 'Add Working Time' : 'Edit Working Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(_selectedStartTime != null
                    ? "Start Time: ${_formatTimeOfDay(_selectedStartTime!)}"
                    : "Select Start Time"),
                trailing: Icon(Icons.access_time),
                onTap: () => _showTimePicker(context, true, (time) {
                  setState(() {
                    _selectedStartTime = time;
                  });
                }),
              ),
              ListTile(
                title: Text(_selectedEndTime != null
                    ? "End Time: ${_formatTimeOfDay(_selectedEndTime!)}"
                    : "Select End Time"),
                trailing: Icon(Icons.access_time),
                onTap: () => _showTimePicker(context, false, (time) {
                  setState(() {
                    _selectedEndTime = time;
                  });
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedStartTime != null && _selectedEndTime != null) {
                  setState(() {
                    // Update the working time for the day
                    final existingEntry = widget.workingTime.firstWhere(
                      (entry) => entry['day'] == day,
                      orElse: () => {},
                    );

                    if (existingEntry.isEmpty) {
                      widget.workingTime.add({
                        'day': day,
                        'startTime': _formatTimeOfDay(_selectedStartTime!),
                        'finishedTime': _formatTimeOfDay(_selectedEndTime!),
                      });
                    } else {
                      existingEntry['startTime'] = _formatTimeOfDay(_selectedStartTime!);
                      existingEntry['finishedTime'] = _formatTimeOfDay(_selectedEndTime!);
                    }
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final String formattedHour = time.hour.toString().padLeft(2, '0');
    final String formattedMinute = time.minute.toString().padLeft(2, '0');
    return "$formattedHour:$formattedMinute";
  }

  void _deleteData(String day) {
    setState(() {
      widget.workingTime.removeWhere((entry) => entry['day'] == day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final screenWidth = MediaQuery.of(context).size.width;
    final dayAbbreviations = {
    'Monday': 'Mon',
    'Tuesday': 'Tue',
    'Wednesday': 'Wed',
    'Thursday': 'Thu',
    'Friday': 'Fri',
    'Saturday': 'Sat',
    'Sunday': 'Sun',
  };
    return Column(
      children: daysOfWeek.map((day) {
        // Find matching data for the day
        final dataForDay = widget.workingTime.firstWhere(
          (entry) => entry['day'] == day,
          orElse: () => {},
        );

        final hasData = dataForDay.isNotEmpty;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.symmetric(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: screenWidth * (4 / 25),
                alignment: Alignment.centerLeft,
                child: Text(
                  dayAbbreviations[day]!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: hasData ? const Color(0xFFFFA500) : const Color(0xFFC0C0C0),
                  ),
                ),
              ),
              Container(
                width: screenWidth * (1 / 4),
                child: Text(
                  hasData
                      ? "${dataForDay['startTime']} to ${dataForDay['finishedTime']}"
                      : "Not working",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  // Add/Edit Button
                  SmallButton(
                    title: hasData ? "Edit" : "Add",
                    textColor: Colors.white,
                    backgroundColor: crimsonRedColor,
                    onTap: () => _showDialog(day, existingData: hasData ? dataForDay : null),
                  ),
                  const SizedBox(width: 8),
                  // Delete Button (only if data exists)
                  if (hasData)
                    SmallButton(
                      title: "Delete",
                      textColor: Colors.white,
                      backgroundColor: crimsonRedColor,
                      onTap: () => _deleteData(day),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}