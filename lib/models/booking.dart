class Admin {
  int id;
  String name;
  String email;
  String password;
  String roleType;
  int companyId;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.roleType,
    required this.companyId,
  });
}

class Company {
  String id;
  String name;
  String adminId;
  String address;
  String city;
  double latitude;
  double longitude;

  Company({
    required this.id,
    required this.name,
    required this.adminId,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
  });
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
}

class Court {
  String id;
  String name;
  String sportId;
  String companyId;

  Court({
    required this.id,
    required this.name,
    required this.sportId,
    required this.companyId,
  });
}

class Customer {
  String id;
  String firstName;
  String lastName;
  String displayName;
  String email;
  String password;
  String phoneNumber;
  String country;
  String city;
  DateTime dateOfBirth;
  String gender;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.country,
    required this.city,
    required this.dateOfBirth,
    required this.gender,
  });
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
