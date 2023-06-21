import 'package:flutter/material.dart';
import 'package:opt_autofill_ps/home_page.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pinput.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({super.key});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  final scaffoldKey = GlobalKey();
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  @override
  void initState() {
    super.initState();
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 5,
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{5})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        //SampleStrategy(),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify OTP Code', style: TextStyle(fontSize: 20, color: Colors.black),),
              SizedBox(height: 30,),
              Pinput(
                length: 5,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                controller: controller,
                onChanged: (value) {
                  if (value.length == 5) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
