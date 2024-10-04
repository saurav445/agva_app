// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final PageController _bannerTopPageController = PageController();
  final PageController _featureListPageController = PageController();
  int _currentBannerTopPage = 0;
  Timer? _timer;
  List<dynamic> productList = [];
  bool isLoading = true;

  void getProductsAdList() async {
    var response = await http.get(
      Uri.parse(getproductAdList),
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['statusCode'] == 'SUCCESS') {
      setState(() {
        productList = jsonResponse['data'];
        print(productList);
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
    _bannerTopPageController.dispose();
    _featureListPageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    print('timer is started ');
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      print('timer is started 2');
      if (_currentBannerTopPage < 2) {
        _currentBannerTopPage++;
        print('timer is started 3');
      } else {
        _currentBannerTopPage = 0;
      }
      _bannerTopPageController.animateToPage(
        _currentBannerTopPage,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOutCubicEmphasized,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color randomColor = Color.fromRGBO(
      Random().nextInt(255),
      Random().nextInt(255),
      Random().nextInt(255),
      220,
    );

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
        child: productList.isEmpty
            ? SizedBox(
                height: 2,
                child: LinearProgressIndicator(
                  color: Colors.pink,
                ))
            : Column(
                children: [
                  bannerTopList(
                      context,
                      productList
                          .where((data) => data['type'] == 'banner')
                          .toList()),
                  featureList(
                      context,
                      randomColor,
                      productList
                          .where((data) => data['type'] == 'featured')
                          .toList()),
                  featureList(
                      context,
                      randomColor,
                      productList
                          .where((data) => data['type'] == 'commingsoon')
                          .toList()),
                  bannerTopList(
                      context,
                      productList
                          .where((data) => data['type'] == 'topselling')
                          .toList()),
                ],
              ),
      ),
    );
  }

  SizedBox featureList(
      BuildContext context, Color randomColor, List<dynamic> dataList) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: dataList.map((data) {
                return Padding(
                  padding: const EdgeInsets.only(right: 11),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 9,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(27, 178, 0, 59)),
                          child: Image.network(
                            '${data['image_url']}',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['product_name']}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 148, 15, 69),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'Readmore',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 0, 75, 129),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  SizedBox bannerTopList(BuildContext context, List<dynamic> dataList) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width / 1,
      child: PageView(
        controller: _bannerTopPageController,
        children: dataList.map((data) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${data['project_name']}',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 148, 15, 69),
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 50,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            '${data['project_description']}',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(161, 0, 0, 0),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Color.fromARGB(255, 148, 15, 69),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'View Product',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 251, 253, 255),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
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
          );
        }).toList(),
        onPageChanged: (int index) {
          setState(() {
            _currentBannerTopPage = index;
          });
        },
      ),
    );
  }
}
