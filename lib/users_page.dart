import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({super.key});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final List<String> items = List<String>.generate(10000, (i) => '$i');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xff764abc),
              child: Text(items[index]),
            ),
            title: Text('Item ${items[index]}'),
            subtitle: Text('Item description'),
            trailing: Icon(Icons.more_vert),
          );
        },
      )),
    );
  }
}
