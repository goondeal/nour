import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String) onTextChanged;
  const SearchBar({@required this.onTextChanged, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(30, 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 35.0,
          child: TextField(
            style: const TextStyle(color: Colors.black, fontSize: 18),
            cursorColor: Colors.grey[300],
            autofocus: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Colors.white.withOpacity(0.4),
              filled: true,
            ),
            onChanged: onTextChanged,
          ),
        ),
      ),
    );
  }
}
