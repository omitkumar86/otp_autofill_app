import 'package:flutter/material.dart';
import 'package:opt_autofill_ps/otp_verification.dart';
import 'package:otp_autofill/otp_autofill.dart';

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This filed is required';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 12, right: 12, top: 10, bottom: 10),
                      isDense: true,
                      hintText: "Enter Number",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      _otpInteractor = OTPInteractor();
                      final signCode = _otpInteractor
                          .getAppSignature()
                          .then((value) => print('signature - $value'));
                      //print("Sign Code --------$signCode");
                      if (signCode != null) {
                        setState(() {
                          numberController.text = signCode.toString();
                        });
                      }
                      if (formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OTPVerification()));
                      }
                    },
                    child: Text(
                      "Send OTP",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
