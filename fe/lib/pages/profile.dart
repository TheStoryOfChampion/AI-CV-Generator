import 'package:ai_cv_generator/pages/profile2.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

bool isEditingEnabled = false;

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String imagePath = "";
  String name = "Avery Quinn";
  String email = "averyquinn@hmail.com";
  String phoneNumber = "0823427832";
  String location = "Pretoria, Gauteng";
  String aboutMe = "";
  String education = "";
  String workExperience = "";
  String links = "";

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 42, horizontal: 420),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.blue,
              ),
              SizedBox(height: 16,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10) ,
                child:OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isEditingEnabled = !isEditingEnabled;
                    });
                    _formKey.currentState!.save();
                    print(name);
                    print(links);
                  }, 
                  child: const Text("EDIT")
                ),
              ),
              SizedBox(height: 16,),
              InputField(label: "NAME", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: name, onSaved: (value)=>{name=value!},)),
              SizedBox(height: 16,),
              InputField(label: "EMAIL", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: email, onSaved: (value)=>{email=value!},)),
              SizedBox(height: 16,),
              InputField(label: "PHONE NUMBER", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: phoneNumber, onSaved: (value)=>{phoneNumber=value!},)),
              SizedBox(height: 16,),
              InputField(label: "LOCATION", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: location, onSaved: (value)=>{location=value!},)),
              SizedBox(height: 16,),
              InputField(label: "ABOUT ME", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: aboutMe, onSaved: (value)=>{aboutMe=value!}, maxLines: 10,)),
              SizedBox(height: 16,),
              InputField(label: "EDUCATION", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: education, onSaved: (value)=>{education=value!}, maxLines: 10,)),
              SizedBox(height: 16,),
              InputField(label: "WORK EXPERIENCE", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: workExperience, onSaved: (value)=>{workExperience=value!}, maxLines: 10,)),
              SizedBox(height: 16,),
              InputField(label: "LINKS", widgetField: TextFormField(enabled: isEditingEnabled, initialValue: links, onSaved: (value)=>{links=value!}, maxLines: 10,)),
              SizedBox(height: 16,),
            ],
          )
        )
      );
  }
}

class InputField extends StatefulWidget {
  final String label;
  final Widget widgetField;
  InputField({required this.label, required this.widgetField});
  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          SizedBox(height: 8,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: widget.widgetField,
          )
        ],
      ),
    );
  }
}