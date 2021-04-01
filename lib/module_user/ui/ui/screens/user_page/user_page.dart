import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/module_auth/enums/auth_source.dart';
import 'package:flutter_boilerplate/module_auth/enums/user_type.dart';
import 'package:flutter_boilerplate/module_auth/manager/auth_manager/auth_manager.dart';
import 'package:flutter_boilerplate/module_auth/presistance/auth_prefs_helper.dart';
import 'package:flutter_boilerplate/module_auth/repository/auth/auth_repository.dart';
import 'package:flutter_boilerplate/module_auth/service/auth_service/auth_service.dart';
import 'package:flutter_boilerplate/module_network/http_client/http_client.dart';
import 'package:flutter_boilerplate/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:flutter_boilerplate/module_user/bloc/user/user_page.bloc.dart';
import 'package:flutter_boilerplate/module_user/model/user/user_model.dart';
import 'package:flutter_boilerplate/module_user/ui/ui/screens/user_detile/user_detile.dart';
import 'package:flutter_boilerplate/module_user/ui/ui/widget/auth_error.dart';
import 'package:flutter_boilerplate/utils/logger/logger.dart';
import 'package:inject/inject.dart';

@provide
class UserPage extends StatefulWidget {
  UserPageBloc _userPageBloc;
  final AuthService _authService = AuthService(
      AuthPrefsHelper(),
      AuthManager(AuthRepository(ApiClient(Logger()))),
      FireNotificationService());
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  String _userName, _password, _email;
  List<UserModel> _userList = [];
  int currentState = UserPageBloc.STATUS_CODE_INIT;
  User user;
  bool initiated = false;
  bool islogin = false;

  @override
  void initState() {
    widget._userPageBloc = UserPageBloc();
    widget._authService.getToken().then((value){
      if(value!=null){
        setState(() {
          islogin = !islogin;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentState == UserPageBloc.STATUS_CODE_INIT) {
      widget._userPageBloc.getUsers();
    }
    widget._userPageBloc.userBlocStream.listen((event) {
      currentState = event.first;
      if (event.first == UserPageBloc.STATUS_CODE_GOT_DATA) {
        _userList = event.last;
        setState(() {});
      }
    });
    return Scaffold(
        backgroundColor: const Color(0xFFE9E9E9),
        appBar: AppBar(
          title: Text("users"),
          centerTitle: true,
        ),
        drawer: buildDrawer(context, userName: ''),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: (_userList != null)
              ? (_userList.length == 0)
                  ? Center(
                      child: Text('empity'),
                    )
                  : buildListItems(context, _userList)
              : Center(child: Container()),
        ));
  }

  Drawer buildDrawer(context, {String userName}) {
    TextStyle style =
        const TextStyle(fontSize: 23, fontWeight: FontWeight.bold);
    return Drawer(
        child: ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgroundyes.png'),
                  fit: BoxFit.fitWidth)),
        ),
        SizedBox(
          height: 40,
        ),
        (islogin)
            ? ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'logout',
                  style: style,
                ),
                onTap: () {
                  widget._authService.logout();
                  {
                    setState(() {
                      islogin = !islogin;
                    });
                  }
                },
              )
            : Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.donut_small_rounded),
                      title: Text(
                        'login',
                        style: style,
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                content: Container(
                                  height: 350,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                            TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'enter your name',
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            _userName = v;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'enter your email',
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            _email = v;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'enter your password'),
                                        onChanged: (v) {
                                          setState(() {
                                            _password = v;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          String uid = await widget._authService
                                              .loginFireStore(
                                                  _email, _password,true);
                                          if(uid!=null){
                                            bool logRes = await widget._authService.loginUser(
                                                uid,
                                                _password,
                                                _userName,
                                                USER_TYPE.ROLE_CAPTAIN,
                                                AUTH_SOURCE.OTHER);
                                            widget._authService.getToken().then((value){
                                              if(value!=null){

                                                print(value);
                                                setState(() {
                                                  islogin = !islogin;
                                                });
                                              }
                                            });
                                          }
                                          else{

                                           return showErrorDialog(context);
                                          }
                                          Navigator.of(context).pop();



                                        },
                                        child: Text("login"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      //     }
                      ,
                    ),
                    ListTile(
                      leading: Icon(Icons.donut_small_rounded),
                      title: Text(
                        'register',
                        style: style,
                      ),
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                content: Container(
                                  height: 320,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'register',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'enter your name',
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            _userName = v;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'enter your email',
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            _email = v;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'enter your password',
                                        ),
                                        onChanged: (v) {
                                          setState(() {
                                            _password = v;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          String uid = await widget._authService
                                              .loginFireStore(
                                                  _email, _password ,false);
                                          await widget._userPageBloc.createUser(
                                              uid,
                                              _email,
                                              _password,
                                              _userName);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("register"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      //     }
                      ,
                    ),
                  ],
                ),
              )
      ],
    ));
  }

  Widget buildListItems(context, List<UserModel> users) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(
                radius: 30,
                child: Hero(
                  tag: _userList[index],
                  child: Image.asset(
                    'assets/backgroundyes.png',
                    fit: BoxFit.cover,
                  ),
                )),
            title: Text(users[index].userName.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
               trailing: Icon(Icons.info,size: 28, color: Colors.blueAccent,),
            onTap: () async {
              if (islogin) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserDetile(
                              user: users[index],
                              tag: index,
                              userPageBloc: widget._userPageBloc,
                          authService:widget._authService ,
                            )));
              } else {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        content: Container(
                          height: 180,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Wroing',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ' Go to the dashboard to log in to enjoy modification privileges ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        );
      },
    );
  }
}
