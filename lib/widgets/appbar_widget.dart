import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final bool showTrailing;

  AppBarWidget({
    this.title,
    this.iconData,
    this.showTrailing = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      stretch: false,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Row(
            children: <Widget>[
              Container(
                color: Color(0xff00999a),
                height: 25,
                width: width / 3,
              ),
              Container(
                color: Color(0xffee6f31),
                height: 25,
                width: width / 3,
              ),
              Container(
                color: Color(0xfffbb03b),
                height: 25,
                width: width / 3,
              )
            ],
          )),
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding:
              EdgeInsets.only(bottom: (title == null ? 0 : 50), top: 0),
          title: title == null
              ? null
              : Text(
                  title,
                ),
          background: Padding(
              padding: EdgeInsets.fromLTRB(25, 50, 50, 20),
              child: Image.asset('assets/logoAppTransparent.png',
                  fit: BoxFit.scaleDown))),
    );
  }
}
