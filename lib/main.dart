import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Portal',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cat Portal'),
        ),
        body: Center(child: CatListView()),
      ),
    );
  }
}

class Cat {
  final String name;
  final String image;

  Cat({this.name, this.image});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      image: json['image'],
    );
  }
}

class CatListView extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cat>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cat> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Cat>> _fetchJobs() async {
    final jobsListAPIUrl =
        'http://hers.hosts1.ma-cloud.nl/catabase/getcats.php';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['cats'];
      return jsonResponse.map((job) => new Cat.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].name, data[index].image);
        });
  }

  ListTile _tile(String title, String subtitle) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle));
}
