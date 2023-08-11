import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.id,
    required this.username,
  });

  final int id;
  final String username;

  @override
  List<Object?> get props => [id, username];
}
