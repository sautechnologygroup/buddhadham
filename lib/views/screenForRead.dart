import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController searchTextController = TextEditingController();
  late Future<List<String>> getDataTextListFuture;
  double numAllPage = 2;
  final PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  @override
  void initState() {
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

  Future<List<String>>? getData() async {
    try {
      List<String>? listData = await Section.listAllText;
      setState(() {
        numAllPage = listData.length.toDouble();
      });
      return listData;
    } catch (e) {
      // Handle the exception or display an error message
      return [];
    }
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
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
                label: AppTextSetting.APP_FONTSIZE_READ.toInt().toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          AppTextSetting.APP_FONTSIZE_READ -= 1;
                        });
                      },
                    ),
                    Text(
                      AppTextSetting.APP_FONTSIZE_READ.toInt().toString(),
                      style:
                          TextStyle(fontSize: 18, color: AppColors().textColor),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          AppTextSetting.APP_FONTSIZE_READ += 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: const Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
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
                label: AppTextSetting.INDEX_PAGE.toInt().toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: _controllerTextField,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'หน้าที่ ${AppTextSetting.INDEX_PAGE.toInt()}',
                          ),
                          onSubmitted: (String value) {
                            setState(() {
                              int? pageNumber = int.tryParse(value);
                              if (pageNumber != null && pageNumber >= 1) {
                                AppTextSetting.INDEX_PAGE = pageNumber - 1;
                                _pageController.jumpToPage(
                                    AppTextSetting.INDEX_PAGE.toInt());
                              } else {
                                // Handle invalid input, such as displaying an error message.
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: FutureBuilder<List<String>>(
        future: getDataTextListFuture,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Drawer(
              elevation: 20.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 110,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.orange),
                      child: Text('สารบัญ',
                          style: GoogleFonts.charmonman(
                            fontSize: 30,
                          )),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ...snapshot.data!.asMap().entries.map((entry) {
                          int index = entry.key;
                          String pageContent = entry.value;
                          String info = parse(pageContent).body?.text ?? '';
                          List<String> lines = info.split('\n');
                          String cleanInfo = lines
                              .take(1)
                              .map((line) => line.length < 100
                                  ? line
                                  : line.replaceRange(100, line.length, '...'))
                              .join('\n');
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'หน้า ${index + 1}',
                                  style: GoogleFonts.charmonman(
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(cleanInfo),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pageController.jumpToPage(index);
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
                        }).toList(),
                      ],
                    ),
                  )
                ],
              ),
            );

            // return Drawer(
            //   child: ListView(
            //     padding: const EdgeInsets.all(0.0),
            //     children: <Widget>[
            //       SizedBox(
            //         height: 110,
            //         child: DrawerHeader(
            //           child: Text(
            //             'สารบัญ',
            //             style: GoogleFonts.charmonman(
            //               fontSize: 30,
            //             ),
            //           ),
            //           decoration: BoxDecoration(
            //             color: AppColors().primarAppColor,
            //           ),
            //         ),
            //       ),
            //       ...snapshot.data!.asMap().entries.map((entry) {
            //         int index = entry.key;
            //         String pageContent = entry.value;
            //         List<String> lines = pageContent.split('\n');
            //         String info = lines
            //             .take(1)
            //             .map((line) => line.length < 100
            //                 ? line
            //                 : line.replaceRange(100, line.length, '...'))
            //             .join('\n');
            //         return Column(
            //           children: [
            //             ListTile(
            //               title: Text(
            //                 'หน้า ${index + 1}',
            //                 style: GoogleFonts.charmonman(
            //                   fontSize: 20,
            //                 ),
            //               ),
            //               subtitle: Text(info),
            //               onTap: () {
            //                 Navigator.pop(context);
            //                 _pageController.jumpToPage(index);
            //               },
            //             ),
            //             const Divider(
            //               color: Colors.black,
            //               height: 20,
            //               thickness: 1,
            //               indent: 20,
            //               endIndent: 20,
            //             ),
            //           ],
            //         );
            //       }).toList(),
            //     ],
            //   ),
            // );
          }
        },
      ),
      endDrawer: expandTextFont(),
      appBar: AppBar(
        toolbarHeight: 75,
        title: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'พุทธธรรม',
                  style: GoogleFonts.charmonman(
                    textStyle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors().textColor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'ฉบับปรับปรุงใหม่',
                  style: GoogleFonts.charmonman(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors().textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.035,
            ),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: Icon(
                FontAwesomeIcons.cog,
                // size: 35,
                color: AppColors().iconColor,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: getDataTextListFuture,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return PageView.builder(
              itemCount: snapshot.data!.length,
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
                    padding: const EdgeInsets.all(1),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          top: 5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Wrap(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'หน้า ' +
                                      thaiNumDigit((index + 1).toString()),
                                  // style: TextStyle(
                                  //   fontSize: AppTextSetting.APP_FONTSIZE_READ,
                                  //   color: AppColors().readtextColor,
                                  // ),
                                  style: GoogleFonts.charmonman(
                                    fontSize:
                                        AppTextSetting.APP_FONTSIZE_READ + 5,
                                    color: AppColors().readtextColor,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                height: 20,
                                thickness: 1,
                                indent:
                                    MediaQuery.of(context).size.width * 0.025,
                                endIndent:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.025,
                                  right:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: HtmlWidget(
                                  snapshot.data![index],
                                  textStyle: TextStyle(
                                    fontSize: AppTextSetting.APP_FONTSIZE_READ,
                                    color: AppColors().readtextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchTextController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
