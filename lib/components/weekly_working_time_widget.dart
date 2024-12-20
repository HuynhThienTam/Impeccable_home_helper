import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:impeccablehome_helper/components/small_button.dart';
import 'package:impeccablehome_helper/model/helper_model.dart';
import 'package:impeccablehome_helper/resources/cloud_firestore_methods.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart'; // For CupertinoDatePicker

class WeeklyWorkingTimeWidget extends StatefulWidget {
  final HelperModel helperModel;

  const WeeklyWorkingTimeWidget({
    Key? key,
    required this.helperModel,
  }) : super(key: key);

  @override
  State<WeeklyWorkingTimeWidget> createState() =>
      _WeeklyWorkingTimeWidgetState();
}

class _WeeklyWorkingTimeWidgetState extends State<WeeklyWorkingTimeWidget> {
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  List<Map<String, String>> workingTime = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkingTime();
  }

  Future<void> _fetchWorkingTime() async {
    final fetchedWorkingTime = await widget.helperModel.getWorkingTime();
    setState(() {
      workingTime = fetchedWorkingTime;
    });
  }

  void _showTimePicker(BuildContext context, bool isStartTime,
      Function(TimeOfDay) onTimePicked) {
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
                  initialDateTime: DateTime(
                      0, 0, 0, tempSelectedTime.hour, tempSelectedTime.minute),
                  onDateTimeChanged: (DateTime newDateTime) {
                    tempSelectedTime = TimeOfDay(
                        hour: newDateTime.hour, minute: newDateTime.minute);
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
          title: Text(
              existingData == null ? 'Add Working Time' : 'Edit Working Time'),
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
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_selectedStartTime != null && _selectedEndTime != null) {
                  setState(() {
                    final existingEntry = workingTime.firstWhere(
                      (entry) => entry['day'] == day,
                      orElse: () => {},
                    );

                    if (existingEntry.isEmpty) {
                      workingTime.add({
                        'day': day,
                        'startTime': _formatTimeOfDay(_selectedStartTime!),
                        'finishedTime': _formatTimeOfDay(_selectedEndTime!),
                      });
                    } else {
                      existingEntry['startTime'] =
                          _formatTimeOfDay(_selectedStartTime!);
                      existingEntry['finishedTime'] =
                          _formatTimeOfDay(_selectedEndTime!);
                    }
                  });

                  await widget.helperModel.setWorkingTime(workingTime);
                  Navigator.pop(context);
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

  // void _deleteData(String day) async {
  //   setState(() {
  //     workingTime.removeWhere((entry) => entry['day'] == day);
  //   });
  //   await widget.helperModel.setWorkingTime(workingTime);
  // }
  void _deleteData(String day) async {
  setState(() {
    workingTime.removeWhere((entry) => entry['day'] == day);
  });

  try {
    final workingTimeCollection = CloudFirestoreClass()
        .firebaseFirestore
        .collection('helpers')
        .doc(widget.helperModel.helperUid)
        .collection('workingTime');

    // Delete the document for the specific day
    await workingTimeCollection.doc(day).delete();
    debugPrint('Deleted day "$day" from Firestore successfully.');
  } catch (e) {
    debugPrint('Error deleting day "$day" from Firestore: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
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
        final dataForDay = workingTime.firstWhere(
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
                    color: hasData
                        ? const Color(0xFFFFA500)
                        : const Color(0xFFC0C0C0),
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
                  SmallButton(
                    title: hasData ? "Edit" : "Add",
                    textColor: Colors.white,
                    backgroundColor: crimsonRedColor,
                    onTap: () => _showDialog(day,
                        existingData: hasData ? dataForDay : null),
                  ),
                  const SizedBox(width: 8),
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
           


// class WeeklyWorkingTimeWidget extends StatefulWidget {
//   final String helperUid;
//   final List<Map<String, String>> workingTime;

//   const WeeklyWorkingTimeWidget({
//     Key? key,
//     required this.helperUid,
//     required this.workingTime,
//   }) : super(key: key);

//   @override
//   State<WeeklyWorkingTimeWidget> createState() => _WeeklyWorkingTimeWidgetState();
// }

// class _WeeklyWorkingTimeWidgetState extends State<WeeklyWorkingTimeWidget> {
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;

//   // Firestore reference
//   final _firestore = FirebaseFirestore.instance;

//   // Save updated working time to Firestore
//   Future<void> _updateWorkingTimeInFirestore(List<Map<String, String>> updatedWorkingTime) async {
//     try {
//       await _firestore.collection('helpers').doc(widget.helperUid).update({
//         'workingTime': updatedWorkingTime,
//       });
//       debugPrint('Working time updated in Firestore successfully.');
//     } catch (e) {
//       debugPrint('Error updating working time: $e');
//     }
//   }

//   void _showTimePicker(BuildContext context, bool isStartTime, Function(TimeOfDay) onTimePicked) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         TimeOfDay tempSelectedTime = isStartTime
//             ? (_selectedStartTime ?? TimeOfDay(hour: 9, minute: 0))
//             : (_selectedEndTime ?? TimeOfDay(hour: 17, minute: 0));

//         return Container(
//           height: 300,
//           child: Column(
//             children: [
//               Expanded(
//                 child: CupertinoDatePicker(
//                   mode: CupertinoDatePickerMode.time,
//                   minuteInterval: 10,
//                   use24hFormat: true,
//                   initialDateTime: DateTime(0, 0, 0, tempSelectedTime.hour, tempSelectedTime.minute),
//                   onDateTimeChanged: (DateTime newDateTime) {
//                     tempSelectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
//                   },
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       onTimePicked(tempSelectedTime);
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Confirm'),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showDialog(String day, {Map<String, String>? existingData}) {
//     _selectedStartTime = existingData != null
//         ? TimeOfDay(
//             hour: int.parse(existingData['startTime']!.split(':')[0]),
//             minute: int.parse(existingData['startTime']!.split(':')[1]),
//           )
//         : null;
//     _selectedEndTime = existingData != null
//         ? TimeOfDay(
//             hour: int.parse(existingData['finishedTime']!.split(':')[0]),
//             minute: int.parse(existingData['finishedTime']!.split(':')[1]),
//           )
//         : null;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(existingData == null ? 'Add Working Time' : 'Edit Working Time'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text(_selectedStartTime != null
//                     ? "Start Time: ${_formatTimeOfDay(_selectedStartTime!)}"
//                     : "Select Start Time"),
//                 trailing: Icon(Icons.access_time),
//                 onTap: () => _showTimePicker(context, true, (time) {
//                   setState(() {
//                     _selectedStartTime = time;
//                   });
//                 }),
//               ),
//               ListTile(
//                 title: Text(_selectedEndTime != null
//                     ? "End Time: ${_formatTimeOfDay(_selectedEndTime!)}"
//                     : "Select End Time"),
//                 trailing: Icon(Icons.access_time),
//                 onTap: () => _showTimePicker(context, false, (time) {
//                   setState(() {
//                     _selectedEndTime = time;
//                   });
//                 }),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (_selectedStartTime != null && _selectedEndTime != null) {
//                   setState(() {
//                     final existingEntry = widget.workingTime.firstWhere(
//                       (entry) => entry['day'] == day,
//                       orElse: () => {},
//                     );

//                     if (existingEntry.isEmpty) {
//                       widget.workingTime.add({
//                         'day': day,
//                         'startTime': _formatTimeOfDay(_selectedStartTime!),
//                         'finishedTime': _formatTimeOfDay(_selectedEndTime!),
//                       });
//                     } else {
//                       existingEntry['startTime'] = _formatTimeOfDay(_selectedStartTime!);
//                       existingEntry['finishedTime'] = _formatTimeOfDay(_selectedEndTime!);
//                     }
//                   });
//                   _updateWorkingTimeInFirestore(widget.workingTime); // Update Firestore
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatTimeOfDay(TimeOfDay time) {
//     final String formattedHour = time.hour.toString().padLeft(2, '0');
//     final String formattedMinute = time.minute.toString().padLeft(2, '0');
//     return "$formattedHour:$formattedMinute";
//   }

//   void _deleteData(String day) {
//     setState(() {
//       widget.workingTime.removeWhere((entry) => entry['day'] == day);
//     });
//     _updateWorkingTimeInFirestore(widget.workingTime); // Update Firestore
//   }

//   @override
//   Widget build(BuildContext context) {
//     final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
//     final screenWidth = MediaQuery.of(context).size.width;
//     final dayAbbreviations = {
//       'Monday': 'Mon',
//       'Tuesday': 'Tue',
//       'Wednesday': 'Wed',
//       'Thursday': 'Thu',
//       'Friday': 'Fri',
//       'Saturday': 'Sat',
//       'Sunday': 'Sun',
//     };

//     return Column(
//       children: daysOfWeek.map((day) {
//         final dataForDay = widget.workingTime.firstWhere(
//           (entry) => entry['day'] == day,
//           orElse: () => {},
//         );

//         final hasData = dataForDay.isNotEmpty;

//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           margin: const EdgeInsets.symmetric(),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 width: screenWidth * (4 / 25),
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   dayAbbreviations[day]!,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: hasData ? const Color(0xFFFFA500) : const Color(0xFFC0C0C0),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenWidth * (1 / 4),
//                 child: Text(
//                   hasData
//                       ? "${dataForDay['startTime']} to ${dataForDay['finishedTime']}"
//                       : "Not working",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   SmallButton(
//                     title: hasData ? "Edit" : "Add",
//                     textColor: Colors.white,
//                     backgroundColor: crimsonRedColor,
//                     onTap: () => _showDialog(day, existingData: hasData ? dataForDay : null),
//                   ),
//                   const SizedBox(width: 8),
//                   if (hasData)
//                     SmallButton(
//                       title: "Delete",
//                       textColor: Colors.white,
//                       backgroundColor: crimsonRedColor,
//                       onTap: () => _deleteData(day),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

