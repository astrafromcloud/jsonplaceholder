import 'package:flutter/material.dart';
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

  Future<List<Comments>> fetchUsers() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=' + widget.comments.postId.toString()));

    if (response.statusCode == 200){
      return List<Comments>
          .from(jsonDecode(response.body).map((x) => Comments.fromJson(x)));
    } else {
      throw Exception();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const GradientAppBar(  // WHY??????????
        ),
        title: const Text(
          'Title',
          style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<Comments>> snapshot){
            if (snapshot.hasData){
              return ListView(
                children: [
                  for (var items in snapshot.data ?? [])
                    Card(
                      color: ThemeConfig.widgetColor,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                        child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, size: 40, color: Colors.white,),
                                    const SizedBox(width: 16,),
                                    Text(items.email,
                                      style: const TextStyle(
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                      ),)
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 18, right: 10),
                                      child: Text(items.body,
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white.withOpacity(0.8)
                                        ),),
                                    ),
                                  ),
                                ],
                              )
                            ]
                        ),
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
          }
      ),
    );
  }
}

