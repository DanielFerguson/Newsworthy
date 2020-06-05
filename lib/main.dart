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
      home: MyHomePage(title: 'Newsworthy'),
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
  int _counter = 0;
  final date = new DateFormat('yyyy-MM-dd hh:mm');
  List<dynamic> _stories = [];

  void fetchNews() async {
    var result = await http.get(
        'http://newsapi.org/v2/top-headlines?country=AU&apiKey=8c264203168841c69e10fe9184079bbe');
    setState(() {
      _stories = json.decode(result.body)['articles'];
      print(_stories);
    });
  }

  Future<void> _getData() async {
    setState(() {
      _stories = [];
      fetchNews();
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _buildList() {
    return _stories.length != 0
        ? RefreshIndicator(
            onRefresh: _getData,
            child: GridView.builder(
              primary: false,
              padding: const EdgeInsets.all(20),
              itemCount: _stories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                print(new DateFormat.yMMMd().format(new DateTime.now()));
                return Note(
                  title: _stories[index]['title'],
                  author: _stories[index]['author'],
                  description: _stories[index]['description'],
                  date: "May 21, 2020",
                  backgroundColor: colors[next()],
                  link: _stories[index]['url'],
                );
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: InkWell(
            onTap: () => {},
            child: Row(
              children: [
                Icon(Icons.train),
                SizedBox(
                  width: 16,
                ),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: black,
        body: _buildList());
  }
}

class Note extends StatelessWidget {
  const Note({
    Key key,
    @required this.title,
    @required this.description,
    @required this.author,
    @required this.date,
    @required this.backgroundColor,
    @required this.link,
  }) : super(key: key);

  final String title;
  final String description;
  final String author;
  final String date;
  final Color backgroundColor;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => InkWell(
        onLongPress: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.favorite,
                ),
                SizedBox(
                  width: 16,
                ),
                Text('Saved'),
              ],
            ),
            duration: Duration(seconds: 3),
          ));
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Article(title, author, description, link)),
          );
        },
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: new BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
