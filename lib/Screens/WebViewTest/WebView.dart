import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Timer(Duration(seconds: 3), () {
      print('Inside webView');
    });
  }

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.black)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'http://192.168.2.10:3000/live?code=SBXMH&projectName=Ventilator&DeviceId=724963b4f3ae2a8f'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Positioned(child: WebViewWidget(controller: controller))),
    );
  }
}
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_new, prefer_const_constructors

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class MyInAppBrowser extends InAppBrowser {
//   @override
//   Future onBrowserCreated() async {
//     print("Browser Created!");
//   }

//   @override
//   Future onLoadStart(url) async {
//     print("Started $url");
//   }

//   @override
//   Future onLoadStop(url) async {
//     print("Stopped $url");
//   }

//   @override
//   void onLoadError(url, code, message) {
//     print("Can't load $url.. Error: $message");
//   }

//   @override
//   void onProgressChanged(progress) {
//     print("Progress: $progress");
//   }

//   @override
//   void onExit() {
//     print("Browser closed!");
//   }
// }

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeRight,
//     DeviceOrientation.landscapeLeft,
//   ]);

//   if (Platform.isAndroid) {
//     await InAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }

//   runApp(
//     MaterialApp(
//       home: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   final MyInAppBrowser browser = new MyInAppBrowser();

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     super.dispose();
//   }
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   SystemChrome.setPreferredOrientations([
//   //     DeviceOrientation.landscapeRight,
//   //     DeviceOrientation.landscapeLeft,
//   //   ]);
//   //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   //   Timer(Duration(seconds: 3), () {
//   //     print('Inside webView');
//   //     widget.browser.openUrlRequest(
//   //         urlRequest: URLRequest(
//   //             url: WebUri(
//   //                 'http://192.168.2.10:3000/live?code=SBXMH&projectName=Ventilator&DeviceId=724963b4f3ae2a8f')),
//   //         options: options);
//   //   });
//   // }

//   // var options = InAppBrowserClassOptions(
//   //     crossPlatform:
//   //         InAppBrowserOptions(hideUrlBar: true, hideToolbarTop: true),
//   //     inAppWebViewGroupOptions: InAppWebViewGroupOptions(
//   //         crossPlatform:
//   //             InAppWebViewOptions(javaScriptEnabled: true, supportZoom: true)));

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body: SizedBox(
//   //       height: 2,
//   //       child: LinearProgressIndicator(
//   //                 color: Colors.pink,
//   //               ),
//   //     ),
//   //   );
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InAppWebView(
//         // initialOptions: options,
//         onWebViewCreated: (controller) {
//           Timer(
//             Duration(seconds: 3),
//             () {
//               print('Inside webView');
//               widget.browser.openUrlRequest(
//                 urlRequest: URLRequest(
//                   url: WebUri(
//                     'http://192.168.2.10:3000/live?code=SBXMH&projectName=Ventilator&DeviceId=724963b4f3ae2a8f',
//                   ),
//                 ),
//                 options: InAppBrowserClassOptions(
//                     crossPlatform: InAppBrowserOptions(
//                       hideUrlBar: true,
//                       hideToolbarTop: true,
//                       hideProgressBar: true
//                     ),
//                     inAppWebViewGroupOptions: InAppWebViewGroupOptions(
//                         crossPlatform: InAppWebViewOptions(
//                             javaScriptEnabled: true, supportZoom: true))),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

