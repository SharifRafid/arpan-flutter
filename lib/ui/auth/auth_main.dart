import 'package:arpan_app_new/services/utils/show_toast.dart';
import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:arpan_app_new/widgets/text_field_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arpan_app_new/widgets/verify_button.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AuthMain();
  }
}

class _AuthMain extends StatefulWidget {
  _AuthMain({Key? key}) : super(key: key);

  @override
  _AuthMainState createState() => _AuthMainState();
}

class _AuthMainState extends State<_AuthMain> {

  final auth = FirebaseAuth.instance;

  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  var verificationId = "";
  var resendToken = 0;

  // Visibility
  var showLoading = false;
  var showPhoneTextField = true;
  var showCodeTextField = false;
  var showSendButton = true;
  var showVerifyButton = false;

  void verifyCode(String code) async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code);
    await auth.signInWithCredential(credential);
  }

  void verifyPhone(String number) async{
    await auth.verifyPhoneNumber(
        phoneNumber: "+88"+number,
        verificationCompleted: (PhoneAuthCredential credential) async{
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e){
          showToast("ভেরিফিকেশন ব্যর্থ হয়েছে! --"+e.code);
          setState(() {
            showLoading = false;
            showPhoneTextField = true;
            showCodeTextField = false;
            showSendButton = true;
            showVerifyButton = false;
          });
        },
        codeSent: (String verificationId, int? resendToken){
          this.verificationId = verificationId;
          if(resendToken!=null){
            this.resendToken = resendToken;
          }
          setState(() {
            showPhoneTextField = false;
            showLoading = false;
            showSendButton = false;
            showCodeTextField = true;
            showVerifyButton = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId){

        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.blue,
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
          showPhoneTextField ? Padding(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
            child: textFieldNumber(
              hint: "  ফোন নম্বর লিখুন",
              controller: phoneController,
            ),
          ) : Container(),
          showCodeTextField ? Padding(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
            child: textFieldNumber(
              hint: "  ভেরিফিকেশন কোড দিন",
              controller: codeController,
            ),
          ) : Container(),
          showSendButton & !showLoading ? buttonMain(
            onClickAction: (){
              if(phoneController.text.isEmpty){
                showToast("ফোন নম্বর দিন");
              }else{
                setState(() {
                  showLoading = true;
                  showSendButton = false;
                });
                verifyPhone(phoneController.text);
              }
            },
            title: 'কোড পাঠান',
          ) : Container(),
          showVerifyButton & !showLoading ? buttonMain(
            onClickAction: (){
              if(codeController.text.isEmpty){
                showToast("ভেরিফিকেশন কোড দিন");
              }else{
                setState(() {
                  showLoading = true;
                  showVerifyButton = false;
                });
                verifyCode(codeController.text);
              }
            },
            title: 'ভেরিফাই করুন',
          ) : Container(),
          showLoading ? const CircularProgressIndicator() : Container()
        ],
      ),
    );
  }
}

