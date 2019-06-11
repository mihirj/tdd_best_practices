import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.createdAt,
    required this.firstName,
    required this.profileImage,
  });

  const User.empty()
      : this(
          id: "1",
          createdAt: '_empty.createdAt',
          firstName: '_empty.name',
          profileImage: '_empty.avatar',
        );

  final String id;
  final String createdAt;
  final String firstName;
  final String profileImage;

  @override
  List<Object?> get props => [id, firstName, profileImage];
}
