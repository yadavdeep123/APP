class Landmark {
  const Landmark({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.imageUrl,
    this.openingHours,
  });

  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String type;
  final String? imageUrl;
  final String? openingHours;
}
