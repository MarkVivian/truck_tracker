enum SearchType {
  driverName,
  truckNumber,
}

enum SortCriteria {
  departure,
  arrival,
  driverName,
}

class TruckData {
  String id;
  String driverName;
  String driverImage;
  String contact;
  String license;
  String truckNumber;
  String vehicleType;
  String departure;
  String arrival;
  String area;
  String tripStatus;
  double? latitude;  // Optional for tracking
  double? longitude; // Optional for tracking
  bool isTracking;  // To indicate if truck is being tracked

  TruckData({
    required this.id,
    required this.driverName,
    required this.driverImage,
    required this.contact,
    required this.license,
    required this.truckNumber,
    required this.vehicleType,
    required this.departure,
    required this.arrival,
    required this.area,
    required this.tripStatus,
    this.latitude,
    this.longitude,
    this.isTracking = false,
  });

  // Add this copyWith method
  TruckData copyWith({
    String? id,
    String? driverName,
    String? driverImage,
    String? contact,
    String? license,
    String? truckNumber,
    String? vehicleType,
    String? departure,
    String? arrival,
    String? area,
    String? tripStatus,
    double? latitude,
    double? longitude,
    bool? isTracking,
  }) {
    return TruckData(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      driverImage: driverImage ?? this.driverImage,
      contact: contact ?? this.contact,
      license: license ?? this.license,
      truckNumber: truckNumber ?? this.truckNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      area: area ?? this.area,
      tripStatus: tripStatus ?? this.tripStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  factory TruckData.fromJson(Map<String, dynamic> json) {
    return TruckData(
      id: json['id'],
      driverName: json['driverName'],
      driverImage: json['driverImage'],
      contact: json['contact'],
      license: json['license'],
      truckNumber: json['truckNumber'],
      vehicleType: json['vehicleType'],
      departure: json['departure'],
      arrival: json['arrival'],
      area: json['area'],
      tripStatus: json['tripStatus'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isTracking: json['isTracking'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverName': driverName,
      'driverImage': driverImage,
      'contact': contact,
      'license': license,
      'truckNumber': truckNumber,
      'vehicleType': vehicleType,
      'departure': departure,
      'arrival': arrival,
      'area': area,
      'tripStatus': tripStatus,
      'latitude': latitude,
      'longitude': longitude,
      'isTracking': isTracking,
    };
  }
}