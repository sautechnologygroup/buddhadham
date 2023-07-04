import 'package:buddhadham/models/appTextSetting.dart';
import 'package:buddhadham/utils/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.06,
                ),
                Image.asset(
                  'assets/images/cover2.png',
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
                Text(
                  'พุทธธรรม',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ + 20
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET + 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '(ฉบับปรับขยาย)',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ + 2
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '~ ※ ~',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ + 2
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'สมเด็จพระพุทธโฆษาจารย์',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ + 2
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'ป. อ. ปยุตฺโต',
                  style: GoogleFonts.prompt(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ + 2
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET + 2,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  'จดหมายได้รับการอนุญาตในการพัฒนาแอปพลิเคชัน\nพุทธธรรมฉบับดิจิตอล\nจากพระเดชพระคุณหลวงพ่อ\nสมเด็จพระพุทธโฆษาจารย์ พระพรหมคุณากรณ์\n(ป. อ. ปยุตฺโต)\n\nสนับสนุนการจัดทำโดย\nมหาวิทยาลัยเอเชียอาคเนย์',
                  style: GoogleFonts.sarabun(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(
                    height: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchInBrowser(Uri.parse('http://www.sau.ac.th'));
                  },
                  child: Text(
                    'www.sau.ac.th',
                    style: GoogleFonts.sarabun(
                      textStyle: TextStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  '\nคุณเสริมสิน สมะลาภา\nนายกสภามหาวิทยาลัยเอเชียอาคเนย์\n\nคุณฉันทวุฒิ พีชผล\nอธิการบดีมหาวิทยาลัยเอเชียอาคเนย์\n\nคุณปิยพงศ์ เผ่าวณิช \nกรรมการสภามหาวิทยาลัยเอเชียอาคเนย์\n\nคุณเลิศพนธ์ อัจฉรานันท์\nผู้ช่วยอธิการบดีมหาวิทยาลัยเอเชียอาคเนย์\n\nคณะกรรมการทำนุบำรุงศาสนา\nมหาวิทยาลัยเอเชียอาคเนย์\n\nทีมงานพัฒนา\nคณาจารย์ และนักศึกษา\nสาขาวิชาเทคโนโลยีดิจิทัลและนวัตกรรม\nมหาวิทยาลัยเอเชียอาคเนย์\n\nสามารถดาวน์โหลดหนังสือธรรมะอื่นๆ\nและพุทธธรรมฉบับดิจิตอลได้ที่',
                  style: GoogleFonts.sarabun(
                    textStyle: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(
                    height: 2,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _launchInBrowser(Uri.parse('http://dhamma.sau.ac.th'));
                  },
                  child: Text(
                    'dhamma.sau.ac.th',
                    style: GoogleFonts.sarabun(
                      textStyle: TextStyle(
                        fontSize: SizerUtil.deviceType == DeviceType.mobile
                      ? AppTextSetting.APP_FONTSIZE_READ
                      : AppTextSetting.APP_FONTSIZE_READ_TABLET,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
