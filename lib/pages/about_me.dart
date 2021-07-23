import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatefulWidget {
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.indigo.shade400,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                'This app shows latest nCOVID-19 pandemic stats and headlines.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.indigo.shade400.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
                  ),
                  Text(
                    'Mohd Mustak',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.indigo.shade400.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('College:',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade800)),
                  Text(
                      'University Institute of Engineering & Technology, MDU Rohtak',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.indigo.shade400.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Branch:',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade800)),
                  Text('Computer Science & Engineering',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800)),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  final url = "https://github.com/mmstq/nCOVID-19-Flutter-App";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'asset/git.png',
                      height: 50,
                      width: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Link to Github repo',
                        style: TextStyle(fontSize: 16, color: Colors.blueAccent))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
