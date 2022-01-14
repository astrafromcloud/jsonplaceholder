import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rome/screens/check.dart';
import 'package:rome/screens/contacts.dart';
import 'package:rome/screens/gallery.dart';
import 'package:rome/screens/news.dart';
import 'package:rome/theme.dart';

import 'models/Checks.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChecksAdapter());
  await Hive.openBox<Checks>('checkBox');

  runApp(const AppProject());
}

class AppProject extends StatefulWidget {
  const AppProject({Key? key}) : super(key: key);

  @override
  _AppProjectState createState() => _AppProjectState();
}

PageController pageController = PageController();

final list = [
  'News', 'Gallery', 'Check', 'Contacts'
];

final pages = [
  const NewsWidget(),
  const GalleryWidget(),
  const CheckPage(),
  const ContactsWidget(),
];

class _AppProjectState extends State<AppProject> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: const GradientAppBar(  // WHY??????????
          ),
          title: Center(
            child: Text(
              list[_currentIndex],
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
        body: pages[_currentIndex],

        bottomNavigationBar:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ThemeConfig.grad1, ThemeConfig.grad2],
              begin: Alignment.topCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: BottomNavigationBar(
            selectedFontSize: 12,
            unselectedFontSize: 10.5,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() {
              _currentIndex = index;
            }),
            showUnselectedLabels: true,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            unselectedItemColor: Colors.white,
            selectedIconTheme: const IconThemeData(color: Colors.white),
            items:  [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: Text(
                  list[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                title: Text(
                  list[1],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                title: Text(
                  list[2],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_border),
                title: Text(
                  list[3],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class GradientAppBar extends StatefulWidget {
  const GradientAppBar({Key? key}) : super(key: key);

  @override
  _GradientAppBarState createState() => _GradientAppBarState();
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [ThemeConfig.grad1, ThemeConfig.grad2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.4, 0.9
              ],
          )
      ),
    );
  }
}