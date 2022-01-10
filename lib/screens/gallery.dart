import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rome/models/Albums.dart';
import 'dart:convert';
import 'dart:async';

import '../theme.dart';
import 'image_viewer.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({Key? key}) : super(key: key);

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {

  Future<List<Albums>> fetchUsers() async {
    var response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/albums'
    ));

    if (response.statusCode == 200) {
      return List<Albums>
          .from(jsonDecode(response.body).map((x) => Albums.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {


    // Future<List> getUrls() async
    // {
    //   Future<List> urls = getUrls();
    //   List list = await getUrls();
    //   for (int i = 200; i < 300; i++) {
    //     urls[i - 200] = 'https://placekitten.com/$i/$i';
    //   }
    //   return urls;
    // }

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Albums>> snapshot) {
          if (snapshot.hasData) {
            var i = 200;
            return GridView.count(
              primary: true,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 2,
              children: <Widget>[
                for (var item in snapshot.data ?? [])
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Stack(
                      children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotosWidget(
                                    albums: item,
                                  ),
                                ),
                              );
                              i++;
                            },
                          child: Image(image: NetworkImage("https://placekitten.com/$i/$i"),
                        ),
                      ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(24, 0, 12, 12),
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              item.title.toString(),
                              maxLines: 2,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 14, fontFamily: 'Raleway', fontWeight: FontWeight.w500, color: Colors.white
                              ),
                            )
                        )
                      ]
                    ),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
