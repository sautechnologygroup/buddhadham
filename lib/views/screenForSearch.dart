import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/utils/appcolors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadScreenForSearch extends StatefulWidget {
  final int initialPage;
  final String searchText;
  const ReadScreenForSearch({Key? key, required this.initialPage, required this.searchText}) : super(key: key);

  @override
  State<ReadScreenForSearch> createState() => _ReadScreenForSearchState();
}

class _ReadScreenForSearchState extends State<ReadScreenForSearch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController searchTextController = TextEditingController();
  late Future<List<String>> getDataTextListFuture;
  double numAllPage = 2;
  // PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  @override
  void initState() {
    getDataTextListFuture = getData()!;
    // _pageController = PageController(initialPage: widget.initialPage - 1);
    AppTextSetting.INDEX_PAGE = widget.initialPage.toDouble();
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

  // This function retrieves the list of all text sections
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

  int currentPageIndex = 0; // Add a variable to track the current page index

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
                  style: GoogleFonts.sarabun(fontSize: 20, color: AppColors().readtextColor, fontWeight: FontWeight.bold),
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
                max: MediaQuery.of(context).textScaleFactor * 100.0,
                // label: AppTextSetting.APP_FONTSIZE_READ.toInt().toString(),
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
                          if (AppTextSetting.APP_FONTSIZE_READ == 10) {
                            AppTextSetting.APP_FONTSIZE_READ = 10;
                          } else {
                            AppTextSetting.APP_FONTSIZE_READ -= 1;
                          }
                        });
                      },
                    ),
                    Text(
                      thaiNumDigit(AppTextSetting.APP_FONTSIZE_READ.toInt().toString()),
                      style: GoogleFonts.sarabun(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: AppColors().readtextColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (AppTextSetting.APP_FONTSIZE_READ == 100) {
                            AppTextSetting.APP_FONTSIZE_READ = 100;
                          } else {
                            AppTextSetting.APP_FONTSIZE_READ += 1;
                          }
                        });
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
      backgroundColor: AppColors().backgroundColor,
      key: _scaffoldKey,
      endDrawer: expandTextFont(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors().textColor,
          ),
        ),
        toolbarHeight: 75,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'พุทธธรรม',
                style: GoogleFonts.charmonman(
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColors().textColor,
                  ),
                ),
              ),
              TextSpan(
                text: ' (ฉบับปรับขยาย)',
                style: GoogleFonts.charmonman(
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: AppColors().textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.035,
            ),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: Icon(
                FontAwesomeIcons.bookOpen,
                color: AppColors().textColor,
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
            snapshot.data![widget.initialPage - 1] = snapshot.data![widget.initialPage - 1].replaceAll('<mark>', '');
            snapshot.data![widget.initialPage - 1] = snapshot.data![widget.initialPage - 1].replaceAll('</mark>', '');
            snapshot.data![widget.initialPage - 1] = snapshot.data![widget.initialPage - 1].replaceAll(widget.searchText, '<mark>${widget.searchText}</mark>');
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
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.025,
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'หน้า ' + thaiNumDigit((widget.initialPage).toString()),
                                style: GoogleFonts.sarabun(
                                  fontWeight: FontWeight.w500,
                                  fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                                  color: AppColors().readtextColor,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            height: 20,
                            thickness: 1,
                            indent: MediaQuery.of(context).size.width * 0.025,
                            endIndent: MediaQuery.of(context).size.width * 0.025,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.025,
                              right: MediaQuery.of(context).size.width * 0.025,
                            ),
                            child: HtmlWidget(
                              snapshot.data![widget.initialPage - 1],
                              textStyle: GoogleFonts.sarabun(
                                fontSize: AppTextSetting.APP_FONTSIZE_READ,
                                color: AppColors().readtextColor,
                                height: 1.7,
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
          }
        },
      ),
    );
  }
}
