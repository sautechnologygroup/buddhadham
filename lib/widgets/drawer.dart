import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final List<PageData> pages;

  DrawerWidget({required this.pages});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pages[index].title),
            subtitle: Text(
              'Page ${index + 1} of ${pages.length}\n${pages[index].info}',
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pages[index].page,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PageData {
  final String title;
  final String info;
  final Widget page;

  PageData({required this.title, required this.info, required this.page});
}
