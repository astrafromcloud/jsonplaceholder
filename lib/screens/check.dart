import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rome/models/Checks.dart';
import 'package:rome/theme.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  _CheckPageState createState() => _CheckPageState();
}


class _CheckPageState extends State<CheckPage> {

  // this function fetch users
  Map<int, bool> m = {};

  Future<List<Checks>> fenchUsers() async{
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200){
      return List<Checks>
          .from(jsonDecode(response.body).map((x) => Checks.fromJson(x)));
    }
    else {
      throw Exception();
    }
  }

  // Hello, world!
  Color getTextColor(bool isChecked) {
    if (isChecked) {
      return Colors.white;
      } else {
      return Colors.white.withOpacity(0.54);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
        future: fenchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Checks>> snapshot){
          if (snapshot.hasData){
            return ListView.builder(
              itemCount: (snapshot.data as List).length,
              itemBuilder: (context, index) {
                Checks item = (snapshot.data as List)[index];
                if(m.containsKey(item.id) == false) {
                  m[item.id] = item.completed;
                }
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: getTextColor(item.completed)
                          ),
                        ),
                        selectedTileColor: const Color(0xFF252056),
                        selected: m[item.id]!,
                        // selected: items.completed,
                        // selectedColor: const Color(0xFF6C63FF),
                        leading: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                          side: const BorderSide(color: Color(0xFF7F78A7), width: 2),
                          checkColor: ThemeConfig.backgroundColor,
                          activeColor: const Color(0xFF6C63FF),
                          value: m[item.id]!,
                          onChanged: (value) {
                            setState(() {
                              m[item.id] = !m[item.id]!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
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
        }

      ),
    );
  }
}
