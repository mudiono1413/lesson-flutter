import 'package:flutter/material.dart';

class MenuUsers extends StatefulWidget {
  final VoidCallback signOut;
  MenuUsers(this.signOut);
  @override
  _MenuUsersState createState() => _MenuUsersState();
}

class _MenuUsersState extends State<MenuUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){
              setState(() {
               widget.signOut(); 
              });
            },
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text("Menu Client / User"),
        ),
      ),
    );
  }
}