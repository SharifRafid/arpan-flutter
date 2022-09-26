import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/auth/widgets/resend_button.dart';
import 'package:ui_test/modules/home/home_screen.dart';

import '../../global/networking/responses/default_response.dart';
import '../../global/networking/responses/login_response.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/utils.dart';
import 'services/auth_service.dart';
import 'widgets/text_field_number.dart';
import 'widgets/verify_button.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AuthMain();
  }
}

class _AuthMain extends StatefulWidget {
  const _AuthMain({Key? key}) : super(key: key);

  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<_AuthMain> {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  final authService = AuthService();

  var phoneNumber = "";

  // Visibility
  var showLoading = false;
  var showPhoneTextField = true;
  var showCodeTextField = false;
  var showSendButton = true;
  var showVerifyButton = false;
  var showTimer = false;
  var showResendButton = false;

  void verifyCode(String code) async {
    var box = await Hive.openBox('authBox');
    LoginResponse loginResponse =
        await authService.getLoginResponse(phoneNumber, code);
    if (loginResponse.user != null && loginResponse.tokens != null) {
      await box.put(
          "accessToken", loginResponse.tokens!.access!.token!);
      await box.put(
          "refreshToken", loginResponse.tokens!.refresh!.token!);
      await box.put("name", loginResponse.user!.name!);
      await box.put("address", loginResponse.user!.address!);
      await box.put("phone", loginResponse.user!.phone!);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeScreen()),
            (route)=>false,
      );
    } else {
      setState(() {
        showLoading = false;
        showVerifyButton = true;
      });
      if (!mounted) return;
      showToast(context, "Incorrect OTP, try again.");
    }
  }

  void verifyPhone(String number) async {
    phoneNumber = number;
    setState(() {
      showPhoneTextField = true;
      showLoading = true;
      showSendButton = false;
      showCodeTextField = false;
      showVerifyButton = false;
      showTimer = false;
      showResendButton = false;
    });
    DefaultResponse defaultResponse = await authService.getSendOTPResponse(number, generateSignature());
    if (defaultResponse.error == true) {
      setState(() {
        showPhoneTextField = true;
        showLoading = false;
        showSendButton = true;
        showCodeTextField = false;
        showVerifyButton = false;
        showTimer = false;
        showResendButton = false;
      });
      if (!mounted) return;
      showToast(context, "Failed to send : ${defaultResponse.message}");
    } else {
      setState(() {
        showPhoneTextField = false;
        showLoading = false;
        showSendButton = false;
        showCodeTextField = true;
        showVerifyButton = true;
        showTimer = true;
      });
      if (!mounted) return;
      showToast(context, "OTP sent successfully");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: const Image(
              width: 600,
              height: 120,
              image: AssetImage('assets/images/person_icon.png'),
            ),
          ),
          showPhoneTextField
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
                  child: textFieldNumber(
                    hint: "  Please enter phone number",
                    controller: phoneController,
                  ),
                )
              : Container(),
          showCodeTextField
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
                  child: textFieldNumber(
                    hint: "  Please enter OTP",
                    controller: codeController,
                  ),
                )
              : Container(),
          showSendButton
              ? buttonMain(
                  onClickAction: () {
                    if (phoneController.text.isEmpty) {
                      showToast(context, "Please enter phone number");
                    } else {
                      verifyPhone(phoneController.text);
                    }
                  },
                  title: 'Send code',
                )
              : Container(),
          showVerifyButton
              ? buttonMain(
            onClickAction: () {
              if (codeController.text.isEmpty) {
                showToast(context, "Please enter OTP");
              } else {
                setState(() {
                  showLoading = true;
                  showVerifyButton = false;
                });
                verifyCode(codeController.text);
              }
            },
            title: 'Verify',
          )
              : Container(),
          showResendButton
              ? resendButton(
            onClickAction: () {
              if (phoneNumber.isEmpty) {
                showToast(context, "Please enter phone number");
              } else {
                verifyPhone(phoneNumber);
              }
            },
            title: 'Resend Code',
          )
              : Container(),
          showTimer ? _ResendCodeTimer(onFinish: () {
            setState((){
              showResendButton = true;
              showTimer = false;
            });
          }) : Container(),
          showLoading
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    color: textWhite,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class _ResendCodeTimer extends StatefulWidget {
  final Function onFinish;

  const _ResendCodeTimer({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<_ResendCodeTimer> createState() => _ResendCodeTimerState();
}

class _ResendCodeTimerState extends State<_ResendCodeTimer> {
  _ResendCodeTimerState();

  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          widget.onFinish();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    if(_timer.isActive){
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Resend after $_start seconds",
          style: const TextStyle(
            fontSize: 14,
            color: textWhite,
          ),
        ),
      ),
    );
  }
}
