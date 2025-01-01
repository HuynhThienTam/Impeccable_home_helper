import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impeccablehome_helper/components/booking_widget.dart';
import 'package:impeccablehome_helper/components/completed_booking_widget.dart';
import 'package:impeccablehome_helper/utils/color_themes.dart';
import 'package:impeccablehome_helper/utils/mock.dart';
import 'package:provider/provider.dart';

import '../model/booking_model.dart';
import '../resources/booking_method.dart';

class BookingsScreen extends StatefulWidget {
  
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final currentuser = FirebaseAuth.instance.currentUser;
  

  @override
  Widget build(BuildContext context) {
    final bookingMethods = Provider.of<BookingMethods>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:  StreamBuilder<List<BookingModel>>(
        stream: bookingMethods.getBookingsStream(currentuser!.uid),
        builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Divide bookings into three lists based on their status
        final cancelBookings = snapshot.data!
            .where((booking) =>
                booking.status == "-1" || booking.status == "-2")
            .toList();
        final ongoingBookings = snapshot.data!
            .where((booking) =>
                booking.status == "0" ||
                booking.status == "1" ||
                booking.status == "2")
            .toList();
        final completedBookings = snapshot.data!
            .where((booking) => booking.status == "3")
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenWidth * (1 / 6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text(
                      "Bookings",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * (1 / 13),
                ),
                child: Text(
                  "Processing",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              SingleChildScrollView(
                child: Column(
                  children: List.generate(ongoingBookings.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: BookingWidget(booking: ongoingBookings[index]),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              // TabBar Section
              DefaultTabController(
                length: 2, // Number of tabs
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: silverGrayColor,
                      indicatorColor: skyBlueColor,
                      tabs: [
                        Tab(
                          child: Text(
                            "Completed",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ), // First tab
                        Tab(
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ), // Second tab
                      ],
                    ),
                    // TabBarView to show different screens
                    SizedBox(
                      height: screenHeight -
                          screenWidth *
                              (2 /
                                  5), // Limit the height of TabBarView (adjust as needed)
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                children: List.generate(
                                  completedBookings.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: CompletedBookingWidget(
                                        booking: completedBookings[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                          ),
                          // Screen 1
                          SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                children: List.generate(
                                  cancelBookings.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: CompletedBookingWidget(
                                        booking: cancelBookings[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                          ), // Screen 2
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );},),
      ),
    );
  }
}
