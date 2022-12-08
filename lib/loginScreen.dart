// import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'package:rank133/homeScreen.dart';
// import 'package:rank133/provider/user.dart';
import 'package:rank133/fire_auth.dart';
import 'package:rank133/firebase_options.dart';
import 'package:rank133/validator.dart';
import 'Colors/appColors.dart';
import 'RegisterScreen.dart';
// import 'models/https_exception.dart';
class LoginScreen extends StatefulWidget {
  static const routeName = '/logIn';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


Widget buildRegisterButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account? ',
            style: TextStyle(
                color: genericButtonColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          TextSpan(
              text: 'Sign up!',
              style: TextStyle(
                  color: genericButtonColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ],
      ),
    ),
  );
}

Widget buildPassword() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: genericTextFieldBackgroundColor,
          border: Border.all(
            color: genericTextFieldOutlineColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        child: TextField(
          obscureText: true,
          style: TextStyle(color: genericTextColor),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.lock, color: iconsColor),
              hintText: 'Password'),
        ),
      )
    ],
  );
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    User? user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
    
    return firebaseApp;
  }

  Widget buildLogInButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 60,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: LogInButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              _emailFocusNode.unfocus();
              _passwordFocusNode.unfocus();

              if (_form.currentState!
                  .validate()) {
                setState(() {
                  _isLoading = true;
                });

                User? user = await FireAuth
                    .signInUsingEmailPassword(
                  email: _emailTextController.text,
                  password:
                      _passwordTextController.text,
                );

                setState(() {
                  _isLoading = false;
                });

                if (user != null) {
                  Navigator.of(context)
                      .pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(),
                    ),
                  );
                }
              }
            },
            child: Text(
              'Log In',
              style: TextStyle(
                color: LogInButtonTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorDialog(String message){
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text("An Error Occured!"),
      content: Text(message),
      actions: <Widget>[
        ElevatedButton(
          child: Text("Okay"),
          onPressed: (){
            Navigator.of(ctx).pop();
          },
        )
      ],
      ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done){
              return Form(
                key: _form,
                child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            screenBackgroundColor,
                            screenBackgroundColor
                          ])),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'RANKd Eats',
                              style: TextStyle(
                                  color: titleColor,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: genericTextFieldBackgroundColor,
                                    border: Border.all(
                                      color: genericTextFieldOutlineColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailTextController,
                                    style: TextStyle(color: genericTextColor),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(Icons.email, color: iconsColor),
                                        hintText: 'Email'
                                    ),
                                    validator: (value) => Validator.validateEmail(
                                      email: value,
                                    ),
                                    focusNode: _emailFocusNode,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode);
                                    }
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: genericTextFieldBackgroundColor,
                                    border: Border.all(
                                      color: genericTextFieldOutlineColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 60,
                                  child: TextFormField(
                                    obscureText: true,
                                    style: TextStyle(color: genericTextColor),
                                    controller: _passwordTextController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(Icons.lock, color: iconsColor),
                                        hintText: 'Password'
                                    ),
                                    validator: (value) => Validator.validatePassword(
                                      password: value,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            
                            buildLogInButton(context),
                            SizedBox(height: 11),
                            buildRegisterButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        )
    ),
    );
  }
}

