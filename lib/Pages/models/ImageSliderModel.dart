import 'dart:convert';

class Banners {
  final int id;
  final String url;
  final String imageUrl;

  Banners({
    required this.id,
    required this.url,
    required this.imageUrl,
  });

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      id: json['id'],
      url: json['url'],
      imageUrl: json['image_url'],
    );
  }

  static List<Banners> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Banners.fromJson(json)).toList();
  }
}
