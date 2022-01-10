import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rome/models/News.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';
import 'full_text.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {

  Future<List<News>> fetchUsers() async {
    var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200){
      return List<News>
          .from(jsonDecode(response.body).map((x) => News.fromJson(x)));
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
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot){
          if (snapshot.hasData){
            return ListView(
              children: [
                for (var items in snapshot.data ?? [])
                  Card(
                    child: ListTile(
                      tileColor: ThemeConfig.widgetColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                      contentPadding: const EdgeInsets.all(16),
                      title: Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                              items.title,
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                              ),
                          )
                      ),
                      subtitle: Text(
                        items.body,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8)
                        ),
                        maxLines: 2,
                        softWrap: true,),
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FullText(news: items)));
                      },
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

