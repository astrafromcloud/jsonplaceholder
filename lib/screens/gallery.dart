import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  late final Box box;

  Future<List<Albums>> fetchUsers() async {
    if (box.isNotEmpty) {
      return List<Albums>.from(box.values.map((e) => e as Albums));
    }
    var response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      return List<Albums>.from(
          jsonDecode(response.body).map((x) => Albums.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    box = Hive.box<Albums>('albumsBox');
    super.initState();
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
            return GridView.builder(
              itemCount: (snapshot.data as List).length,
              primary: true,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                Albums item = (snapshot.data as List)[index];
                if (box.containsKey(item.id) == false) {
                  box.put(item.id, item);
                }
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Stack(children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotosWidget(
                              albums: box.get(item.id),
                            ),
                          ),
                        );
                        i++;
                      },
                      child: Image(
                        image: NetworkImage("https://placekitten.com/$i/$i"),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(24, 0, 12, 12),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          box.get(item.id).title.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ))
                  ]),
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
        },
      ),
    );
  }
}
