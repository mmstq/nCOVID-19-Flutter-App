import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CovidMap extends StatelessWidget {


  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  final url = 'https://maps.mapmyindia.com/corona';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('COVID Map of India', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal,fontSize: 15),),
              SizedBox(height: 2,),
              Text('Powered by MapMyIndia', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal,fontSize: 10),),
            ],
          ),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}
