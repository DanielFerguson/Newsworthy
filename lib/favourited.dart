import 'package:flutter/material.dart';

import 'article.dart';

class Favourited extends StatefulWidget {
  Favourited({Key key, this.favourites}) : super(key: key);

  static const routeName = '/favourited';
  final List<dynamic> favourites;

  @override
  _Favourited createState() => _Favourited();
}

class _Favourited extends State<Favourited> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
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
              (context, index) => Card(
                color: Colors.black12,
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
    );
  }
}
