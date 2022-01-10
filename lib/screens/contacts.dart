import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rome/models/User.dart';
import 'package:rome/screens/UserData.dart';
import 'package:rome/theme.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({Key? key}) : super(key: key);

  @override
  _ContactsWidgetState createState() => _ContactsWidgetState();

}

class _ContactsWidgetState extends State<ContactsWidget> {

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200){
      return List<User>
          .from(jsonDecode(response.body).map((x) => User.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
        future: fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot){
        if (snapshot.hasData){
          return ListView(
              children: [
                for(var item in snapshot.data ?? [])
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    child: ListTile(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UserDataWidget(user: item,)));},
                      leading: const Icon(Icons.person, size: 36, color: Colors.white,),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'Raleway', fontSize: 16, color: Colors.white),),
                    ),
                  )
              ],
            );
        }
        else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
