
class User {
  
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
      : id = data['id'],
        username = data['username'],
        email = data['email'],
        photoUrl = data['photoUrl'],
        phoneNumber = data['phoneNumber'],
        joinedSince = data['joinedSince'];

      
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
