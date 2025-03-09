class Venue {
  final String name;
  final String address;
  final String city;
  final String state;
  final String phone;
  final String website;
  final double latitude;
  final double longitude;

  Venue({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.phone,
    required this.website,
    required this.latitude,
    required this.longitude,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      phone: json['phone'],
      website: json['website'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}