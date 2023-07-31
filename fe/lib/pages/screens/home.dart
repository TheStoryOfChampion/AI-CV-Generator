import 'package:ai_cv_generator/api/DownloadService.dart';
import 'package:ai_cv_generator/dio/client/fileApi.dart';
import 'package:ai_cv_generator/api/pdfApi.dart';
import 'package:ai_cv_generator/dio/client/generationApi.dart';
import 'package:ai_cv_generator/dio/response/GenerationResponses/MockGenerationResponse.dart';
import 'package:ai_cv_generator/pages/template/TemplateA.dart';
import 'package:ai_cv_generator/pages/template/TemplateB.dart';
import 'package:ai_cv_generator/pages/widgets/EmptyCV.dart';
import 'package:ai_cv_generator/pages/widgets/ErrorScreen.dart';
import 'package:ai_cv_generator/pages/widgets/cvHistory.dart';
import 'package:ai_cv_generator/pages/widgets/loadingScreen.dart';
import 'package:ai_cv_generator/pages/widgets/navdrawer.dart';
import 'package:ai_cv_generator/pages/widgets/pdf_window.dart';
import 'package:ai_cv_generator/pages/widgets/personaldetails.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import '../../models/user/UserModel.dart';
import 'package:ai_cv_generator/dio/client/userApi.dart';
import 'dart:async';
import 'package:ai_cv_generator/pages/widgets/shareCV.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static UserModel? adjustedModel;
  static bool ready = false;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  UserModel? model;
  int co = 0;

  @override
  void initState() {
    userApi.getUser().then((value) {
      model = value;
      setState(() {});
    });
    super.initState();
  }

  Widget add(String filename,) {
    return OutlinedButton(
        onPressed: ()  {
          FileApi.requestFile(filename: filename).then((value) {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: PdfWindow(file: value,)
                );
            });
          });

        },
        child: Text(filename),
    );
  }

  PlatformFile? uploadFile;
  PlatformFile? generatedFile;
  TextStyle textStyle = const TextStyle(fontSize: 12);
  TextEditingController filenameC = TextEditingController();
  List<Widget> list = [];
  Widget? editPage = EmptyCVScreen();

  @override
  Widget build(BuildContext context) {
    CVHistory cvHistory = CVHistory(context: context);
    if(model == null) {
      return const LoadingScreen();
    }
    return  Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        actions: [
          Transform.scale(
            scale: 0.8,
            child: const SizedBox(
              width: 400,
            ),
          ),
          TextButton(
            onPressed: () {
                Navigator.pushNamed(context, '/about');
            },
            child: Text("ABOUT", style: Theme.of(context).appBarTheme.toolbarTextStyle),
          ),
          const SizedBox(width: 100,),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, '/profile');
                model = await userApi.getUser();
                setState(() {});
              }, 
              child: Row(
                children: [
                  Text(model!.fname,),
                  const SizedBox(width: 4,),
                  const Icon(Icons.account_circle),
                  const SizedBox(width: 16,),
                ],
              )
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 128, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                flex: 2,
                child:Templates()
              ),
              const SizedBox(width: 24,),
              Expanded(
                flex: 3,
                child:Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            child: SizedBox(
                              height: 40,
                              width: 100, 
                              child: ElevatedButton(
                                onPressed: () async {
                                  Home.adjustedModel = model;
                                  await showDialog(
                                    context: context, 
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 800),
                                          child: const PersonalDetailsForm()
                                        )
                                        
                                      );
                                    }
                                  );
                                  if (Home.ready == false) return;
                                  setState(() {
                                    editPage = null;
                                  });
                                  setState(() {
                                    editPage = const LoadingScreen();
                                  });
                                  MockGenerationResponse? response = await GenerationApi.mockgenerate(userModel: (Home.adjustedModel)!);
                                  if (response?.data.description == null) {
                                    editPage = ErrorScreen(errormsg: "Rate Limit Exceeded!");
                                    setState(() {});
                                    return;
                                  }
                                  // editPage = TemplateB(adjustedModel: response!.mockgeneratedUser, data: response!.data);
                                  // TemplateBPdf templateAPdf = TemplateBPdf();
                                  // templateAPdf.writeOnPdf(response!.mockgeneratedUser,response.data);
                                  editPage = TemplateB(user: response!.mockgeneratedUser, data: response!.data);
                                  TemplateBPdf templateBPdf = TemplateBPdf();
                                  // templateAPdf.writeOnPdf();
                                  // generatedFile = await templateAPdf.getPdf();
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PdfWindow(file: file,)
                                  //   )
                                  // );
                                  setState(() {});
                                }, 
                                child: Text("SURVEY", style: textStyle),
                              ),
                            )
                          ),
                          const SizedBox(width: 43,),
                          Container(
                            child: SizedBox(
                              height: 40,
                              width: 100, 
                              child: ElevatedButton(
                                onPressed: () async {
                                  uploadFile = await pdfAPI.pick_cvfile();
                                  if(uploadFile != null) {                    
                                    filenameC.text = uploadFile!.name;
                                    await FileApi.uploadFile(file: uploadFile);
                                    FileApi.getFiles().then((value) {
                                      list = [];
                                      for (var element in value!) {
                                        list.add(add(element.filename));
                                      }
                                        setState(() {
                                      });
                                    });
                                  }
                                }, 
                                child: Text("UPLOAD", style: textStyle),
                              ),
                            )
                          ),
                          const SizedBox(width: 43,),
                          Container(
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(uploadFile != null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PdfView(
                                          controller: PdfController(document: PdfDocument.openData(uploadFile!.bytes as FutureOr<Uint8List>)),
                                          scrollDirection: Axis.horizontal,
                                          pageSnapping: false,
                                        );
                                      }
                                    );
                                  }
                                },
                                child: Text("PREVIEW", style: textStyle),
                              ),
                            )
                          ),
                          const SizedBox(width: 48,),
                          Expanded(
                            flex: 2,
                            child: Text(
                              filenameC.text,
                              style: textStyle
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      if(uploadFile != null || generatedFile != null)
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: SizedBox(
                                height:40,
                                width: 100,
                                child:ElevatedButton(
                                  onPressed: () async {
                                    // MockGenerationResponse? response = await GenerationApi.mockgenerate(userModel: (Home.adjustedModel)!);
                                    // editPage = TemplateA(user: (await userApi.getUser())!);
                                    // setState(() {});
                                  }, 
                                  child: Text("GENERATE", style: textStyle),
                                ),
                              )
                            ),
                            Container(
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (generatedFile != null) {
                                      requirementsforshare(context, generatedFile);
                                    }
                                  },
                                  child: Text("SHARE", style: textStyle),
                                ),
                              ),
                            ),
                            Container(
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (generatedFile != null) {
                                      DownloadService.download(generatedFile!.bytes!.toList(), downloadName: generatedFile!.name);
                                    }
                                  }, child: Text("DOWNLOAD", style: textStyle),
                                ),
                              ),
                            ),
                            Container(
                              child: SizedBox(
                                height: 40,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(generatedFile != null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PdfView(
                                            controller: PdfController(document: PdfDocument.openData(generatedFile!.bytes as FutureOr<Uint8List>)),
                                            scrollDirection: Axis.horizontal,
                                            pageSnapping: false,
                                          );
                                        }
                                      );  
                                    }
                                  }, child: Text("EXPAND", style: textStyle)
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4,),
                      Expanded(child:
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              color: const Color.fromARGB(0, 0, 0, 0),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: editPage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24,),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: PastCVs(),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              color: const Color.fromARGB(0, 0, 0, 0),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: SizedBox.expand(
                            child: Center(child: CVHistory(context: context,list: list,),)
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Templates extends StatefulWidget {
  const Templates({super.key});

  @override
  TemplatesState createState() => TemplatesState();
}

class TemplatesState extends State<Templates> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: const Color.fromARGB(0, 0, 0, 0),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: const Align(
        alignment: Alignment.topCenter,
        child: Text("TEMPLATES", style: TextStyle(fontSize: 16),),
      ),
    );
  }
}

class PastCVs extends StatefulWidget {
  const PastCVs({super.key});

  @override
  PastCVsState createState() => PastCVsState();
}

class PastCVsState extends State<PastCVs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: Text("PAST CVs", style: TextStyle(fontSize: 16),),
      ),
    );
  }
}