import 'package:flutter/material.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final List<String> entries = <String>['A', 'B', 'C', 'D'];
  final List<int> colorCodes = <int>[600, 500, 400, 300];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(7),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) =>
                singleListItem(index)));
  }

  singleListItem(index) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(7.0),
      color: Colors.teal[colorCodes[index]],
      child: Center(child: Text('Entry ${entries[index]}')),
    );
  }
}
