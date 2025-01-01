import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impeccablehome_helper/model/booking_model.dart';

class BookingMethods extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream bookings divided into three lists based on status
  // Stream<Map<String, List<BookingModel>>> getBookingsStream(String helperId) {
  //   return _firestore
  //       .collection('bookings')
  //       .where('helperUid', isEqualTo: helperId) // Fetch bookings for this helper
  //       .snapshots()
  //       .map((querySnapshot) {
  //     // Initialize empty lists
  //     List<BookingModel> list1 = []; // status = "-1" || "-2"
  //     List<BookingModel> list2 = []; // status = "0" || "1" || "2"
  //     List<BookingModel> list3 = []; // status = "3"

  //     for (var doc in querySnapshot.docs) {
  //       // Parse each document into a BookingModel
  //       BookingModel booking = BookingModel.fromMap(doc.data() as Map<String, dynamic>);

  //       // Categorize based on the booking's status
  //       if (booking.status == "-1" || booking.status == "-2") {
  //         list1.add(booking);
  //       } else if (booking.status == "0" || booking.status == "1" || booking.status == "2") {
  //         list2.add(booking);
  //       } else if (booking.status == "3") {
  //         list3.add(booking);
  //       }
  //     }

  //     return {
  //       'list1': list1,
  //       'list2': list2,
  //       'list3': list3,
  //     };
  //   });
  // }

// Stream<List<BookingModel>> getBookingsStream(String helperId) async* {
//   // Listen to booking snapshots
//   await for (var snapshot in FirebaseFirestore.instance
//       .collection('bookings')
//       .where('helperUid', isEqualTo: helperId)
//       .snapshots()) {
//     // Fetch all bookings with additional details from users and helpers collections
//     var bookings = await Future.wait(snapshot.docs.map((doc) async {
//       final data = doc.data() as Map<String, dynamic>;

//       // Fetch customer details based on customerUid
//       String customerName = 'Unknown';
//       if (data['customerUid'] != null) {
//         final customerSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(data['customerUid'])
//             .get();
//         customerName = customerSnapshot.data()?['name'] ?? 'Unknown';
//       }

//       // Map to BookingModel
//       return BookingModel(
//         bookingNumber: data['bookingNumber'],
//         serviceType: data['serviceType'],
//         customerUid: data['customerUid'],
//         customerName: customerName,
//         helperUid: data['helperUid'],
//         helperName: "",
//         workingDay: (data['workingDay'] as Timestamp).toDate(),
//         startTime: (data['startTime'] as Timestamp).toDate(),
//         finishedTime: (data['finishedTime'] as Timestamp).toDate(),
//         location: data['location'],
//         province: data['province'],
//         note: data['note'],
//         paymentMethod: data['paymentMethod'],
//         cardName: data['cardName'],
//         cardNumber: data['cardNumber'],
//         cvv: data['cvv'],
//         status: data['status'],
//       );
//     }).toList());

//     // Emit the updated list of bookings
//     yield bookings;
//   }
// }


  Stream<List<BookingModel>> getBookingsStream(String helperId) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('helperUid', isEqualTo: helperId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return BookingModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList());
}
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      // Update the status field in the booking document
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': newStatus,
      });

      debugPrint('Booking status updated to $newStatus for booking ID: $bookingId');
    } catch (e) {
      debugPrint('Error updating booking status: $e');
    }
  }
}
