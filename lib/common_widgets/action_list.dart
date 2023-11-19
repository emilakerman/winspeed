import 'package:flutter/material.dart';

class ActionList extends StatefulWidget {
  final List<String> listOfStrings;
  const ActionList({super.key, required this.listOfStrings});

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listOfStrings.length,
      itemBuilder: (context, index) {
        final item = widget.listOfStrings[index];
        return ListTile(
          title: Text(
            item,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
