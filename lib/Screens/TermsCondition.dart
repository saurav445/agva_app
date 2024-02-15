// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text(
          '',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 24,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Terrms & Conditions",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 20,
                      color: Color.fromARGB(255, 157, 0, 86),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Agreement',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Container(
                                    width: 330,
                                    child: Text(
                                      'A Terms and Conditions agreement acts as a legal contract between you AgVa Healthcare and the user. Its where you maintain your rights to exclude users from your app in the event that they abuse your website/app, set out the rules for using your service and note other important details and disclaimers. Having a Terms and Conditions agreement is completely optional. No laws require you to have one. Not even the super-strict and wide-reaching General Data Protection Regulation (GDPR). Your Terms and Conditions agreement will be uniquely yours. While some clauses are standard and commonly seen in pretty much every Terms and Conditions agreement its up to you to set the rules and guidelines that the user must agree to.Terms and Conditions agreements are also known as Terms of Service or Terms of Use agreements. These terms are interchangeable, practically speaking. More rarely, it may be called something like an End User Services Agreement (EUSA).',
                                      style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w200
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Row(
                        //   children: [
                        //     Container(
                        //       height: 45,
                        //       width: 100,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey.withOpacity(0.3),
                        //             spreadRadius: 1,
                        //             blurRadius: 10,
                        //             offset: Offset(0, 3),
                        //           ),
                        //         ],
                        //         color: Colors.white,
                        //         gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.bottomCenter,
                        //           colors: [
                        //             Color.fromARGB(255, 255, 255, 255),
                        //             Color.fromARGB(255, 255, 255, 255),
                        //           ],
                        //         ),
                        //       ),
                        //       child: TextButton(
                        //         onPressed: () {},
                        //         style: TextButton.styleFrom(),
                        //         child: Text(
                        //           "Accept",
                        //           style: TextStyle(
                        //             color: Color.fromARGB(255, 157, 0, 86),
                        //             fontSize: 15,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 20,
                        //     ),
                        //     Container(
                        //       height: 45,
                        //       width: 150,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey.withOpacity(0.3),
                        //             spreadRadius: 1,
                        //             blurRadius: 10,
                        //             offset: Offset(0, 3),
                        //           ),
                        //         ],
                        //         color: Colors.white,
                        //         gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.bottomCenter,
                        //           colors: [
                        //             Color.fromARGB(255, 255, 255, 255),
                        //             Color.fromARGB(255, 255, 255, 255),
                        //           ],
                        //         ),
                        //       ),
                        //       child: TextButton(
                        //         onPressed: () {},
                        //         style: TextButton.styleFrom(),
                        //         child: Text(
                        //           "Monitor Data",
                        //           style: TextStyle(
                        //             color: Color.fromARGB(255, 157, 0, 86),
                        //             fontSize: 15,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
