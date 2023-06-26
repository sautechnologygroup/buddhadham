import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/models/section.dart';
import 'package:buddhadham/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ReadScreen extends StatefulWidget {
  final int initialPage;
  const ReadScreen({Key? key, required this.initialPage}) : super(key: key);

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
  PageController _pageController = PageController(viewportFraction: 1);
  final TextEditingController _controllerTextField = TextEditingController();

  @override
  void initState() {
    getDataTextListFuture = getData()!;
    _pageController = PageController(initialPage: widget.initialPage - 1);
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
                  style: GoogleFonts.sarabun(
                      fontSize: 20,
                      color: AppColors().readtextColor,
                      fontWeight: FontWeight.bold),
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
                      thaiNumDigit(
                          AppTextSetting.APP_FONTSIZE_READ.toInt().toString()),
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
                child: Column(
                  children: [
                    Text(
                      'หน้าที่ ${thaiNumDigit(AppTextSetting.INDEX_PAGE.toInt().toString())}',
                      style: GoogleFonts.sarabun(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   '(${thaiNumDigit(AppTextSetting.INDEX_PAGE.toStringAsFixed(0))})',
                    //   style: GoogleFonts.charmonman(
                    //     fontSize: 20,
                    //   ),
                    // ),
                  ],
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
                min: 1.0,
                max: 1300,
                // label: AppTextSetting.INDEX_PAGE.toInt().toString(),
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
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          controller: _controllerTextField,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'ไปหน้าที่',
                          ),
                          onSubmitted: (String value) {
                            setState(() {
                              int? pageNumber = int.tryParse(value);
                              if (pageNumber != null && pageNumber >= 1) {
                                AppTextSetting.INDEX_PAGE = pageNumber - 1;
                                _pageController.jumpToPage(
                                    AppTextSetting.INDEX_PAGE.toInt());
                                _controllerTextField.clear();
                                Navigator.pop(context);
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
                          duration: const Duration(milliseconds: 300),
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
      backgroundColor: AppColors().backgroundColor,
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors().primaryColor),
              margin: EdgeInsets.zero,
              //padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.width * 0.18,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Column(
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
                              '(ฉบับปรับขยาย)',
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '~ สารบัญ ~',
                        style: GoogleFonts.charmonman(
                          fontSize: 20,
                          color: AppColors().textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: AppColors().backgroundColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    //-------------------- ความนำ --------------------
                    ListTile(
                      title: Text(
                        'ความนำ', //thaiNumDigit((index + 1).toString())
                        style: GoogleFonts.sarabun(
                          fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                          color: AppColors().primaryColor,
                          fontWeight:
                              FontWeight.bold, // Default color for other pages
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex = 0; // Update the current page index
                        });
                        _pageController.jumpToPage(0);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๑ มัชเฌนธรรมเทศนา --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๑ มัชเฌนธรรมเทศนา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑ ขันธ์ ๕ --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑ ขันธ์ ๕ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒ อายตนะ ๖  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒ อายตนะ ๖ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๓ ไตรลักษณ์  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๓ ไตรลักษณ์', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๔ ปฏิจจสมุปบาท  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๔ ปฏิจจสมุปบาท', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๕ กรรม  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๕ กรรม', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๖ วิชชา วิมุตติ วิสุทธิ สันติ นิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๖ วิชชา วิมุตติ วิสุทธิ สันติ นิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๗ ประเภทและระดับ แห่งนิพพานและผู้บรรลุนิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๗ ประเภทและระดับ แห่งนิพพานและผู้บรรลุนิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๘ ข้อควรทราบเพิ่มเติม เพื่อเสริมความเข้าใจ  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๘ ข้อควรทราบเพิ่มเติม เพื่อเสริมความเข้าใจ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๙ หลักการสำคัญ ของการบรรลุนิพพาน   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๙ หลักการสำคัญ ของการบรรลุนิพพาน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๐ บทสรุป เรื่องเกี่ยวกับนิพพาน  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๐ บทสรุป เรื่องเกี่ยวกับนิพพาน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๒ มัชฌิมาปฏิปทา  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๒ มัชฌิมาปฏิปทา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๑ บทนำ ของมัชฌิมาปฏิปทา   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๑ บทนำ ของมัชฌิมาปฏิปทา ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๒ บุพภาคของการศึกษา ๑: ปรโตโฆสะที่ดี = กัลยาณมิตร    --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๒ บุพภาคของการศึกษา ๑: ปรโตโฆสะที่ดี = กัลยาณมิตร  ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๓ บุพภาคของการศึกษา ๒: โยนิโสมนสิการ     --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๓ บุพภาคของการศึกษา ๒: โยนิโสมนสิการ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ๑๔ องค์ประกอบของมัชฌิมาปฏิปทา ๑: หมวดปัญญา      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๔ องค์ประกอบของมัชฌิมาปฏิปทา ๑: หมวดปัญญา', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๕ องค์ประกอบของมัชฌิมาปฏิปทา ๒: หมวดศีล      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๕ องค์ประกอบของมัชฌิมาปฏิปทา ๒: หมวดศีล', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๖ องค์ประกอบของมัชฌิมาปฏิปทา ๓: หมวดสมาธิ      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๖ องค์ประกอบของมัชฌิมาปฏิปทา ๓: หมวดสมาธิ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๗ บทสรุป: อริยสัจ ๔      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '    บทที่ ๑๗ บทสรุป: อริยสัจ ๔ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- ภาค ๓ อารยธรรมวิถี      --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'ภาค ๓ อารยธรรมวิถี ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๘ บทความประกอบที่ ๑:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๘ บทความประกอบที่ ๑: ชีวิตและคุณธรรมพื้นฐานของอารยชน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๑๙ บทความประกอบที่ ๒:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๑๙ บทความประกอบที่ ๒: ศีลกับเจตนารมณ์ทางสังคม ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๐ บทความประกอบที่ ๓:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๐ บทความประกอบที่ ๓: เรื่องเหนือสามัญวิสัย: ปาฏิหาริย์ – เทวดา ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๑ บทความประกอบที่ ๔:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๑ บทความประกอบที่ ๔: ปัญหาเกี่ยวกับแรงจูงใจ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๒ บทความประกอบที่ ๕:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๒ บทความประกอบที่ ๕: ความสุข ๑: ฉบับแบบแผน ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บทที่ ๒๓ บทความประกอบที่ ๖:   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '     บทที่ ๒๓ บทความประกอบที่ ๖: ความสุข ๒: ฉบับประมวลความ ', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บรรณาณุกรม   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บรรณาณุกรม', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกของผู้เขียน   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกของผู้เขียน', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกการจัดทำข้อมูล   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกการจัดทำข้อมูล', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกไว้ระลึก   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกไว้ระลึก', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึก (เรื่องทุนพิมพ์)   --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึก (เรื่องทุนพิมพ์)', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 5,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //-------------------- บันทึกการจัดทำฉบับดิจิทัล  --------------------
                    ListTile(
                      //tileColor: Color.fromARGB(37, 208, 185, 52),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'บันทึกการจัดทำฉบับดิจิทัล', //thaiNumDigit((index + 1).toString())
                          style: GoogleFonts.sarabun(
                            fontSize: AppTextSetting.APP_FONTSIZE_READ + 2,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight
                                .bold, // Default color for other pages
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          currentPageIndex =
                              10; // Update the current page index
                        });
                        _pageController.jumpToPage(10);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
            )
            /*
                  Expanded(
                    child: Container(
                      color: AppColors().backgroundColor,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ...snapshot.data!.asMap().entries.map((entry) {
                            int index = entry.key;
                            String pageContent = entry.value;
                            //String info = parse(pageContent).body?.text ?? '';
                            // List<String> lines = info.split('\n');
                            // String cleanInfo = lines
                            //     .take(1)
                            //     .map((line) => line.length < 99
                            //         ? line
                            //         : line.replaceRange(99, line.length, '...'))
                            //     .join('\n');
                            return Column(
                              children: [
                                ListTile(
                                  //tileColor: Color.fromARGB(37, 208, 185, 52),
                                  title: Text(
                                    'หน้า ${thaiNumDigit((index + 1).toString())}', //thaiNumDigit((index + 1).toString())
                                    style: GoogleFonts.charmonman(
                                      fontSize: 20,
                                      color: AppColors().primaryColor,
                                      fontWeight: index == currentPageIndex
                                          ? FontWeight.bold
                                          : FontWeight
                                              .normal, // Default color for other pages
                                    ),
                                  ),
                                  subtitle: pageContent.length <= 50
                                      ? Text('${pageContent}...')
                                      : Text(
                                          '${pageContent.substring(0, 50)}...'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      currentPageIndex =
                                          index; // Update the current page index
                                    });
                                    _pageController.jumpToPage(index);
                                  },
                                ),
                                Divider(
                                  color: AppColors().primarAppColor,
                                  height: 20,
                                  thickness: 1,
                                  indent: 15,
                                  endIndent: 15,
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  )
                  */
          ],
        ),
      ),
      endDrawer: expandTextFont(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors().textColor),
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
        // title: Center(
        //   child: Column(
        //     children: [
        //       Align(
        //         alignment: Alignment.topCenter,
        //         child: Text(
        //           'พุทธธรรม',
        //           style: GoogleFonts.charmonman(
        //             textStyle: TextStyle(
        //               fontSize: 25,
        //               fontWeight: FontWeight.bold,
        //               color: AppColors().textColor,
        //             ),
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //       Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Text(
        //           'ฉบับปรับขยาย',
        //           style: GoogleFonts.charmonman(
        //             textStyle: TextStyle(
        //               fontSize: 20,
        //               color: AppColors().textColor,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.035,
            ),
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState!.openEndDrawer(),
              child: Icon(
                FontAwesomeIcons.bookOpen,
                // size: 35,
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
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.025,
                                  right:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'หน้า ' +
                                        thaiNumDigit((index + 1).toString()),
                                    // style: TextStyle(
                                    //   fontSize: AppTextSetting.APP_FONTSIZE_READ,
                                    //   color: AppColors().readtextColor,
                                    // ),
                                    style: GoogleFonts.sarabun(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          AppTextSetting.APP_FONTSIZE_READ + 2,
                                      color: AppColors().readtextColor,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey[400],
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
              },
            );
          }
        },
      ),
    );
  }
}
