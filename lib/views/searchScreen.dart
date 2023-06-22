import 'package:buddhadham/models/section.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();
  List<String> searchResults = [];

  void search() {
    String query = searchTextController.text.toLowerCase();

    // Clear the previous search results
    setState(() {
      searchResults.clear();
    });

    // Implement your search logic here
    // Use the query to search within Section.listAllText
    // Populate the searchResults list with the search results
    for (String item in Section.listAllText) {
      if (item.toLowerCase().contains(query)) {
        setState(() {
          searchResults.add(item);
        });
      }
    }
  }

  String truncateContent(String content) {
    if (content.length <= 100) {
      return content;
    } else {
      return content.substring(0, 100) + '...';
    }
  }

  void navigateToPage(int pageIndex) {
    // Implement the navigation logic here
    // You can use the pageIndex to navigate to the corresponding page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ค้นหา')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                labelText: 'ค้นหา',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: search,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                String item = searchResults[index];
                String truncatedContent = truncateContent(item);
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        'หน้า ${index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                        ),
                      ),
                      subtitle: Text(
                        truncatedContent,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        navigateToPage(index);
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                      height: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
