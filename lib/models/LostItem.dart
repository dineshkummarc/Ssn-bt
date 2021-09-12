import 'dart:io';

class LostItem {
  String name;
  String? description;
  String busNumber;
  File? image;
  int contactNumber;
  bool? approved;
  LostItem(
      {this.name = "",
      this.description,
      this.contactNumber = 0,
      this.busNumber = "1",
      this.image,
      this.approved});

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      name: json['name'] as String,
      description: json['description'] as String?,
      busNumber: json['busNumber'] as String,
      contactNumber: json['contactNumber'] as int,
      approved: json['approved'] as bool?,
    );
  }
}
