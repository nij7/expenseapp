import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trackexx/pages/dashboard.dart';
import 'package:trackexx/providor/user_providor.dart';
import 'package:trackexx/theme/color.dart';
import 'package:intl/intl.dart';

import 'package:trackexx/theme/style.dart';
import 'package:trackexx/widget/buttons.dart';
import 'package:trackexx/widget/inputbox.dart';
import 'package:trackexx/widget/snackbar.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController email, pass, name, cpass, description;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  var date;

  bool tnc = false;
  bool isloading = false;
  bool emailError = false, passError = false;
  bool dateError = false, fnameErorr = false;
  bool bioError = false;
  String checkboxEror = '';
  String generalError = '';
  String emailText = '';
  String passText = '';
  String cpassText = '';
  String fnameText = '';
  String descriptiomText = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  File? _pickedImage;

  String? imagePath;

  void uploadProfileanddata(
      BuildContext context, UserCredential userCredential) async {
    // firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile photo')
        .child('/' + email.text + '.jpg');

    final metadata = firebaseStorage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _pickedImage!.path});
    ref.putFile(File(_pickedImage!.path), metadata).then((value) async {
      print("file uploaded");
      imagePath = await ref.getDownloadURL();
      print(imagePath);
      final CollectionReference postsRef =
          FirebaseFirestore.instance.collection('users');
      var data = {
        "email": email.text,
        "name": name.text,
        "birthdate": Timestamp.fromDate(DateTime.parse(date)),
        "bio": description.text,
        "profilePicture": imagePath,
        "isplus": false,
      };
      postsRef.doc(userCredential.user!.uid).set(data);
      Provider.of<UserProvider>(context, listen: false).fetchLogedUser();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (contex) => Dashboard()),
          (route) => false);
    });
  }

  void signup(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: pass.text);

      try {
        uploadProfileanddata(context, userCredential);
      } catch (e) {
        print("something wrong,please try again latter");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        setState(() {
          passText = 'The password provided is too weak';
          passError = true;

          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The password provided is too weak!")
              .show(context);
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailText = 'The account already exists for this email';
          emailError = true;
          isloading = false;
          CustomSnackBar(
                  actionTile: "close",
                  haserror: true,
                  scaffoldKey: scaffoldKey,
                  isfloating: false,
                  onPressed: () {},
                  title: "The account already exists for this email!")
              .show(context);
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    email = TextEditingController();
    pass = TextEditingController();
    cpass = TextEditingController();
    name = TextEditingController();
    description = TextEditingController();
    super.initState();
  }

  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        title: Text(
          "Create an Account",
          style: TextStyle(
              color: primary, fontWeight: FontWeight.bold, fontSize: 30),
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                if (overscroll.leading) {
                  // loadmore();
                  overscroll.disallowIndicator();
                  return true;
                } else {
                  overscroll.disallowIndicator();
                  return false;
                }
              },
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Container(
                        width: 145,
                        height: 145,
                        //color: primary,
                        child: Center(
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: _pickedImage == null
                                    ? Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: primary.withOpacity(0.85)),
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: white,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _pickedImage!,
                                          width: 120,
                                          height: 120,
                                        ),
                                      ),
                              ),
                              Positioned(
                                right: 5,
                                top: 5,
                                child: InkWell(
                                  onTap: () {
                                    _showPickOptionsDialog(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(
                                            buttonRadius)),
                                    child: Icon(
                                      _pickedImage == null
                                          ? Icons.camera_alt
                                          : Icons.sync,
                                      color: white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2 * mainMargin,
                  ),
                  inputBox(
                    minLine: 1,
                    controller: name,
                    error: fnameErorr,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                    ],
                    labelText: "First Name",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: () {
                      setState(() {
                        fnameErorr = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    minLine: 0,
                    controller: email,
                    error: emailError,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [
                      FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                    ],
                    labelText: "Email Address",
                    obscureText: false,
                    ispassword: false,
                    istextarea: false,
                    onchanged: () {
                      setState(() {
                        emailError = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    minLine: 0,
                    controller: pass,
                    error: passError,
                    readonly: isloading,
                    errorText: "",
                    inuptformat: [],
                    labelText: "Password",
                    obscureText: true,
                    ispassword: true,
                    istextarea: false,
                    onchanged: () {
                      setState(() {
                        passError = false;
                      });
                    },
                  ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Select Date",
                        hintStyle: const TextStyle(
                          color: black,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              final DateTime? date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2028));
                              final formatteddate = DateFormat(
                                "dd-MM-yyyy",
                              ).format(date!);
                              setState(() {
                                _dateController.text = formatteddate.toString();
                              });
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                              color: blue,
                            ))),
                  ),
                  // DateTimePicker(
                  //   maxLines: 1,
                  //   type: DateTimePickerType.date,
                  //   dateMask: 'd MMM, yyyy',
                  //   readOnly: isloading,
                  //   decoration: InputDecoration(
                  //       errorText: dateError ? "" : null,
                  //       contentPadding: EdgeInsets.only(
                  //           right: subMargin,
                  //           left: subMargin,
                  //           bottom: mainMargin - 1,
                  //           top: mainMargin + 2),
                  //       errorStyle: TextStyle(color: errorColor, height: 0),
                  //       labelStyle:
                  //           TextStyle(color: primary, fontSize: subMargin + 2),
                  //       hintText: "Select Birthday",
                  //       labelText: "Select Birthday",
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(buttonRadius),
                  //         borderSide: BorderSide(width: 2, color: primary),
                  //       ),
                  //       disabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(buttonRadius),
                  //         borderSide: BorderSide(width: 1, color: grey),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(buttonRadius),
                  //         borderSide: BorderSide(width: 1, color: primary),
                  //       ),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(buttonRadius),
                  //           borderSide: BorderSide(
                  //             width: 1,
                  //           )),
                  //       errorBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(buttonRadius),
                  //           borderSide:
                  //               BorderSide(width: 1.5, color: errorColor)),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(buttonRadius),
                  //           borderSide:
                  //               BorderSide(width: 2, color: errorColor)),
                  //       suffixIcon: Icon(
                  //         Icons.event_outlined,
                  //         color: primary.withOpacity(0.4),
                  //         size: 30,
                  //       )),
                  //   firstDate: DateTime(1900),
                  //   lastDate: DateTime.now(),
                  //   selectableDayPredicate: (date) {
                  //     if (date.weekday == 6 || date.weekday == 7) {
                  //       return true;
                  //     }
                  //     return true;
                  //   },
                  //   onChanged: (val) {
                  //     setState(() {
                  //       date = val;
                  //       dateError = false;
                  //       isloading = false;
                  //     });
                  //   },
                  //   validator: (val) {
                  //     setState(() => date = val);
                  //     return null;
                  //   },
                  //   onSaved: (val) {
                  //     setState(() {
                  //       date = val;
                  //       dateError = false;
                  //     });
                  //   },
                  // ),
                  SizedBox(
                    height: mainMargin,
                  ),
                  inputBox(
                    controller: description,
                    error: bioError,
                    minLine: 3,
                    errorText: "",
                    readonly: isloading,
                    inuptformat: [],
                    labelText: "Tell us a bit about yourself",
                    obscureText: false,
                    ispassword: false,
                    istextarea: true,
                    onchanged: () {
                      setState(() {
                        bioError = false;
                      });
                    },
                  ),
                ],
              ),
            )),
            SizedBox(
              height: mainMarginHalf,
            ),
            Container(
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Checkbox(
                            value: tnc,
                            onChanged: (value) {
                              setState(() {
                                tnc = !tnc;
                              });
                            },
                            activeColor: primary,
                          ),
                        ),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                    color: primary.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                    color: primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // single tapped
                                  },
                              ),
                              TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                    color: primary.withOpacity(0.6),
                                    fontSize: 16),
                              ),
                              TextSpan(
                                text: 'Privacy Policy ',
                                style: TextStyle(
                                    color: primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // long pressed
                                  },
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    left: -15,
                    width: MediaQuery.of(context).size.width - 3 * mainMargin,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mainMarginHalf,
            ),
            PrimaryButton(
              width: 200,
              fontsize: 18,
              borderRadius: 20,
              isloading: isloading,
              onPressed: () {
                setState(() {
                  isloading = true;
                });
                try {
                  if (_pickedImage != null) {
                    setState(() {
                      fnameErorr = name.text == "" ? true : false;

                      emailError = email.text == "" ? true : false;

                      passError = pass.text == "" ? true : false;

                      dateError = date == null ? true : false;
                      bioError = description.text == "" ? true : false;
                      isloading = false;
                    });
                  } else {
                    setState(() {
                      CustomSnackBar(
                              actionTile: "Close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              onPressed: () {},
                              title: "Please choose profile picture!")
                          .show(context);
                      isloading = false;
                    });
                  }
                } finally {
                  if (_pickedImage == null ||
                      fnameErorr ||
                      emailError ||
                      passError ||
                      dateError ||
                      bioError) {
                    isloading = false;

                    if (_pickedImage != null) {
                      CustomSnackBar(
                              onPressed: () {},
                              actionTile: "Close",
                              haserror: true,
                              isfloating: false,
                              scaffoldKey: scaffoldKey,
                              title: "Please fillup all details!")
                          .show(context);
                    }
                  } else {
                    if (!RegExp(
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
                        isloading = false;
                      });
                    } else if (!tnc) {
                      setState(() {
                        CustomSnackBar(
                                actionTile: "close",
                                haserror: true,
                                isfloating: false,
                                scaffoldKey: scaffoldKey,
                                onPressed: () {},
                                title:
                                    "Please accept Terms & Conditions and Privacy Policy!")
                            .show(context);
                        isloading = false;
                      });
                    } else {
                      setState(() {
                        isloading = true;
                      });
                      signup(context);
                    }
                  }
                }
              },
              title: "Continue",
              backgroundColor: primary,
              foregroundColor: white,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }

  _loadPicker(ImageSource source) async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _cropImage(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  void _cropImage(File picked) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
      maxWidth: 400,
    );

    if (croppedFile != null) {
      setState(() {
        File yourFile = File(croppedFile.path);
        _pickedImage = yourFile;
      });
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Pick from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _loadPicker(ImageSource.gallery);
              },
            ),
            ListTile(
              title: Text("Take a Picture"),
              onTap: () {
                Navigator.pop(context);
                _loadPicker(ImageSource.camera);
              },
            )
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(mainMargin))),
      ),
    );
  }
}
