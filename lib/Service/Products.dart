// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  List<dynamic> productAdList = [];
  bool isLoading = true;

  void getProductsAdList() async {
    var response = await http.get(
      Uri.parse(getproductAdList),
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    if (jsonResponse['statusCode'] == 'SUCCESS') {
      setState(() {
        productAdList = jsonResponse['data'];
        isLoading = false;
      });
    } else {
      print('Invalid User Credential: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProductsAdList();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubicEmphasized,
      );
    });
  }

  Widget _buildProductCard2() {
    return Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(71, 251, 172, 103),
                ),
                child: Image.asset(
                  'assets/images/Insulin ad.png',
                  height: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Insulin Pump',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 148, 15, 69),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Readmore',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 0, 75, 129),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(67, 103, 167, 251),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/ad patientmonitor.png',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Monitor',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 148, 15, 69),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Readmore',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 0, 75, 129),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(53, 251, 103, 155),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/DVT 3.png',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DVT Pump',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 148, 15, 69),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Readmore',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 0, 75, 129),
                      fontSize: MediaQuery.of(context).size.width * 0.025,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.width * 0.28,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.11,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromARGB(54, 184, 103, 251),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/Suction 2.png',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suction Pump',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 148, 15, 69),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'Readmore',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 0, 75, 129),
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Browse Products',
          style: TextStyle(
            fontFamily: 'Avenir',
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productAdList.isEmpty
                ? CircularProgressIndicator()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: PageView(
                      controller: _pageController,
                      children: productAdList
                          .map((data) => Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${data['project_name']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 148, 15, 69),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                '${data['project_description']}',
                                                style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  color: Color.fromARGB(
                                                      161, 0, 0, 0),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.025,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              color: Color.fromARGB(
                                                  255, 148, 15, 69),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'View Product',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 251, 253, 255),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Image.network(
                                          '${data['image_url']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                      onPageChanged: (int index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _buildProductCard2(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
