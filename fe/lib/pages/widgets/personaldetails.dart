// ignore_for_file: must_be_immutable
import 'package:ai_cv_generator/pages/widgets/loadingscreens/loadingScreen.dart';
import 'package:ai_cv_generator/pages/widgets/navdrawer.dart';
import 'package:ai_cv_generator/pages/widgets/qualifications.dart';
import 'package:ai_cv_generator/pages/util/strings.dart';
import 'package:ai_cv_generator/pages/widgets/questionaireModal.dart';
import 'package:flutter/material.dart';
import 'package:ai_cv_generator/pages/screens/home.dart';

class PersonalDetailsForm extends StatefulWidget {
   PersonalDetailsForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PersonalDetailsFormState();
  }
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController cell = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  void initState() {
    getUser().then((value) {
      setState(() {});
    });
    super.initState();
  }

  Future<bool> updateUser() async {
    Home.adjustedModel!.fname = fname.text;
    Home.adjustedModel!.lname = lname.text;
    Home.adjustedModel!.email = email.text;
    Home.adjustedModel!.phoneNumber = cell.text;
    Home.adjustedModel!.location = address.text;
    return _formKey.currentState!.validate();
  }

  Future<void> getUser() async {
    fname.text = Home.adjustedModel!.fname;
    lname.text = Home.adjustedModel!.lname;
    email.text = Home.adjustedModel!.email?? "";
    cell.text = Home.adjustedModel!.phoneNumber?? "";
    address.text = Home.adjustedModel!.location?? "";
  }

  @override
  Widget build(BuildContext context) {
    if(Home.adjustedModel == null) {
      return  LoadingScreen();
    }
    return Scaffold(
      drawer:  NavDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(
            Icons.close,
          ), 
          onPressed: () async { 
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: titleSection,
            ),
            Expanded(
              flex: 4,
              child: Container ( 
                padding:  EdgeInsets.all(16.0),
                child: _buildForm(),
              ),
            ),
            SizedBox(
              height: 50,
                width: 150,
              child: ElevatedButton(
                child:  Text('Save and Proceed'),
                onPressed: () async {
                  if(await updateUser() == false) {
                    return;
                  }
                  showQuestionaireModal(context,  QualificationsDetailsForm());
                },
              ),
            ),
             SizedBox(height: 64,),
          ],
        ),
      ),
    );
  }

  Widget titleSection= Column (
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget> [
        Padding (
          padding: EdgeInsets.all(8.0),
            child: Text (
              StringsPersonal.appsubHeadingTitle,
              style: TextStyle (
                fontSize: 20.0,
              ),
          ),
        ),
      ],
    );


  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildNameField(),
             SizedBox(height: 8,),
            _buildLastNameField(),
             SizedBox(height: 8,),
            _buildEmailField(),
             SizedBox(height: 8,),
            _buildCellField(),
             SizedBox(height: 8,),
            _buildAddrField(),
          ],
        ));
  }

  Widget _buildNameField() {
    return Container (
      constraints: BoxConstraints.tight( Size(550,70)),
      child: TextFormField(
        key:  Key("Name input"),
        controller: fname,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          labelText: 'First Name',
          enabledBorder: OutlineInputBorder(),
          icon: Icon(Icons.person),
        ),
        // ignore: body_might_complete_normally_nullable
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      )
    );
  }

  Widget _buildLastNameField() {
    return Container (
      constraints: BoxConstraints.tight( Size(550,70)),
      child: TextFormField(
        key:  Key("Last Name input"),
        controller: lname,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          labelText: 'Last Name',
          enabledBorder: OutlineInputBorder(),
          icon: Icon(Icons.person),
        ),
        // ignore: body_might_complete_normally_nullable
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      )
    );
  }

  Widget _buildEmailField() {
    return Container (
      constraints: BoxConstraints.tight( Size(550,70)),
      child: TextFormField(
        key:  Key("Email input"),
        controller: email,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          labelText: 'Email',
          enabledBorder: OutlineInputBorder(),
          icon: Icon(Icons.email),
        ),
        // ignore: body_might_complete_normally_nullable
        validator: (value) {
          if (!RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value!)) {
            return 'This is not a valid email';
          }
        },
      )
    );
  }

  Widget _buildCellField() {
    return Container (
      constraints: BoxConstraints.tight( Size(550,70)),
      child: TextFormField(
        key:  Key("Cell input"),
        controller: cell,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          labelText: 'Contact Number',
          enabledBorder: OutlineInputBorder(),
          icon: Icon(Icons.phone),
        ),
        // ignore: body_might_complete_normally_nullable
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      )
    );
  }

  Widget _buildAddrField() {
    return Container (
      constraints: BoxConstraints.tight( Size(550,70)),
      child: TextFormField(
        key:  Key("Address input"),
        controller: address,
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.all(5.0),
          labelText: 'General Location',
          enabledBorder: OutlineInputBorder(),
          icon: Icon(Icons.home),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      )
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: 150,
      height: 30,
      child: ElevatedButton(
        onPressed: () {
            _submitForm();
          },
          child:  Text('Save & Proceed'),
      )
    );
    
  }

  void _submitForm() {
    Navigator.pushNamed(context, "/qualificationsdetails");
  }
}