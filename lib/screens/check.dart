import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  Map<int, bool> m = {};

  late final Box box;

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

  Color getTextColor(bool isChecked) {
    if (isChecked) {
      return Colors.white;
      } else {
      return Colors.white.withOpacity(0.54);
    }
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('checkBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty){
            return FutureBuilder(
                future: fenchUsers(),
                builder: (BuildContext context, AsyncSnapshot<List<Checks>> snapshot){
                  if (snapshot.hasData){
                    return ListView.builder(
                        itemCount: (snapshot.data as List).length,
                        itemBuilder: (context, index) {
                          _checks() async{
                            box.add(snapshot.data as List);
                          }
                          _checks();
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
                                        box.putAt(item.id, m[item.id]);
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

            );
          }

          else {
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {

                  var checkData = box.getAt(index);

                  // Checks item = (box as List)[index];
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            checkData[index].title,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                color: getTextColor(checkData[index].completed)
                            ),
                          ),
                          selectedTileColor: const Color(0xFF252056),
                          selected: checkData[index].completed,
                          // selectedColor: const Color(0xFF6C63FF),
                          leading: Checkbox(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            side: const BorderSide(color: Color(0xFF7F78A7), width: 2),
                            checkColor: ThemeConfig.backgroundColor,
                            activeColor: const Color(0xFF6C63FF),
                            value: checkData[index].completed,
                            onChanged: (value) {
                              setState(() {
                                checkData[index].completed = !checkData[index].completed;
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
        },
      ),
    );
  }
}
