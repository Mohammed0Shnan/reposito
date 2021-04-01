class EditProfileRequest {
 String userName;
 EditProfileRequest({this.userName});

 EditProfileRequest.fromJson(Map<String, dynamic> json) {
   this.userName = json['userName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    return data;
  }
}
