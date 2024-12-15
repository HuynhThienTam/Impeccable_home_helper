import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/components/process_widget.dart';
import 'package:impeccablehome_helper/model/booking_model.dart';
import 'package:impeccablehome_helper/screens/booking_details_screen.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class BookingWidget extends StatefulWidget {
  final BookingModel booking;

  const BookingWidget({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(
        left: screenWidth / 12,
        right: screenWidth / 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: silverGrayColor, // Grey border
          width: 1, // Border width
        ),
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text(
              "Booking no #${widget.booking.bookingNumber}",
              style: TextStyle(
                color: oceanBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Working time",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              "${widget.booking.workingDay.toLocal().toString().split(' ')[0]}",
              style: TextStyle(
                color: oceanBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${widget.booking.startTime.toLocal().hour}:${widget.booking.startTime.toLocal().minute.toString().padLeft(2, '0')} - ${widget.booking.finishedTime.toLocal().hour}:${widget.booking.finishedTime.toLocal().minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: oceanBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Location",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              widget.booking.location,
              style: TextStyle(
                color: oceanBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            ProcessWidget(
              processes: processesList,
              doneProcesses: doneProcessesList,
              currentProcesses: currentProcessesList,
              currentProcess:
                  int.parse(widget.booking.status), // Dynamically set
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 48,
                width: 160,
                child: CustomButton(
                  title: "View",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsScreen(booking: widget.booking,),
                        ),
                      );
                  },
                  backgroundColor: orangeColor,
                  textColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

final List<String> processesList = [
  'Confirm',
  'Arrive',
  'Finish',
];
final List<String> doneProcessesList = [
  'Confirmed',
  'Arrived',
  'Finished',
];
final List<String> currentProcessesList = [
  'Wait for confirm',
  'Arriving',
  'Doing job',
];
