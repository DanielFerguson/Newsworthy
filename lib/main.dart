import 'package:Newsworthy/favourited.dart';
import 'package:Newsworthy/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:Newsworthy/article.dart';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newsworthy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.comfortable,
      ),
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final date = new DateFormat('yyyy-MM-dd hh:mm');
  List<dynamic> _stories = [];
  List<dynamic> _favorited = [];

  _navigateArticle(BuildContext context, index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Article(
          _stories[index]['title'],
          _stories[index]['author'],
          _stories[index]['description'],
          _stories[index]['url'],
          _stories[index]['urlToImage'],
        ),
      ),
    );

    print(result);
  }

  _navigateFavourites(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Favourited(
          favourites: _favorited,
        ),
      ),
    );

    setState(() {
      _favorited = result;
    });
  }

  Future<void> refreshStories() async {
    var result = await http.get(
        'http://newsapi.org/v2/top-headlines?country=AU&apiKey=8c264203168841c69e10fe9184079bbe');

    setState(() {
      _stories = json.decode(result.body)['articles'];
      _favorited = [];
    });
  }

  @override
  void initState() {
    super.initState();
    refreshStories();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshStories,
      child: Material(
        color: Colors.black,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: Icon(_favorited.length > 0
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () => {
                    _favorited.length > 0
                        ? _navigateFavourites(context)
                        : Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Hold a story title to save it for later!'),
                              duration: Duration(seconds: 2),
                            ),
                          )
                  },
                ),
              ],
              expandedHeight: 150,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                centerTitle: true,
                title:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.train),
                  SizedBox(width: 8),
                  Text(
                    "Newsworthy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ]),
                background: Image.network(
                  "https://images.pexels.com/photos/998641/pexels-photo-998641.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Dismissible(
                  key: Key(_stories[index]['title']),
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: Icon(
                        Icons.favorite,
                        size: 32,
                      ),
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: Icon(
                        Icons.remove_circle,
                        size: 32,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      setState(() {
                        _favorited.add(_stories[index]);
                        _stories.removeAt(index);
                      });
                    } else {
                      setState(() {
                        _stories.removeAt(index);
                      });
                    }
                  },
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_stories[index]['title']),
                    ),
                    onTap: () => _navigateArticle(context, index),
                    onLongPress: () => setState(() {
                      _favorited.add(_stories[index]);
                    }),
                  ),
                ),
                childCount: _stories.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
