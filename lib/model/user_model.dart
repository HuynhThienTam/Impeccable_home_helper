
// class UserModel{
//   String name;
//   String email;
//   String bio;
//   String profilePic;
//   String createdAt;
//   String phoneNumber;
//   String uid;
//   String passWord;
//   String lastLogOutAt;
//   String status;//onl,off
//   UserModel({
//     required this.name,
//     required this.email,
//     required this.bio,
//     required this.profilePic,
//     required this.createdAt,
//     required this.phoneNumber,
//     required this.uid,
//     required this.passWord,
//     required this.lastLogOutAt,
//     required this.status,
//   });
  
//   factory UserModel.fromMap(Map<String,dynamic>map){
//     return UserModel(
//       name: map['name'] ?? '', 
//       email: map['email'] ?? '', 
//       bio: map['bio'] ?? '', 
//       profilePic: map['profilePic']??'', 
//       createdAt: map['createdAt']??'', 
//       phoneNumber: map['phoneNumber']??'', 
//       uid: map['uid']??'',
//       passWord: map['passWord']??'',
//       lastLogOutAt: map['lastLogOutAt']??'',
//       status: map['status']??'',
//       );
//   }

//   Map<String, dynamic> toMap(){
//     return{
//       "name":name,
//       "email":email,
//       "uid":uid,
//       "bio":bio,
//       "profilePic":profilePic,
//       "phoneNumber":phoneNumber,
//       "createdAt": createdAt,
//       "passWord":passWord,
//       "lastLogOutAt":lastLogOutAt,
//       "status":status,
//     };
//   }
// }