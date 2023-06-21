import 'package:buddhadham/models/appTextSetting.dart';
import 'package:flutter/material.dart';

class ExpandFont extends StatefulWidget {
  const ExpandFont({Key? key}) : super(key: key);

  @override
  State<ExpandFont> createState() => _ExpandFontState();
}

class _ExpandFontState extends State<ExpandFont> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: (){
          },
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
                  divisions: 10,
                  min: 10.0,
                  max: 100.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40),
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
                      Text(AppTextSetting.APP_FONTSIZE_READ.toString()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}