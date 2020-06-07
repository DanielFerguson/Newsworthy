import 'package:Newsworthy/favourited.dart';
import 'package:Newsworthy/utils/utils.dart';
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
        body: MyHomePage(title: 'Newsworthy'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final date = new DateFormat('yyyy-MM-dd hh:mm');
  List<dynamic> _stories = [];
  List<dynamic> _favorited = [];

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
                    if (_favorited.length > 0)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Favourited(
                              favourites: _favorited,
                            ),
                          ),
                        )
                      }
                    else
                      {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Hold a story title to save it for later!'),
                            duration: Duration(seconds: 3),
                          ),
                        )
                      }
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
                (context, index) => Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(_stories[index]['title']),
                      onTap: () => Navigator.push(
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
                      ),
                      onLongPress: () => {
                        setState(() {
                          _favorited.add(_stories[index]);
                        })
                      },
                    ),
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
