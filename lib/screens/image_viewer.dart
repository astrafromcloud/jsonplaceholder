import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rome/main.dart';
import 'package:rome/models/Albums.dart';
import 'package:rome/models/Photos.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';

class PhotosWidget extends StatefulWidget {
  const PhotosWidget({
    Key? key,
    required this.albums,
    /*required this.photos*/
  }) : super(key: key);

  final Albums albums;

  @override
  _PhotosWidgetState createState() => _PhotosWidgetState();
}

class _PhotosWidgetState extends State<PhotosWidget> {
  late final Box box;

  Future<List<Photos>> fetchUsers() async {
    if (box.isNotEmpty) {
      return List<Photos>.from(box.values.map((e) => e as Photos));
    }

    var response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/photos?albumId=' +
            widget.albums.userId.toString()));

    if (response.statusCode == 200) {
      return List<Photos>.from(
          jsonDecode(response.body).map((x) => Photos.fromJson(x)));
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    box = Hive.box<Photos>('photoBox');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Title',
          style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        flexibleSpace: const GradientAppBar(),
      ),
      backgroundColor: ThemeConfig.backgroundColor,
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Photos>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: (snapshot.data as List).length,
              primary: true,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                Photos item = (snapshot.data as List)[index];
                if (box.containsKey(item.id) == false) {
                  box.put(item.id, item);
                }
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(children: [
                    InkWell(
                      onTap: () {},
                      child: Image(
                        image: NetworkImage(box.get(item.id).url),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(18, 0, 12, 6),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          box.get(item.id).title.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 12,
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
