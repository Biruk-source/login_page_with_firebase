import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ButtonState stateOnlyCustomIndicatorText = ButtonState.idle;

  void onPressedCustomIndicatorButton() {
    setState(() {
      switch (stateOnlyCustomIndicatorText) {
        case ButtonState.idle:
          stateOnlyCustomIndicatorText = ButtonState.loading;
          break;
        case ButtonState.loading:
          stateOnlyCustomIndicatorText = ButtonState.fail;
          break;
        case ButtonState.success:
          stateOnlyCustomIndicatorText = ButtonState.idle;
          break;
        case ButtonState.fail:
          stateOnlyCustomIndicatorText = ButtonState.success;
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
              color: const Color.fromARGB(255, 70, 15, 15),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(249, 252, 208, 11),
          actions: [Icon(Icons.info), Icon(Icons.more_vert)],
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 245, 216),
              border: Border.all(
                color: const Color.fromARGB(167, 115, 245, 9),
                width: 1,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Expanded(
                      child: Container(
                        child: Lottie.asset(
                          'assets/animations/Animation - 1737998566825 (1).json',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        'GB delivery',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AguDisplay',
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.blue, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 3),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'username',
                              suffixIcon: Icon(Icons.person),
                              border: InputBorder.none,
                              fillColor:
                                  const Color.fromARGB(197, 110, 226, 255),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 4.0,
                              ),
                            ),
                          )),
                      Container(
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.blue, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(bottom: 7),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'password',
                              suffixIcon: Icon(Icons.lock),
                              border: InputBorder.none,
                              fillColor:
                                  const Color.fromARGB(197, 110, 226, 255),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 4.0,
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ProgressButton(
                          stateWidgets: {
                            ButtonState.idle: Text(
                              "Login",
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 238, 217, 214),
                                  fontWeight: FontWeight.w500),
                            ),
                            ButtonState.loading: Text(
                              "Loading",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            ButtonState.fail: Text(
                              "Fail",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            ButtonState.success: Text(
                              "Success",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )
                          },
                          progressIndicator: CircularProgressIndicator(
                            backgroundColor:
                                const Color.fromARGB(255, 253, 253, 253),
                            valueColor: AlwaysStoppedAnimation(
                                const Color.fromARGB(255, 5, 1, 0)),
                            strokeWidth: 1,
                          ),
                          stateColors: {
                            ButtonState.idle:
                                const Color.fromARGB(255, 0, 4, 255),
                            ButtonState.loading:
                                const Color.fromARGB(255, 105, 49, 196),
                            ButtonState.fail: Colors.red.shade300,
                            ButtonState.success: Colors.green.shade400,
                          },
                          onPressed: onPressedCustomIndicatorButton,
                          state: stateOnlyCustomIndicatorText,
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      Spacer(),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SignInButton(
                            Buttons.google,
                            onPressed: () {},
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
