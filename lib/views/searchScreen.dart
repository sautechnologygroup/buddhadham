import 'package:flutter/material.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/views/screenForRead.dart';
import 'package:html/parser.dart' show parse;

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
        String cleanText = parse(allTexts[i]).body?.text ?? '';
        cleanText = cleanText.replaceAll('&nbsp;', ''); // Remove '&nbsp;'
        cleanText =
            cleanText.replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
        searchResults.add('Page ${i + 1}: ${cleanText.substring(0, 50)}...');
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
        title: const Center(child: Text('ค้นหา')),
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
                  onTap: () async {
                    int pageNumber = index + 1; // Get the correct page number

                    List<String> allTexts = await Section.listAllText;
                    String query = _searchController.text;
                    int page = 0;
                    int pageIndex = -1;

                    for (int i = 0; i < allTexts.length; i++) {
                      if (allTexts[i].contains(query)) {
                        page++;
                        if (page == pageNumber) {
                          pageIndex = i;
                          break;
                        }
                      }
                    }

                    if (pageIndex != -1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadScreen(
                            initialPage: pageIndex + 1,
                          ),
                        ),
                      );
                    }
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
