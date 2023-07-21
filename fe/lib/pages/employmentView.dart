import 'package:ai_cv_generator/dio/client/userApi.dart';
import 'package:flutter/material.dart';
import 'package:ai_cv_generator/models/user/Employment.dart';
import 'elements/elements.dart';

class EmploymentSection extends StatefulWidget {
  List<Employment> employment;
  EmploymentSection({super.key, required this.employment});

  @override
  EmploymentSectionState createState() => EmploymentSectionState();
}

class EmploymentSectionState extends State<EmploymentSection> {
  final blankEmployment = Employment(title: '', company: '', startdate: DateTime.now(), empid: 0, enddate: DateTime.now());
  Map employmentMap = {};
  bool editing = false;

  @override
  void initState() {
    print(widget.employment.length);
    widget.employment.forEach((element) {
      display(element);
     }
    );
    super.initState();
  }

  void display(Employment info) {
    TextEditingController titleC = TextEditingController();
    TextEditingController companyC = TextEditingController();
    TextEditingController dateC = TextEditingController();

    titleC.text = info.title != null ? info.title : '';
    companyC.text = info.company != null ? info.company : '';
    dateC.text = dateTimeToString(info.startdate, info.enddate);

    employmentMap[info.empid] = {
      'empid': info.empid,
      'title': titleC,
      'company': companyC,
      'date': dateC,
    };
    employmentMap[info.empid]['widget'] = (
      Column(
        children: [
          SizedBox(height: 4,),
          EmploymentField(
            titleC: employmentMap[info.empid]['title'],
            companyC: employmentMap[info.empid]['company'],
            dateC: employmentMap[info.empid]['date'],
            ),
          SizedBox(height: 4,),
        ],
      )
    );
  }

  void add() {
    userApi.addEmployment(employment: blankEmployment).then((value) {
      Employment newEmployment = getCorrect(value!)!;
      print(newEmployment.empid);
      display(newEmployment);
      setState(() {});
    });
  }

  void remove(int objectId) async {
    Employment? oldEmployment = getEmployment(objectId);
    if(oldEmployment == null) {
      return;
    }
    userApi.RemoveEmployment(employment: oldEmployment);
    employmentMap.remove(objectId);
    setState(() {});
  }

  void update() async {
    employmentMap.forEach((key, value) {
    Employment? updatedEmployment = getEmployment(key);
      if(updatedEmployment != null) {
        userApi.UpdateEmployment(employment: updatedEmployment);
      }
    });
  }

  Employment? getEmployment(int objectId) {
    if(employmentMap.containsKey(objectId) == false) {
      return null;
    }
    DateTimeRange dateTimeRange = stringToDateTimeRange(employmentMap[objectId]['date'].text);

    Employment newEmployment = Employment(
      title: employmentMap[objectId]['title'].text,
      company: employmentMap[objectId]['company'].text,
      empid: employmentMap[objectId]['empid'],
      startdate: dateTimeRange.start,
      enddate: dateTimeRange.end,
    );
    return newEmployment;
  }

  Employment? getCorrect(List<Employment> list) {
    for(var i = 0; i <= list.length-1; i++) {
      if(employmentMap.containsKey(list[i].empid) == false) {
        return list[i];
      }
    }
    return null;
  }

  List<Widget> populate() {
    List<Widget> linkWidgets = [];
    employmentMap.forEach((key, value) {
      linkWidgets.add(employmentMap[key]['widget']);
      if(editing == true) {
        linkWidgets.add(
          Align(
            alignment: Alignment.topRight,
            child: OutlinedButton(
              onPressed: () {
                remove(key);
              }, 
              child: Text('-'),),
          )
        );
        linkWidgets.add(SizedBox(height: 4,),);
      }
    });
    return linkWidgets;
  }

  edit() {
    setState(() {
      editing = !editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          SectionHeadingBar(
            children: [
              SectionHeading(text: "WORK EXPERIENCE",),
            ],
            actions: [
              IconButton(onPressed: () {
                if(editing == false) {
                  add();
                }
              }, icon: Icon(Icons.add)),
              IconButton(onPressed: () {
                  edit();
              }, icon: Icon(Icons.edit)),
            ],
          ),
          SizedBox(height: 16,),
          ...populate(),
        ]
      )
    );
  }
}

class EmploymentField extends StatefulWidget {
  TextEditingController titleC;
  TextEditingController companyC;
  TextEditingController dateC;
  EmploymentField({required this.titleC, required this.companyC, required this.dateC});

  @override
  EmploymentFieldState createState() => EmploymentFieldState();
}

class EmploymentFieldState extends State<EmploymentField> {
  TextEditingController displayDateC = TextEditingController();
  @override
void initState() {
  displayDateC.text = displayDateTimeRange(stringToDateTimeRange(widget.dateC.text));
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
          controller: widget.companyC,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Company",
            border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: TextFormField(
          controller: widget.titleC,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Position Held",
            border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8,),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                datePicker(context).then((value) {
                  if(value != null) {
                    widget.dateC.text = dateTimeToString(value.start, value.end);
                    displayDateC.text = displayDateTimeRange(value);
                  }
                });
              });
            },
            child: TextFormField(
              enabled: false,
              controller: displayDateC,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Date",
                border: OutlineInputBorder(),
                ),
              ),
          ),
        ),
      ],
    );
  }
}

String dateTimeToString(DateTime start, DateTime end) {
  return start.toString() + "/" + end.toString();
}

DateTimeRange stringToDateTimeRange(String text) {
  List<String> dates = text.split('/');
  return DateTimeRange(start: DateTime.parse(dates[0]), end: DateTime.parse(dates[1]));
}

String displayDateTimeRange(DateTimeRange dateTimeRange) {
  return dateTimeRange.start.year.toString() + " - " + dateTimeRange.end.year.toString();
}

Future<DateTimeRange?> datePicker(BuildContext context) async {
  return showDateRangePicker(
      context: context, 
      firstDate: DateTime.now().subtract(const Duration(days:365*100)),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.input,
    );
}

