import 'package:Newsworthy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Article extends StatelessWidget {
  Article(this.title, this.author, this.description, this.link);

  RegExp exp = new RegExp(r"<[^>]*>");

  final String title;
  final String description;
  final String author;
  final String link;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Article"),
      ),
      backgroundColor: black,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
              child: Column(
                children: [
                  Text(
                    title ?? "Whoops!",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(author ?? ""),
                  Text(description.replaceAll(exp, '') ?? "Whoops!"),
                  SizedBox(height: 24),
                  OutlineButton(
                    onPressed: () => {_launchURL(link)},
                    child: Text("Read More"),
                  )
                ],
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: black,
        foregroundColor: Colors.white,
        child: Icon(Icons.home),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
