import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String searchText) onTextChanged;

  SearchBar({this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextChanged,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: Icon(Icons.search),
        fillColor: Colors.white,
        hintText: 'Filter by name or email',
        contentPadding: const EdgeInsets.all(10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20.7),
        ),
      ),
      textInputAction: TextInputAction.go,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    );
  }
}
