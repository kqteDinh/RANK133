import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rank133/homeScreen.dart';
import 'package:rank133/provider/user.dart';
import 'Colors/appColors.dart';
import 'RegisterScreen.dart';
import 'models/https_exception.dart';
class LoginScreen extends StatefulWidget {
  static const routeName = '/logIn';
  @override
  _LoginScreenState createState() => _LoginScreenState();
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
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WelcomeScreen()),
            // );
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
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;

Map<String, String> _UserData = {
    'email': '',
    'password': '',
  };

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

Future<void> _saveForm() async {
    _form.currentState!.save();
    if (!_form.currentState!.validate()) {
      // Invalid!
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    print(_UserData.toString());
    try{
      await Provider.of<User>(context, listen: false)
        .logIn(_UserData['email'], _UserData['password']);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
    on HttpException catch(error){
      var errorMessage = 'Authentication failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'This email is already in use.';
      }
      else if(error.toString().contains('INVALID_EMAIL')){
        errorMessage = 'This is not a valid email address.';
      }
      else if(error.toString().contains('WEAK_PASSWORD')){
        errorMessage = 'This password is too weak';
      }
      else if(error.toString().contains('EMAIL_NOT_FOUND') || error.toString().contains('INVALID_PASSWORD')){
        errorMessage = 'Could not find a user with that email or password';
      }
      _showErrorDialog(errorMessage);
    } catch(error){
      const errorMessage = 'Could not authenticate you. Please try again later.';
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Form(
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
                              style: TextStyle(color: genericTextColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.email, color: iconsColor),
                                  hintText: 'Email'
                              ),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              focusNode: _emailFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              onSaved: (newValue) {
                                _UserData['email'] = newValue!;
                              },
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon: Icon(Icons.lock, color: iconsColor),
                                  hintText: 'Password'
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _UserData['password'] = value!;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      

                      Column(
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
                              onPressed: () {
                                _saveForm();
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
                      ),
                      SizedBox(height: 11),
                      buildRegisterButton(context),
                    ],
                  ),
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

