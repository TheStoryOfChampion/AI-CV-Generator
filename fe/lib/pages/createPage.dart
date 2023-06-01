
import 'package:ai_cv_generator/api/pdfApi.dart';
import 'package:ai_cv_generator/dio/client/fileApi.dart';
import 'package:ai_cv_generator/dio/client/userApi.dart';
import 'package:ai_cv_generator/pages/pdf_window.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImportCV extends StatefulWidget {
  const ImportCV({super.key});

  @override
  _ImportCVState createState() => _ImportCVState();
}

class _ImportCVState extends State<ImportCV> {
  Map data = {};
  PlatformFile? file;
  bool fileAvail = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (fileAvail == false)
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton(
                      onPressed: () async {
                          final fi = await pdfAPI.pick_cvfile();
                          if (fi == null) return;
                          
                          setState(() {
                              file = fi;
                              fileAvail = true;
                          });
                      }, 
                      child: const Text("Upload")
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton(
                      onPressed: () {
                        userApi().getUser(id: "test_id");
                      }, 
                      child: const Text("Test Button")
                    ) 
                  ),
                ]
              ),
              fileAvail == true ?
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Scaffold(
                    appBar: AppBar(
                      actions: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                                setState(() {
                                  file = null;
                                  fileAvail = false;
                                });
                            },
                          )
                      ],
                      leading: IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {
                          if (file == null) {return;}
                            FileApi().uploadFile(file: file, id: "test_id");
                          
                        },
                      ),
                      backgroundColor: Colors.blueGrey[900],
                    ),
                    body: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 1
                          )
                        ),
                        child: PdfWindow(file: file),
                    )
                  ),
                )
              ) : const Text("")
          ],
        )
      )
    );
  }
  void openFile(PlatformFile? f,BuildContext c) => Navigator.of(c).push(
    MaterialPageRoute(builder: (c)=> PdfWindow(key:null,file: f,))
  );
}