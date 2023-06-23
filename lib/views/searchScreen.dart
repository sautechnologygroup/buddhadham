import 'package:flutter/material.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/views/screenForRead.dart';
import 'package:html/parser.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  Future<void> _search(String query) async {
    List<String> allTexts = await Section.listAllText;
    List<String> searchResults = [];

    for (int i = 0; i < allTexts.length; i++) {
      if (allTexts[i].contains(query)) {
        searchResults.add('Page ${i + 1}: ${allTexts[i].substring(0, 50)}...');
      }
    }

    setState(() {
      _searchResults = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
              ),
              onSubmitted: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadScreen(
                          initialPage: index + 1,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
