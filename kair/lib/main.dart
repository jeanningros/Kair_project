import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyHomePage(),
  ));
}

class Weather extends StatelessWidget {
  final Map<String, dynamic> data;
  Weather(this.data);
  Widget build(BuildContext context) {
    double temp = data['main']['temp'];
    return new Text(
      '${temp.toStringAsFixed(1)} °C',
      style: Theme.of(context).textTheme.display4,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<http.Response> _response;

  void initState() {
    super.initState();
    _refresh();

  }

  void _refresh() {
    setState(() {
      _response = http.get(
          'https://api.waqi.info/feed/nice/?token=03341887cc71813ec2c2a3d46b2b0e2217e625fd'
      );
    });
  }


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Weather Example"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: _refresh,
      ),
      body: new Center(
          child: new FutureBuilder(
              future: _response,
              builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
                if (!response.hasData)
                  return new Text('Loading...');
                else if (response.data.statusCode != 200) {
                  return new Text('Could not connect to weather service.');
                } else {
                  Map<String, dynamic> json = jsonDecode(response.data.body);
                  Map<String, dynamic> data = json['data'];
                  var taux = data['aqi'];

                  var ville = data['city'];
                  var name = ville['name'];
                  return new Page(ville: ville, name: name, taux: taux,);

                }
              }
          )
      ),
    );
  }
}


class Page extends StatelessWidget {
  var ville;
  var name;
  var taux;

  Page({this.ville, this.name, this.taux});
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(

      ),
      child: Column(
        children: <Widget>[
          Text('taux de polution à $name'),
          Text('$taux µg/m3'),
        ],
      ),
    );
  }
}
