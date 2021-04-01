import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/module_auth/service/auth_service/auth_service.dart';
import 'package:flutter_boilerplate/module_user/bloc/user/user_page.bloc.dart';
import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';

class UserDetile extends StatefulWidget {
  UserModel user;
  final UserPageBloc userPageBloc;
  final AuthService authService;
  final int tag;
  UserDetile({this.user,this.tag,this.userPageBloc,this.authService});

  @override
  _UserDetileState createState() => _UserDetileState();
}

class _UserDetileState extends State<UserDetile> {
  bool formEnable = false;
  String newName;
  int currentState = UserPageBloc.STATUS_CODE_GOT_DATA;
  @override
  Widget build(BuildContext context) {
        widget.userPageBloc.userBlocStream.listen((event) {
      currentState = event.first;
      if (event.first == UserPageBloc.STATUS_CODE_GOT_DATA) {
        setState(() {
        widget.user.userName = event.last[widget.tag].userName;
        });
      }
    });
    return Scaffold(
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         SizedBox(height: 40,),
         Align(
           alignment: Alignment.topLeft,
           child: IconButton(
             icon: Icon(Icons.arrow_back),
             onPressed: (){
               Navigator.of(context).pop();
             },
           ),
         ),
         SizedBox(height: 50,),
         Hero(
           tag: widget.tag,
           child:  ClipRRect(
             borderRadius: BorderRadius.circular(50),
                           child: Image.asset(
               'assets/backgroundyes.png',
               fit: BoxFit.cover,
             ),
           ),
         ),
       SizedBox(height: 50,),
      Expanded(
    
              child: ListTile(
                leading: Text('User Name : ' ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          title: Text(widget.user.userName ,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
          trailing: IconButton(
            onPressed: ()async{
               await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    content: Container(
                      height: 200,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Edit profile',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'enter your new name '
                                  ),
                            onChanged: (v) {
                              setState(() {
                                newName = v;
                              });
                            },
                          ),
                       
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton(
                            onPressed: () async {
                           String token =  await widget.authService.getToken();

                          await widget.userPageBloc.editProfile(newName,token);
                           Navigator.of(context).pop();
                            },
                            child: Text("send"),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          
            },
            icon: Icon(Icons.edit,color: Colors.blueAccent,size: 30,),
          ),
        ),
      )
    


       ],
     )
    );
  }
}