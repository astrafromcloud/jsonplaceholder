import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  late final Box box;

  Future<List<News>> fetchNews() async {
    if (box.isNotEmpty) {
      return List<News>.from(box.values.map((x) => x as News));
    }
    var response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      return List<News>.from(
          jsonDecode(response.body).map((x) => News.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box<News>('newsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
          future: fetchNews(),
          builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data as List).length,
                itemBuilder: (BuildContext context, int index) {
                  News item = (snapshot.data as List)[index];
                  if (box.containsKey(item.id) == false) {
                    box.put(item.id, item);
                  }
                  return Card(
                    child: ListTile(
                      tileColor: ThemeConfig.widgetColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      contentPadding: const EdgeInsets.all(16),
                      title: Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            box.get(item.id).title,
                            style: const TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )),
                      subtitle: Text(
                        box.get(item.id).body,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8)),
                        maxLines: 2,
                        softWrap: true,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FullText(news: box.get(item.id))));
                      },
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
