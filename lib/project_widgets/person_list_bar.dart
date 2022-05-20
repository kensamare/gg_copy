import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PersonListBar extends StatelessWidget {
  PersonListBar({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.text,
  }) : super(key: key);

  final String imageUrl;
  final String username;
  final String text;
  abstract Widget lastWidget;
  abstract Widget description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 24,
        ),
        Expanded(
          child: Column(
            children: [
              Text(username),
              description,
            ],
          ),
        )
      ],
    );
  }
}
