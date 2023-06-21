import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/widgets/expandFont.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final searchText = TextEditingController();
  late Future<List<String>> getDataTextListFuture;
  double numAllPage = 2;
  final PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getDataTextListFuture = getData()!;
    super.initState();
  }

  @override
  void dispose() {
    _controllerTextField.dispose();
    super.dispose();
  }

  String thaiNumDigit(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const thai = ['๐', '๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], thai[i]);
    }

    return input;
  }

  // List<Widget> getTextWidget(List<String> data) {
  //   List<Widget> txtWidget = [];
  //   int i;
  //   for (i = 0; i < data.length; i++) {
  //     txtWidget.add(
  //       Container(
  //         width: MediaQuery.of(context).size.width,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.only(
  //                   left: 10, right: 10, bottom: 10, top: 5),
  //               child: Wrap(
  //                 children: [
  //                   Align(
  //                     alignment: Alignment.topRight,
  //                     child: Text('หน้า ' + thaiNumDigit((i + 1).toString())),
  //                   ),
  //                   Text(
  //                     data[i],
  //                     style: TextStyle(
  //                       fontSize: AppTextSetting.APP_FONTSIZE_READ,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return txtWidget;
  // }

  Future<List<String>>? getData() async {
    List<String>? listData = await Section.listAllText;
    setState(() {
      numAllPage = listData.length.toDouble();
    });
    return listData;
  }

  Widget expandTextFont() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'ขนาดตัวอักษร',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Slider(
                value: AppTextSetting.APP_FONTSIZE_READ,
                onChanged: (double newValue) {
                  setState(() {
                    AppTextSetting.APP_FONTSIZE_READ = newValue;
                  });
                },
                divisions: 90,
                min: 10.0,
                max: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text(
                        'ลด',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          AppTextSetting.APP_FONTSIZE_READ -= 1;
                        });
                      },
                    ),
                    Wrap(
                      children: [
                        Text(
                            AppTextSetting.APP_FONTSIZE_READ.toInt().toString())
                      ],
                    ),
                    ElevatedButton(
                      child: const Text('เพิ่ม'),
                      onPressed: () {
                        setState(() {
                          AppTextSetting.APP_FONTSIZE_READ += 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  'หน้า',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Slider(
                value: AppTextSetting.INDEX_PAGE,
                onChanged: (double newValue) {
                  setState(() {
                    AppTextSetting.INDEX_PAGE = newValue;
                    _pageController
                        .jumpToPage(AppTextSetting.INDEX_PAGE.toInt());
                  });
                },
                divisions: (numAllPage - 1).toInt(),
                min: 1,
                max: numAllPage,
              ),
              Wrap(
                children: [Text(AppTextSetting.INDEX_PAGE.toInt().toString())],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        _pageController.previousPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut);
                        // setState(() {
                        //   AppTextSetting.INDEX_PAGE -= 1;
                        // });
                      },
                    ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 20, right: 20),
                    //     child: TextField(
                    //       keyboardType:
                    //           TextInputType.numberWithOptions(decimal: true),
                    //       controller: _controllerTextField,
                    //       // onSubmitted: (String value){
                    //       //   setState(() {
                    //       //     AppTextSetting.INDEX_PAGE = double.parse(value);
                    //       //     _pageController.jumpToPage(AppTextSetting.INDEX_PAGE.toInt());
                    //       //   });
                    //       // },
                    //     ),
                    //   ),
                    // ),

                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 20, right: 20),
                    //     child: TextField(
                    //       keyboardType:
                    //           TextInputType.numberWithOptions(decimal: true),
                    //       controller: _controllerTextField,
                    //       onSubmitted: (String value) {
                    //         setState(() {
                    //           AppTextSetting.INDEX_PAGE = double.parse(value);
                    //           _pageController.jumpToPage(
                    //               AppTextSetting.INDEX_PAGE.toInt());
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: _controllerTextField,
                          onSubmitted: (String value) {
                            setState(() {
                              int pageNumber = int.parse(value);
                              if (pageNumber >= 1) {
                                AppTextSetting.INDEX_PAGE = pageNumber - 1;
                                _pageController.jumpToPage(
                                    AppTextSetting.INDEX_PAGE.toInt());
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    // Wrap(
                    //   children: [
                    //     Text(AppTextSetting.INDEX_PAGE.toInt().toString())
                    //   ],
                    // ),
                    ElevatedButton(
                      child: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        _pageController.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut);
                        // setState(() {
                        //   AppTextSetting.INDEX_PAGE += 1;
                        // });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchPage() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Center(
              child: TextField(
                controller: searchText,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchText.clear();
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: const BurgerWidget(),
      drawer: expandTextFont(),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: const Icon(
            Icons.zoom_in,
            size: 35,
          ),
        ),
        title: const Center(
          child: Text('อ่าน'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return searchPage();
                  });
            },
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
          )
          // IconButton(
          //   icon: const Icon(Icons.save),
          //   onPressed: () {
          //     ScaffoldMessenger.of(context)
          //         .showSnackBar(const SnackBar(content: Text('Save...')));
          //   },
          // ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        // future: getData(),
        future: getDataTextListFuture,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return PageView.builder(
              itemCount: snapshot.data!.length,
              // controller: PageController(viewportFraction: 1),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  AppTextSetting.INDEX_PAGE = index.toDouble() + 1;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 5),
                        child: Wrap(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'หน้า ' + thaiNumDigit((index + 1).toString()),
                                style: TextStyle(
                                  fontSize: AppTextSetting.APP_FONTSIZE_READ,
                                ),
                              ),
                            ),
                            Text(
                              snapshot.data![index],
                              style: TextStyle(
                                fontSize: AppTextSetting.APP_FONTSIZE_READ,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
