class Place {
  final String id;
  final String name;
  final String imageUrl;

  Place({required this.id, required this.name, required this.imageUrl});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
