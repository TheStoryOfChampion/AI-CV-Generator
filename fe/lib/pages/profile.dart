import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(42),
      child:
        Expanded(
          child:
            Row(
              children: [
                Expanded(
                  child: 
                    Column(

                    ),
                ),
                Expanded(
                  child: 
                    Column(
                      children: [
                        PersonalDetails(),
                        Education(),
                      ],
                    ),
                ),
              ],
            )
        )
      );
  }
}

class PersonalDetails extends StatefulWidget {
  @override
  PersonalDetailsState createState() => PersonalDetailsState();
}

class PersonalDetailsState extends State<PersonalDetails> {
  String name = "default";
  String location = "default";
  String email = "default";
  String phoneNumber = "default";
  TextAlign textAlign = TextAlign.right;
  

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: 
        Align(
          alignment: Alignment.centerRight,
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(name, textAlign: textAlign, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),),
                Text(location, textAlign: textAlign,),
                Text(email, textAlign: textAlign,),
                Text(phoneNumber, textAlign: textAlign,),
              ]
            ),
        )
    );
  }
}

class Education extends StatefulWidget {
  @override
  EducationState createState() => EducationState();
}

class EducationState extends State<Education> {
  String institution = "default";
  String degree = "default";
  TextAlign textAlign = TextAlign.right;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
        Align(
          alignment: Alignment.centerRight,
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(institution, textAlign: textAlign, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),
                Text(degree, textAlign: textAlign,),
                Text(degree, textAlign: textAlign,),
              ],
            ),
        ),
    );
  }
}