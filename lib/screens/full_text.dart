import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rome/models/Comments.dart';
import 'package:rome/models/News.dart';

import '../main.dart';
import '../theme.dart';
import 'comments.dart';


class FullText extends StatefulWidget {
  const FullText({Key? key, required this.news}) : super(key: key);

  final News news;


  @override
  _FullTextState createState() => _FullTextState();
}

class _FullTextState extends State<FullText> {

  Future<List<Comments>> fetchUsers() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/comments?postId=' + widget.news.id.toString()));

    if (response.statusCode == 200){
      return List<Comments>
          .from(jsonDecode(response.body).map((x) => Comments.fromJson(x)));
    } else {
      throw Exception('Failed to load' + widget.news.userId.toString() + "'s albums");
    }
  }

  @override
  Widget build(BuildContext context) {

    // var i = 0;
    // int? check = 0;

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
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
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Comments>> snapshot){
          if (snapshot.hasData){
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 26, 0, 32),
                    child: Text(
                      widget.news.title,
                      style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                  ),
                  Text(
                    widget.news.body,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 32,),
                  ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      for (var items in snapshot.data ?? [])
                        if (items.id % 5 == 1 || items.id % 5 == 2)// for (var items = snapshot.data![i]; i != 2; i++)  //var items in snapshot.data ?? []  // dynamic items = snapshot.data![0]; items != snapshot.data![0];
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
                  ),
                ],
              ),
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
        },
      ),
      bottomNavigationBar: FutureBuilder(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Comments>> snapshot){
          if (snapshot.hasData){
              return Material(
              color: const Color(0xFF6C63FF),
              child: InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      for (var items in snapshot.data ?? []) {
                        return CommentsWidget(comments: items);
                      }
                      throw Exception();
                    }));
                    // check = items.postId;
                },
                child: SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25.67),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: 'Show me ', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.5), fontSize: 18)),
                                  const TextSpan(text: '5 results', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18))
                                ]
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.visibility, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );

          }
          else {
            return Text(snapshot.error.toString());
          }
        },
      )
    );
  }
}
