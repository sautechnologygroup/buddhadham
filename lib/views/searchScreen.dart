import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('ค้นหา'))),
    );
  }
}







// Widget searchPage() {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 16,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.8,
//         child: Column(
//           children: [
//             Center(
//               child: TextField(
//                 controller: searchTextController,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.search),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       searchTextController.clear();
//                     },
//                   ),
//                   hintText: 'Search...',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

