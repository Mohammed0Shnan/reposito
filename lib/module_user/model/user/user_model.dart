




class UserModel {
  String uid;
  String password;
  String email;
  String userName;
  String city;
  String story;
  String image;
  UserModel({this.uid,this.email,this.password,this.userName});
  UserModel.fromJson(Map json):
  this.uid = json['uid'],
  this.email = json['email'],
  this.password= json['password'],
  this.userName= json['userName'],
   this.city= json['city'],
    this.story= json['story'],
     this.image= json['image'];
}