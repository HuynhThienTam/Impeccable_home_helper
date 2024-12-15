class BookingModel {
  String bookingNumber;
  String serviceType;
  String customerUid;
  String customerName;
  String helperUid;
  String helperName;
  DateTime workingDay;
  DateTime startTime;
  DateTime finishedTime;
  String location;
  String note;
  String paymentMethod;
  String cardName;
  String cardNumber;
  String cvv;
  String status;//3 là hoàn thành, 4 là cancel

  BookingModel({
    required this.bookingNumber,
    required this.serviceType,
    required this.customerUid,
    required this.customerName,
    required this.helperUid,
    required this.helperName,
    required this.workingDay,
    required this.startTime,
    required this.finishedTime,
    required this.location,
    required this.note,
    required this.paymentMethod,
    required this.cardName,
    required this.cardNumber,
    required this.cvv,
    required this.status,
  });

  // Convert BookingModel to Map
  Map<String, dynamic> toMap() {
    return {
      'bookingNumber': bookingNumber,
      'serviceType': serviceType,
      'customerUid': customerUid,
      'customerName': customerName,
      'helperUid': helperUid,
      'helperName': helperName,
      'workingDay': workingDay.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'finishedTime': finishedTime.toIso8601String(),
      'location': location,
      'note': note,
      'paymentMethod': paymentMethod,
      'cardName': cardName,
      'cardNumber': cardNumber,
      'cvv': cvv,
      'status': status,
    };
  }

  // Create BookingModel from Map
  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingNumber: map['bookingNumber'] ?? '',
      serviceType: map['serviceType'] ?? '',
      customerUid: map['customerUid'] ?? '',
      customerName: map['customerName'] ?? '',
      helperUid: map['helperUid'] ?? '',
      helperName: map['helperName'] ?? '',
      workingDay: DateTime.parse(map['workingDay']),
      startTime: DateTime.parse(map['startTime']),
      finishedTime: DateTime.parse(map['finishedTime']),
      location: map['location'] ?? '',
      note: map['note'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      cardName: map['cardName'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cvv: map['cvv'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
