import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackexx/theme/color.dart';
import 'package:trackexx/theme/style.dart';
import 'package:trackexx/widget/buttons.dart';
import 'package:trackexx/widget/inputbox.dart';
import 'package:trackexx/widget/snackbar.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass(BuildContext context, {super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  late TextEditingController email, pass;
  bool emailError = false, passError = false;
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var wait = 2400;
  int w = 0;
  bool readonly = false;
  bool sendagain = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    email = TextEditingController();
    pass = TextEditingController();
    timereset();
    super.initState();
  }

  void timereset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? timestamp = prefs.getInt('myTimestampKey');
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp!);
      DateTime before = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime now = DateTime.now();
      Duration timeDifference = now.difference(before);
      print(timeDifference.inSeconds);

      setState(() {
        w = timeDifference.inSeconds;
      });
      if (w > 120) {
        setState(() {
          readonly = false;
        });
      } else {
        setState(() {
          readonly = true;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void forgotPass(BuildContext context) async {
    try {
      //  UserCredential userCredential = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email.text, password: pass.text);
      // print("login");

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      CustomSnackBar(
              actionTile: "close",
              haserror: false,
              scaffoldKey: scaffoldKey,
              isfloating: false,
              onPressed: () {},
              title: "Reset password link sended successfully.")
          .show(context);

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('myTimestampKey', timestamp);
      setState(() {
        readonly = true;
        sendagain = true;
        w = 0;
        isloading = false;
      });

      // Provider.of<UserProvider>(context, listen: false).fetchLogedUser();

      //   Provider.of<ActivitieProvider>(context, listen: false)
      //   .getActivitiesFromFirebase();

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => DashBoard()),
      //  (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        setState(() {
          emailError = true;
          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "No user found for this email!")
              .show(context);
        });
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        isloading = false;
        passError = true;
        setState(() {
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "Wrong password provided for this user!")
              .show(context);
        });
        print('Wrong password provided for that user.');
      } else {
        isloading = false;
        passError = true;
        setState(() {
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: e.message!)
              .show(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: black,
            size: mainMargin + 6,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        padding: EdgeInsets.all(mainMargin),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forogot \nPassword?",
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 36),
              ),
              SizedBox(
                height: mainMargin,
              ),
              Text(
                "Enter your email address to get reset password link.",
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w400,
                    fontSize: subMargin + 4),
              ),
              SizedBox(
                height: 1 * mainMargin,
              ),
              IgnorePointer(
                ignoring: readonly,
                child: inputBox(
                  minLine: 1,
                  controller: email,
                  error: emailError,
                  errorText: "",
                  inuptformat: [],
                  labelText: "Email Adress",
                  obscureText: false,
                  ispassword: false,
                  istextarea: false,
                  readonly: readonly,
                  onchanged: () {
                    setState(() {
                      emailError = false;
                    });
                  },
                ),
              ),
              readonly
                  ? SizedBox(
                      height: mainMargin,
                    )
                  : const SizedBox.shrink(),
              readonly
                  ? TweenAnimationBuilder<Duration>(
                      duration: Duration(seconds: 120 - w),
                      tween: Tween(
                          begin: Duration(seconds: 120 - w),
                          end: Duration.zero),
                      onEnd: () {
                        print('Timer ended');
                        setState(() {
                          readonly = false;
                          sendagain = true;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return (minutes == 0 && seconds == 0)
                            ? Text("You can resend now ",
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: subMargin + 4))
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Please wait for ' +
                                      value.inSeconds.toString() +
                                      ' seconds to resend password reset link',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: subMargin + 4),
                                ));
                      })
                  : SizedBox.shrink(),
              SizedBox(
                height: mainMargin,
              ),
              IgnorePointer(
                ignoring: readonly,
                child: PrimaryButton(
                  isloading: isloading,
                  onPressed: () {
                    if (email.text == '') {
                      print("email null");
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title: "Please enter your email!")
                            .show(context);
                        emailError = true;
                      });
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email.text)) {
                      print("not  email");
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title: "Please enter valid email!")
                            .show(context);
                        emailError = true;
                      });
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      print("calling signin");
                      ForgotPass(context);
                    }
                  },
                  title: readonly ? "Wait" : "Send Link",
                  backgroundColor: primary,
                  foregroundColor: white,
                  height: 55,
                  fontsize: 24,
                  width: 200,
                  borderRadius: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
