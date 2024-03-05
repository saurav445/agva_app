// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DosageHistory extends StatefulWidget {
  final String uhid;
  DosageHistory(this.uhid, {super.key});

  @override
  State<DosageHistory> createState() => _DosageHistoryState();
}

class _DosageHistoryState extends State<DosageHistory> {
  late String uhid;
  List<dynamic> dosageList = [];

  @override
  void initState() {
    super.initState();
    getdosageHistory();
  }

  late SharedPreferences prefs;
  bool isLoading = true;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  Future<void> getdosageHistory() async {
    String? token = await getToken();

    if (token != null) {
      var response = await http.get(
        Uri.parse(
            'http://3.25.213.83:8000/patient/get-diagnose/Rohan044'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      // print(jsonResponse);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        // print(jsonResponse);
        dosageList = jsonResponse['data'];
        setState(() {
          isLoading = false;
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Widget> buildDeviceList(List<dynamic> dosageList) {
    return dosageList.map((data) {
      print('dosagelist: $data');
      String medicine = data['medicine'];
      String procedure = data['procedure'];
      String others = data['others'];
      String date = data['date'];

      return ListTile(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[850],
          ),
          height: 200,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medicine'),
                    Text('Procedure'),
                    Text('Others'),
                    Text('Date')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(medicine),
                    Text(procedure),
                    Row(
                      children: [
                        Text(others.substring(0, 9)),
                        TextButton(
                            onPressed: () => _dialogBuilder(context, others),
                            child: Text('Read More'))
                      ],
                    ),
                    Text(date.substring(0, 10))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _dialogBuilder(BuildContext context, String others) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(others),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dosage History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: buildDeviceList(dosageList),
          ),
        ),
      ),
    );
  }
}
