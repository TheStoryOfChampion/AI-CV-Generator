//import 'package:ai_cv_generator/pages/education.dart';
import 'package:ai_cv_generator/pages/strings.dart';
import 'package:flutter/material.dart';

void main () => runApp(Create());



class Create extends StatelessWidget {

  //titleSection widget
    Widget titleSection=Container(
    child:Column (
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget> [
        Padding (
          padding: const EdgeInsets.all(8.0),
            child: Text (
              StringsPersonal.appHeadingTitle,
              style: const TextStyle (
                fontSize: 30.0,
            ),
          ),
        ),
        
        Padding (
          padding: const EdgeInsets.all(8.0),
            child: Text (
              StringsPersonal.appsubHeadingTitle,
              style: const TextStyle (
                fontSize: 20.0,
              ),
          ),
        ),
        
      ],
    ),
  );

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: StringsPersonal.appBarTitle,
        home: Scaffold (
          appBar: AppBar(
            title: Text(StringsPersonal.appBarTitle),
          ),
          body: ListView(
            children: <Widget>[
              titleSection,
              const PersonalDetailsForm(),
            ],
          ),
        ),
      );
  }//MaterialApp
}
