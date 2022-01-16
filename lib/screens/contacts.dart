import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  late final Box box;

  Future<List<User>> fetchUsers() async {
    if (box.isNotEmpty) {
      return List<User>.from(box.values.map((e) => e as User));
    }
    var response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      return List<User>.from(
          jsonDecode(response.body).map((x) => User.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    box = Hive.box<User>('userBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data as List).length,
                itemBuilder: (BuildContext context, int index) {
                  User item = (snapshot.data as List)[index];
                  if (box.containsKey(item.id) == false) {
                    box.put(item.id, item);
                  }
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDataWidget(
                                      user: box.get(item.id),
                                    )));
                      },
                      leading: const Icon(
                        Icons.person,
                        size: 36,
                        color: Colors.white,
                      ),
                      title: Text(
                        box.get(item.id).name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
