import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Arpan/modules/others/services/others_service.dart';

import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../main.dart';
import '../home/widgets/order_app_bar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late Box box;
  bool loading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  void openBox() async {
    box = await Hive.openBox("orderInputs");
    nameController.text = box.get("feedbackName", defaultValue: "");
    detailsController.text = box.get("feedbackDetails", defaultValue: "");
  }

  void submitFeedback() async {
    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      showLoginToast(context);
      return;
    }
    var name = nameController.text;
    var details = detailsController.text;
    if (name.isEmpty || details.isEmpty) {
      if (!mounted) return;
      showToast(context, "Fill all the required details");
      return;
    }
    setState(() {
      loading = true;
    });
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap["name"] = name.toString();
    hashMap["details"] = details.toString();
    String? status = await OthersService().submitFeedback(hashMap);
    if (status == null) {
      if (!mounted) return;
      showToast(context, "Failed to submit, Try again please");
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      box.delete("feedbackName");
      box.delete("feedbackDetails");
      if (!mounted) return;
      showToast(context, "Successfully submitted the feedback.");
      navigatorKey.currentState?.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "Leave a Message",
        height: appBarHeight,
      ),
      backgroundColor: bgOffWhite,
      body: loading?
          const Center(
            child: CircularProgressIndicator(),
          ):
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: nameController,
                onChanged: (text) {
                  box.put("feedbackName", text.toString());
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8), // Added this
                  isDense: true,
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 200,
                child: TextFormField(
                  expands: true,
                  onChanged: (text) {
                    box.put("feedbackDetails", text.toString());
                  },
                  style: const TextStyle(fontSize: 14),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  controller: detailsController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8), // A
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Details',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              height: 50,
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: MaterialButton(
                onPressed: () {
                  submitFeedback();
                },
                color: Colors.green,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: textWhite),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
