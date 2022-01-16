import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:rome/main.dart';
import 'dart:convert';

import 'package:rome/models/User.dart';
import 'package:rome/screens/map_widget.dart';
import 'package:rome/theme.dart';

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  late final Box box;

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/users?id=' +
            widget.user.id.toString()));

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

  String getName() {
    int idx = widget.user.name.toString().indexOf(" ");
    var str1 = widget.user.name.substring(0, idx).trim();
    return str1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: const GradientAppBar(),
          title: Text(
            getName(),
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: ThemeConfig.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(
                height: 32,
              ),
              const CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Color(0xFF979797),
                  size: 100,
                ),
                backgroundColor: Color(0xFF6A6875),
                radius: 70,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                box.get(widget.user.id).name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Raleway',
                    fontSize: 20),
              )),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                '@' + box.get(widget.user.id).username,
                style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 14,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w500),
              )),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  hintText: "E-mail", labelText: box.get(widget.user.id).email),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  labelText: box.get(widget.user.id).phone, hintText: 'Phone'),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  labelText: box.get(widget.user.id).website,
                  hintText: 'Website'),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  labelText: box.get(widget.user.id).company.name,
                  hintText: 'Company'),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  labelText: box.get(widget.user.id).address.city +
                      ", " +
                      widget.user.address.street +
                      ", " +
                      widget.user.address.suite +
                      ", " +
                      widget.user.address.zipcode,
                  hintText: 'Address'),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                height: 215,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: MyHomePage(
                    lat: box.get(widget.user.id).address.geo.lat,
                    lng: box.get(widget.user.id).address.geo.lng),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key, required this.labelText, required this.hintText})
      : super(key: key);

  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ThemeConfig.backgroundColor),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF211D37), width: 2),
                    borderRadius: BorderRadius.circular(4)),
                contentPadding: const EdgeInsets.only(left: 26),
                labelText: labelText,
                labelStyle: const TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
              left: 24,
              top: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                color: ThemeConfig.backgroundColor,
                child: Text(
                  hintText,
                  style:
                      const TextStyle(color: Color(0xFF7F78A7), fontSize: 12),
                ),
              ))
        ],
      ),
    );
  }
}
