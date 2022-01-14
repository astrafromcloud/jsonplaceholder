import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.lat, required this.lng}) : super(key: key);

  final String lat;
  final String lng;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    controller = MapController(
      location: LatLng(double.parse(widget.lat), double.parse(widget.lng)),
      tileSize: 512
    );
  }

  late MapController controller;

  Widget _buildMarkerWidget(Offset pos, Color color) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      width: 24,
      height: 24,
      child: Icon(Icons.location_on, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {

          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          final centerMarkerWidget =
          _buildMarkerWidget(centerLocation, const Color(0xFF6C63FF));

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {

                      final url =
                          'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=pk.eyJ1IjoicXdlcnR5bm8iLCJhIjoiY2t4dnd3dzQ0MWJkODJub3pmODlremNtZSJ9.-6GvH1WR9ZtW8p7nYyEQlQ';

                      return CachedNetworkImage(
                        imageUrl : url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  centerMarkerWidget,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
