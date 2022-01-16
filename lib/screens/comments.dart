import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rome/models/Comments.dart';

import '../main.dart';
import '../theme.dart';

class CommentsWidget extends StatefulWidget {
  final Comments comments;

  const CommentsWidget({Key? key, required this.comments}) : super(key: key);

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  late final Box box;

  Future<List<Comments>> fetchUsers() async {
    if (box.isNotEmpty) {
      return List<Comments>.from(box.values.map((e) => e as Comments));
    }
    var response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/comments?postId=' +
            widget.comments.postId.toString()));

    if (response.statusCode == 200) {
      return List<Comments>.from(
          jsonDecode(response.body).map((x) => Comments.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    box = Hive.box<Comments>('commentsBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientAppBar(// WHY??????????
            ),
        title: const Text(
          'Title',
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
          future: fetchUsers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Comments>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: (snapshot.data as List).length,
                  itemBuilder: (BuildContext context, int index) {
                    Comments item = (snapshot.data as List)[index];
                    if (box.containsKey(item.id) == false) {
                      box.put(item.id, item);
                    }
                    return Card(
                      color: ThemeConfig.widgetColor,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  box.get(item.id).email,
                                  style: const TextStyle(
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 18, right: 10),
                                  child: Text(
                                    box.get(item.id).body,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    );
                  });
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
