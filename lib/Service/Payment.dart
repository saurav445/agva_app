// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_X7gVsWi07TXZ35",
      "amount": num.parse(textEditingController.text) * 100,
      "name": "InsuLink",
      "description": "Payment for some random product",
      "prefill": {"contact": "2222222222", "email": "sssdd@gmail.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess() {
    // print("Payment success");
    // Toast.show("Payment success", context);
  }

  void handlerErrorFailure() {
    // print("Payment error");
    // Toast.show("Payment error", context);
  }

  void handlerExternalWallet() {
    // print("External Wallet");
    // Toast.show("External Wallet", context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RazorPay Payment',
      home: Scaffold(
        appBar: AppBar(
            // title: Text('Your App Title'),
            ),
        body: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: "Enter Amount"),
            ),
            SizedBox(
              height: 12,
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200),
                ),
              ),
              onPressed: () {
                openCheckout();
              },
              child: Text(
                "Make Payment",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
