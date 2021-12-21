
import 'package:arpan_app_new/ui/main/home_page_main.dart';
import 'package:arpan_app_new/ui/onboard/on_board_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseUser = context.watch<User?>();
    if(firebaseUser == null){
      return const OnBoardPage();
    }else{
      return const HomePageMain();
    }
  }
}
