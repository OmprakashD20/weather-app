import 'dart:convert';

class Location {
  //response from the api - https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1

  // {
  //  "id":4887398,
  //  "name":"Chicago",
  //  "latitude":41.85003,
  //  "longitude":-87.65005
  // }

  final int id;
  final String name;
  final double latitude;
  final double longitude;

  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as int,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source) as Map<String, dynamic>);
}
