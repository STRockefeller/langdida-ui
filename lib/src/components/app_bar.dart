import 'package:flutter/material.dart';

AppBar newLangDiDaAppBar(String title) {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 228, 221, 239),
    title: Text(title),
    // buttons redirect to different pages (Reading, Reviewing, Logs, and Settings)
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
    ),
  );
}
