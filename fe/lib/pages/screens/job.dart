import 'dart:js_interop';

import 'package:ai_cv_generator/dio/client/WebScraperApi.dart';
import 'package:ai_cv_generator/dio/client/userApi.dart';
import 'package:ai_cv_generator/models/user/UserModel.dart';
import 'package:ai_cv_generator/models/webscraper/JobResponseDTO.dart';
import 'package:ai_cv_generator/pages/util/errorMessage.dart';
import 'package:ai_cv_generator/pages/util/successMessage.dart';
import 'package:ai_cv_generator/pages/widgets/breadcrumb.dart';
import 'package:ai_cv_generator/pages/widgets/loadingscreens/loadingScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  JobsPageState createState() => JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  List<Widget> jobCards = [];
  List<Widget> previousJobs = [];
  TextEditingController occupationC = TextEditingController();
  TextEditingController locationC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    populate();
    previousJobs = jobCards;
    super.initState();
  }

  showError(String message) {
    showMessage(message, context);
  }

  showSuccess(String message) {
    showHappyMessage(message, context);
  }

  toLogin() {
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  void populate() async {
    UserModel? user = await UserApi.getUser();
    if(user != null) {
        List<JobResponseDTO>? jobs = await getJobs("accounting", "Pretoria");
        // List<JobResponseDTO>? jobs = await getRecommended();
        setState(() {
          createCards(jobs);
        });
    } else {
      showError("Something went wrong!");
      toLogin();
    }
  }

  Future<void> searchJobs(String occupation, String location) async {
    List<JobResponseDTO>? jobs = await getJobs(occupation, location);
    setState(() {
    if(jobs == null || jobs!.isEmpty == true) {
      showError("No jobs to display!");
      jobCards = previousJobs;
    } else {
      createCards(jobs);
      previousJobs = jobCards;
    }
    });
  }

  Future<List<JobResponseDTO>?> getJobs(String field, String location) async {
    return await WebScrapperApi.scrapejobs(field: field, location: location);
  }

  Future<List<JobResponseDTO>?> getRecommended() async {
    return await WebScrapperApi.recommended();
  }

  createCards(List<JobResponseDTO>? jobs) {
    if(jobs != null) {
      jobs.forEach((element) {
        print(element.imgLink);
        jobCards.add(
          CreateJobCard(
            title: element.title,
            subtitle: element.subTitle,
            location: element.location,
            salary: element.salary,
            link: element.link,
            imageLink: element.imgLink,
          )
        );
      });
    }
  }

  @override
  Widget build(BuildContext build) {
    Size screenSize = MediaQuery.of(context).size;
    double w = screenSize.width/100;
    double h = screenSize.height/100;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ), 
          onPressed: () { 
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, 
            icon: const Icon(
              Icons.account_circle,
              size: 32,
            )
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Breadcrumb(
              previousPage: "Home",
              currentPage: "Jobs",
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    "RECOMMENDED FOR YOU",
                    style: TextStyle(fontSize: 60),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: w*40,
                          child: TextFormField(
                            key: const Key("occupation"),
                            decoration: const InputDecoration(
                              hintText: "Type in your occupation",
                              border: OutlineInputBorder()
                            ),
                            controller: occupationC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your occupation';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          width: w*20,
                          child: TextFormField(
                            key: const Key("occupation"),
                            decoration: const InputDecoration(
                              hintText: "Type in your location",
                              border: OutlineInputBorder()
                            ),
                            controller: locationC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Material(
                            child: InkWell(
                              hoverColor: Colors.grey,
                              onTap: () async{
                                if(_formKey.currentState!.validate() == true) {
                                  setState(() {
                                    jobCards = [];
                                  });
                                  await searchJobs(occupationC.text, locationC.text);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 10*w,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFFDA187).withOpacity(0.9),
                                        const Color(0xFFEA6D79).withOpacity(0.9),
                                      ]
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  "Search",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                )
                              )
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 1800,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if(jobCards.isEmpty == true)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 160),
                              child:LoadingScreen(),
                            ),
                            ...jobCards,
                        ],
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}

class CreateJobCard extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final String? location;
  final String? salary;
  final String? link;
  final String? imageLink;
  const CreateJobCard({super.key, this.title, this.subtitle, this.location, this.salary, this.link, this.imageLink});

  @override
  CreateJobCardState createState() => CreateJobCardState();
}

class CreateJobCardState extends State<CreateJobCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: 400,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.surface
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.subtitle ?? "N/A", style: TextStyle(fontSize: 14),),
                          Text(widget.title ?? "N/A", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: widget.imageLink ?? "http://via.placeholder.com/350x150",
                        progressIndicatorBuilder: (context, url, downloadProgress) => 
                                CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                ],
              ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.salary ?? "N/A", style: TextStyle(color: Colors.green),),
                          Text(widget.location ?? "N/A", style: TextStyle(fontSize: 12,)),
                        ],
                      ),
                    ),
                    SizedBox(width: 24,),
                    ElevatedButton(
                        onPressed: () async {
                          if(widget.link != null) {
                            if (await canLaunchUrl(Uri.parse(widget.link ?? "")))
                              await launchUrl(Uri.parse(widget.link ?? ""));
                          }
                        }, 
                        child: const Text(
                          "VISIT",
                          style: TextStyle(color: Colors.white),
                        ),
                    )
                  ],
                )
              )
            ),
          ],
        ),
      )
    );
  }
}