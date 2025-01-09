class User {
  final int id;
  final String name;
  final String mobile;
  final String address;
  final String status;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.mobile,
    required this.address,
    required this.status,
    required this.createdAt,
  });

  // Factory method to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      address: json['address'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      mobile: map['mobile'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }
}
