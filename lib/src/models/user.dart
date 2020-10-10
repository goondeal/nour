//import 'package:equatable/equatable.dart';

class User {
  //extends Equatable {
  final String id;
  String username;
  String photoUrl;
  String phoneNumber;
  final String email;

  final int joinedSince; //milliSecondsSinceEpoc

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.joinedSince,
    this.phoneNumber,
  });

  User.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? 'null',
        username = data['username'] ?? 'null',
        email = data['email'] ?? 'null',
        photoUrl = data['photoUrl'] ?? 'null',
        phoneNumber = data['phoneNumber'] ?? 'null',
        joinedSince = data['joinedSince'] ?? 0;

  // @override
  // List<Object> get props => [
  //       this.id,
  //       this.username,
  //       this.email,
  //       this.photoUrl,
  //       this.phoneNumber,
  //     ];

      
  User copyWith({
    String username,
    String email,
    String photoUrl,
    String phoneNumber,
}){
    return User(
      id: this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedSince: this.joinedSince,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );

  }
}
