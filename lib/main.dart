// import 'package:buddhadham/utils/appcolors.dart';
// import 'package:buddhadham/views/dictionary.dart';
// import 'package:buddhadham/views/logList.dart';
// import 'package:buddhadham/views/screenForRead.dart';
// import 'package:buddhadham/views/searchScreen.dart';
// import 'package:buddhadham/views/about.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);
//   MaterialColor primary_color = AppColors().primarAppColor;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Buddhadham',
//       theme: ThemeData(
//         primarySwatch: primary_color,
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatelessWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MainWidget()),
//       );
//     });

//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Image.asset(
//           'assets/images/cover.jpg',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }

// class MainWidget extends StatefulWidget {
//   const MainWidget({Key? key}) : super(key: key);

//   @override
//   State<MainWidget> createState() => _MainWidgetState();
// }

// class _MainWidgetState extends State<MainWidget> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {

//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Center(child: Text('พุทธรรม(ภาษาไทย)')),
//       //   automaticallyImplyLeading: false,
//       // ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: [
//           ReadScreen(
//             initialPage: 1,
//           ),
//           SearchScreen(),
//           LogListScreen(),
//           DictionaryScreen(),
//           AboutScreen(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.book),
//             label: 'อ่าน',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'ค้นหา',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'รายการโปรด',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'พจนานุกรม',
//           ),
//           BottomNavigationBarItem(
//             // Added new BottomNavigationBarItem for About page
//             icon: Icon(Icons.info),
//             label: 'เกี่ยวกับ',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

//--------------------------------------------------------------------------

import 'package:buddhadham/utils/appcolors.dart';
import 'package:buddhadham/views/dictionary.dart';
import 'package:buddhadham/views/logList.dart';
import 'package:buddhadham/views/screenForRead.dart';
import 'package:buddhadham/views/searchScreen.dart';
import 'package:buddhadham/views/about.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  MaterialColor primary_color = AppColors().primarAppColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buddhadham',
      theme: ThemeData(
        primarySwatch: primary_color,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainWidget()),
      );
    });

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          'assets/images/cover.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    ReadScreen(
      initialPage: 1,
    ), // Replace with your desired widget for the Home screen
    SearchScreen(),
    // LogListScreen(),
    AboutScreen(), // Replace with your desired widget for the Settings screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(child: Text('พุทธรรม(ภาษาไทย)')),
      //   automaticallyImplyLeading: false,
      // ),
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GoogleFonts.sarabun(),
        unselectedLabelStyle: GoogleFonts.sarabun(),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.book),
            label: 'อ่าน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'ค้นหา',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.star),
          //   label: 'รายการบันทึก',
          // ),
          BottomNavigationBarItem(
            // Added new BottomNavigationBarItem for About page
            icon: Icon(Icons.info),
            label: 'เกี่ยวกับ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors().textColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        backgroundColor: AppColors().primaryColor,
      ),
    );
  }
}
