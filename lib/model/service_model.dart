class ServiceModel {
  final String serviceId;
  final String serviceName;
  final String serviceDescription;
  final double serviceBasePrice;
  final String imagePath; // New property for the image path
  final String colorfulImagePath;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceBasePrice,
    required this.imagePath,
    required this.colorfulImagePath,
  });

  // Convert the object into a map for database storage or transfer
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'serviceBasePrice': serviceBasePrice,
      'imagePath': imagePath,
      'colorfulImagePath': colorfulImagePath,
    };
  }

  // Create an object from a map (useful for fetching data from a database)
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      serviceDescription: map['serviceDescription'] ?? '',
      serviceBasePrice: (map['serviceBasePrice'] ?? 0).toDouble(),
      imagePath: map['imagePath'] ?? '',
      colorfulImagePath: map['colorfulImagePath'] ?? '',
    );
  }
}
