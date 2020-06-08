import 'package:flutter/material.dart';

import 'article.dart';

class Favourited extends StatefulWidget {
  Favourited({Key key, this.favourites}) : super(key: key);

  final List<dynamic> favourites;

  @override
  _Favourited createState() => _Favourited();
}

class _Favourited extends State<Favourited> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return new Future(() => false);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
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
                  Icon(Icons.favorite),
                  SizedBox(width: 8),
                  Text(
                    "Favourites",
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
                  background: Container(color: Colors.red),
                  key: Key(widget.favourites[index]['title']),
                  onDismissed: (direction) => widget.favourites.removeAt(index),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(widget.favourites[index]['title']),
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Article(
                              widget.favourites[index]['title'],
                              widget.favourites[index]['author'],
                              widget.favourites[index]['description'],
                              widget.favourites[index]['url'],
                              widget.favourites[index]['urlToImage'],
                            ),
                          ),
                        )
                      },
                      onLongPress: () => {
                        setState(() {
                          widget.favourites.removeAt(index);
                        })
                      },
                    ),
                  ),
                ),
                childCount: widget.favourites.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, widget.favourites),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_back,
          size: 24,
        ),
      ),
    );
  }
}
