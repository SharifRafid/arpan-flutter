import 'package:flutter/material.dart';
import 'package:ui_test/main.dart';

class ScreenWrapper extends StatefulWidget {
  final Widget child;
  final Function() onLeaveScreen;
  final Function() onEnterScreen;
  final String routeName;
  ScreenWrapper({required this.child, required this.onLeaveScreen, required this.onEnterScreen, required this.routeName});

  @override
  State<StatefulWidget> createState() {
    return ScreenWrapperState();
  }
}

class ScreenWrapperState extends State<ScreenWrapper> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onLeaveScreen() {
    if (widget.onLeaveScreen != null) {
      widget.onLeaveScreen();
    }
  }

  void onEnterScreen() {
    if (widget.onEnterScreen != null) {
      widget.onEnterScreen();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyApp.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    MyApp.routeObserver.unsubscribe(this);
  }

  @override
  void didPush() {
    print('*** Entering screen: ${widget.routeName}');
  }

  void didPushNext() {
    print('*** Leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPop() {
    print('*** Going back, leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPopNext() {
    print('*** Going back to screen: ${widget.routeName}');
    onEnterScreen();
  }
}