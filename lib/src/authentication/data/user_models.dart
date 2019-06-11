import 'dart:convert';

import 'package:tdd_practice/core/utils/typedef.dart';
import 'package:tdd_practice/src/authentication/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.profileImage,
    required super.id,
    required super.createdAt,
    required super.firstName,
  });

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? firstName,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  DataMap toMap() => {
        'id': id,
        'createdAt': createdAt,
        'first_name': firstName,
        'profile_image': profileImage,
      };

  UserModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          createdAt: map['createdAt'] as String,
          firstName: map['first_name'] as String,
          profileImage: map['profile_image'] as String,
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  String toJson() => jsonEncode(toMap());

  const UserModel.empty()
      : this(
          id: "1",
          createdAt: '_empty.createdAt',
          firstName: '_empty.firstName',
          profileImage: '_empty.profileImage',
        );
}
