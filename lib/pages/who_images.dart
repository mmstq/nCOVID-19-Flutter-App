import 'package:COVID19/models/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WHO extends StatefulWidget {
  final List<ImageModel> _images;

  WHO(this._images);

  @override
  _WHOState createState() => _WHOState();
}

class _WHOState extends State<WHO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Image.asset('asset/who.png',color: Colors.white,height: 40,width: 40,),
        onPressed: () async {
          final url = 'https://www.who.int/health-topics/coronavirus';
          if (await canLaunch(url)) launch(url);
        },
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget._images.length,
        itemBuilder: (context, index)=>Padding(
          padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: widget._images[index].imageUrl,
            ),
          ),
        ),
        ),
        
      );
  }
}

class ViewImage extends StatelessWidget {
  final ImageModel _model;
  final int _tag;
  ViewImage(this._model, this._tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap:()=> Navigator.of(context).pop(),
        child: Center(
          child: Hero(
            tag: _tag,
            child: CachedNetworkImage(
              imageUrl: _model.imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}

