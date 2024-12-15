import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/components/custom_button.dart';
import 'package:impeccablehome_helper/model/booking_model.dart';
import 'package:impeccablehome_helper/screens/booking_details_screen.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';

class CompletedBookingWidget extends StatefulWidget {
  final BookingModel booking;
  const CompletedBookingWidget({super.key, required this.booking});

  @override
  State<CompletedBookingWidget> createState() => _CompletedBookingWidgetState();
}

class _CompletedBookingWidgetState extends State<CompletedBookingWidget> {
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
            Text(
              widget.booking.location,
              style: TextStyle(
                color: oceanBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 48,
                  width: 130,
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
                    textColor: Colors.black,
                    backgroundColor: orangeColor,
                  ),
                ),
               
              ],
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
