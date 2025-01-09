class UserDetailsModel {
  int? status;
  String? message;
  Data? data;

  UserDetailsModel({this.status, this.message, this.data});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    // Check for the key "data" or "user"
    if (json.containsKey('data') && json['data'] != null) {
      data = Data.fromJson(json['data']);
    } else if (json.containsKey('user') && json['user'] != null) {
      data = Data.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson(); // Default to "data" key
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? mobile;
  String? address;

  Data({this.id, this.name, this.mobile, this.address});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    return data;
  }
}
