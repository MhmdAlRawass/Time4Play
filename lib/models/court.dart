import 'package:time4play/models/venue.dart';

class Court {
  final String id;
  final String name;
  final String location;
  final String type;
  final bool availability;
  final Venue venue;

  Court({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    this.availability = false,
    required this.venue,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      type: json['type'],
      availability: json['availability'] ?? false,
      venue: Venue.fromJson(json['venue']),
    );
  }
}
