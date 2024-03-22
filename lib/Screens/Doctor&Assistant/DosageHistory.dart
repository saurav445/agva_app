import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agva_app/Screens/Doctor&Assistant/AddDiagnose.dart';
import 'package:agva_app/config.dart';

class DosageHistory extends StatefulWidget {
  final String uhid;

  DosageHistory(this.uhid, {Key? key}) : super(key: key);

  @override
  State<DosageHistory> createState() => _DosageHistoryState();
}

class _DosageHistoryState extends State<DosageHistory> {
  List<dynamic> dosageList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getdosageHistory();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  Future<void> getdosageHistory() async {
    setState(() {
      isLoading = true;
    });

    String? token = await getToken();

    if (token != null) {
      var response = await http.get(
        Uri.parse('$url/patient/get-diagnose/${widget.uhid}'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        print(jsonResponse);
        setState(() {
          dosageList = jsonResponse['data'];
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
      String event = data['medicine'];
      String diagnosis = data['procedure'];
      // String others = data['others'];
      String date = data['date'];

      DateTime dateTime = DateTime.parse(date);

      String formattedTime = DateFormat('HH:mm:00').format(dateTime);

      print(formattedTime); // Output: 05:14:00

      return ListTile(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[850],
          ),
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
                    Text(
                      'Event',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Diagnosis',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),

                    // Text(
                    //   'Others',
                    //   style: TextStyle(fontWeight: FontWeight.w400),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      event,
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                     Text(
                      diagnosis,
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                    // TextButton(
                    //   onPressed: () => _dialogBuilder(context, others),
                    //   child: Text(
                    //     'Show More',
                    //     style: TextStyle(fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                    Text(
                      date.substring(0, 10),
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
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
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDiagnose(widget.uhid)),
              );

              if (result != null && result == 'refresh') {
                getdosageHistory();
              }
            },
          )
        ],
        title: Text(
          "Events",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getdosageHistory,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                if (isLoading)
                  SizedBox(
                    height: 1,
                    child: LinearProgressIndicator(
                      color: Colors.pink,
                    ),
                  )
                else if (dosageList.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text('No Data Found')],
                    ),
                  )
                else
                  ...buildDeviceList(dosageList),
              ],
            ),
          ),
        ),
      ),
    );
  }
}