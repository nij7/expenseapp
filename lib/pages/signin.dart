import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trackexx/pages/dashboard.dart';
import 'package:trackexx/pages/forgot_pass.dart';
import 'package:trackexx/providor/user_providor.dart';
import 'package:trackexx/theme/color.dart';
import 'package:trackexx/theme/style.dart';
import 'package:trackexx/widget/buttons.dart';
import 'package:trackexx/widget/inputbox.dart';
import 'package:trackexx/widget/snackbar.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late TextEditingController email, pass;
  bool emailError = false, passError = false;
  bool isloading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    email = TextEditingController();
    pass = TextEditingController();
    super.initState();
  }

  void sigin(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pass.text);
      print("login");
      print(userCredential);
      print("user instance");
      print(userCredential.user);

      Provider.of<UserProvider>(context, listen: false)
          .fetchLogedUser()
          .then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
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
        print(e.code);
        setState(() {
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: e.code)
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
              Text(
                "Login",
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: mainMargin,
              ),
              Text(
                "Enter your email address and password\nto get access your account",
                style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w400,
                    fontSize: subMargin + 4),
              ),
              SizedBox(
                height: 2 * mainMargin,
              ),
              inputBox(
                minLine: 1,
                controller: email,
                error: emailError,
                errorText: "",
                inuptformat: [],
                labelText: "Email Address",
                obscureText: false,
                ispassword: false,
                istextarea: false,
                readonly: false,
                onchanged: () {
                  emailError = false;
                  ;
                },
              ),
              SizedBox(
                height: mainMargin,
              ),
              inputBox(
                minLine: 1,
                controller: pass,
                error: passError,
                errorText: "",
                inuptformat: [],
                labelText: "Password",
                readonly: false,
                obscureText: true,
                ispassword: true,
                istextarea: false,
                onchanged: () {
                  passError = false;
                },
              ),
              SizedBox(
                height: mainMargin,
              ),
              PrimaryButton(
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
                  } else if (pass.text == '') {
                    setState(() {
                      CustomSnackBar(
                              actionTile: "close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              onPressed: () {},
                              title: "Please enter your password!")
                          .show(context);

                      passError = true;
                    });
                  } else {
                    setState(() {
                      isloading = true;
                    });

                    print("calling signin");
                    sigin(context);
                  }
                },
                title: "Login",
                backgroundColor: primary,
                foregroundColor: white,
                height: 55,
                width: 200,
                borderRadius: 20,
                fontsize: 18,
              ),
              SizedBox(
                height: mainMargin,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPass(context)));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontSize: mainMargin - 2, fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
