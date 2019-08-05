import 'package:flutter/material.dart';

abstract class AbstractPage extends StatefulWidget {
  AbstractPage({
    Key key,
    @required this.appBarTitle,
    @required this.content,
    this.navItem,
  }) : super(key: key);

  final String appBarTitle;
  final Widget content;
  final BottomNavigationBarItem navItem;

  _AbstractPageState createState() => _AbstractPageState();
}

class _AbstractPageState extends State<AbstractPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: widget.content);
  }
}