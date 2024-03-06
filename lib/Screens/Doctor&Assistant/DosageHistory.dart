// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:agva_app/Screens/Doctor&Assistant/AddDiagnose.dart';
import 'package:agva_app/config.dart';
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
        Uri.parse('$url/patient/get-diagnose/${widget.uhid}'),
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
          height: 150,
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
                    SizedBox(
                      height: 5,
                    ),
                    Text('Others'),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Date')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(medicine),
                    Text(procedure),
// Text(others),
                    TextButton(
                        onPressed: () => _dialogBuilder(context, others),
                        child: Text('Show More')),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDiagnose(widget.uhid),
                ),
              );
            },
          )
        ],
        title: Text(
          "Add Patient Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (isLoading)
                SizedBox(
                    height: 1,
                    child: LinearProgressIndicator(
                      color: Colors.pink,
                    ))
              else if (dosageList.isEmpty)
                Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ Text('No Data Found')]))
                else
                Column(children: buildDeviceList(dosageList)),
            ],
          ),
        ),
      ),
    );
  }
}
