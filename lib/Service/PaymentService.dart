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
         debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Payment', style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context, 'refresh');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40,),
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(hintText: "Enter Amount", hintStyle: TextStyle(color: Colors.white70),),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 92, 175, 76),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
                onPressed: () {
                  openCheckout();
                },
                child: Text(
                  "Make Payment",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
