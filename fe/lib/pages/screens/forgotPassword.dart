import 'package:ai_cv_generator/dio/client/AuthApi.dart';
import 'package:ai_cv_generator/dio/response/AuthResponses/Code.dart';
import 'package:ai_cv_generator/pages/util/errorMessage.dart';
import 'package:ai_cv_generator/pages/util/successMessage.dart';
import 'package:ai_cv_generator/pages/widgets/buttons/generalTextButtonLarge.dart';
import 'package:ai_cv_generator/pages/widgets/loadingscreens/loadingScreen.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back,color: Colors.black,)
        ),
      ),
        body: const ForgotPasswordWidget()
    );
  }
}

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});
  @override
  State<StatefulWidget> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  showError(String message) {
    showMessage(message, context);
  }
  showSuccess(String message) {
    showHappyMessage(message, context);
  }
  toLogin() {
    Navigator.pop(context);
  }
  bool wait = false;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double w = screenSize.width/100;
    double h = screenSize.height/100; 
    if (wait) return const LoadingScreen();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(1*w),
                child: const Image(image: ResizeImage(AssetImage('assets/images/logo.png'),width:350,height:350),)
                ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(2*w, 1*h, 2*w, 1*h),
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(33*w, 1*h, 33*w, 1*h),
              child: TextField(
                key: const Key('name'),
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(33*w, 1*h, 33*w, 1*h),
              child: TextField(
                key: const Key('email'),
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Your Email',
                ),
              ),
            ),
            SizedBox(
              height: 3*h,
            ),
            SizedBox(
              height: 5*h,
              width: 15*w,
              child: InkWell(
                key: const Key('forgotPassword'),
                child: const GeneralButtonStyleLarge(text: "Send Verification Code",),
                onTap: () async {
                  setState(() {
                    wait = true;
                  });
                  Code resp = await AuthApi.reset(username: nameController.text, email: emailController.text);
                  if (resp == Code.success) {
                    showSuccess("Please check your email for further instructions!");
                    setState(() {
                      wait = false;
                    });
                    toLogin();
                  } else if (resp == Code.failed) {
                    showError("Invalid Credentials!!");
                    setState(() {
                      wait = false;
                    });
                  } else if (resp == Code.requestFailed) {
                    showError("Something went wrong!!");
                    setState(() {
                      wait = false;
                    });
                  }
                },
              )
            ),
        ]
      )
    );
  }
}