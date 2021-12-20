import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthMain extends StatelessWidget {
  const AuthMain({Key? key}) : super(key: key);

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
            child: GestureDetector(
                onTap: () {
                }, // Image tapped
                child: const Image(
                  width: 600,
                  height: 120,
                  image: AssetImage('assets/images/person_icon.png'),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
            child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MainColors.white,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                  hintText: "  ফোন নম্বর লিখুন",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: MainColors.white,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: SizedBox(
                height: 43, //43
                width: 220, //220
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(10, 0, 10, 0)),
                    backgroundColor: MaterialStateProperty.all<Color>(MainColors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'কোড পাঠান',
                      style: TextStyle(
                          color: MainColors.blue,
                          fontSize: 16
                      ),
                    ),
                  ),
                  onPressed: () {

                  },
                )
            ),
          ),
        ],
      ),
    );
  }
}
