import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  String id;
  String name;
  String adminId;
  String address;
  String city;
  double latitude;
  double longitude;
  // List<Sport> sports = [];

  Company({
    required this.id,
    required this.name,
    required this.adminId,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    // this.sports = [],
  });

  factory Company.fromFirestore(Map<String, dynamic> data, String id) {
    return Company(
      id: id,
      name: data['name'],
      adminId: data['adminId'],
      address: data['address'],
      city: data['city'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }
}

class Sport {
  String id;
  String name;
  String description;
  double pricePerHour;
  String companyId;

  Sport({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    required this.companyId,
  });

  factory Sport.fromFirestore(Map<String, dynamic> data, String id) {
    return Sport(
      id: id,
      name: data['name'],
      companyId: data['companyId'],
      description: data['description'],
      pricePerHour: data['pricePerHour'].toDouble(),
    );
  }
}

class Court {
  String id;
  String name;
  String sportId;
  String companyId;
  bool isIndoor;

  Court({
    required this.id,
    required this.name,
    required this.sportId,
    required this.companyId,
    required this.isIndoor,
  });

  factory Court.fromFirestore(Map<String, dynamic> data, String id) {
    return Court(
      id: id,
      name: data['name'],
      companyId: data['companyId'],
      sportId: data['sportId'],
      isIndoor: data['isIndoor'] ?? false,
    );
  }
}

class Customer {
  String id;
  String firstName;
  String lastName;
  String displayName;
  String email;
  String phoneNumber;
  String country;
  String city;
  DateTime dateOfBirth;
  String gender;
  String postalCode;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.city,
    required this.dateOfBirth,
    required this.gender,
    required this.postalCode,
  });

  factory Customer.fromFirestore(Map<String, dynamic> data, String id) {
    return Customer(
      id: id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      displayName: data['displayName'] ?? '',
      gender: data['gender'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      country: data['country'] ?? '',
      city: data['city'] ?? '',
      dateOfBirth:
          (data['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime(2000),
      postalCode: data['postalCode'] ?? '',
    );
  }
}

class Booking {
  String id;
  String customerId;
  String sportId;
  String courtId;
  DateTime startTime;
  int duration;
  DateTime createdAt;

  Booking({
    required this.id,
    required this.customerId,
    required this.sportId,
    required this.courtId,
    required this.startTime,
    required this.duration,
    required this.createdAt,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data) {
    return Booking(
      id: data['id'],
      customerId: data['customerId'],
      sportId: data['sportId'],
      courtId: data['courtId'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      duration: data['duration'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}

class Notification {
  String id;
  String customerId;
  String message;
  DateTime createdAt;

  Notification({
    required this.id,
    required this.customerId,
    required this.message,
    required this.createdAt,
  });
}
