import 'package:flutter/material.dart';
import 'package:kanban/%20models/card.dart';

class CardItem extends StatefulWidget {
  final Cards card;

  const CardItem({
    @required this.card,
  });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ID: ' + widget.card.id.toString(),
          ),
          Text(widget.card.text)
        ],
      ),
    );
  }
}
