
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rank133/homeScreen.dart';
import 'package:rank133/loginScreen.dart';
import 'package:rank133/models/https_exception.dart';
import 'package:rank133/provider/user.dart';
import 'Colors/appColors.dart';

//import 'package:open_gym_app/models/http_exceptioin.dart';
//import 'package:open_gym_app/providers/User.dart';
//mport 'package:provider/provider.dart';


class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _registerScreenState createState() => _registerScreenState();
}

Widget buildLoginButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
       context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
  );
    },
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
                color: signUpTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          TextSpan(
              text: 'Sign In!',
              style: TextStyle(
                  color: signUpTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ],
      ),
    ),
  );
}

class _registerScreenState extends State<RegisterScreen> {
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Map<String, String> _UserData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
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
        .signup(
          _UserData['firstName'],
          _UserData['lastName'],
          _UserData['email'],
          _UserData['password']
        );
        if(_isLoading){
          // Navigator.of(context).pushNamed(TransitionScreen.routeName);
        }
        Navigator.of(context).pushNamed(HomeScreen.routeName);
    } on HttpException catch (error){
      var errorMessage = 'Authentication failed';
        if(error.toString().contains('EMAIL_EXISTS')){
          errorMessage = 'This email is already in use.';
        }
        else if(error.toString().contains('INVALID_EMAIL') || error.toString().contains('INVALID PASSWORD')){
          errorMessage = 'This is not a valid email address or password';
        }
        else if(error.toString().contains('WEAK_PASSWORD')){
            errorMessage = 'This password is too weak';
        }
        else if(error.toString().contains('EMAIL_NOT_FOUND')){
          errorMessage = 'Could not find a user with that email';
        }
        _showErrorDialog(errorMessage);
      } catch(error){
        const errorMessage= 'Could not authenticate you. Please try again later.';
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
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [screenBackgroundColor, screenBackgroundColor])),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Create Account',
                      style: TextStyle(
                          color: titleColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    // Flexible(
                    //   child: AuthCard(),
                    // ),
                    SizedBox(height: 55),
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
                      height: 55,
                      child: TextFormField(
                          keyboardType: TextInputType.name,
                          style: TextStyle(color: genericTextColor),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14),
                              prefixIcon: Icon(Icons.person, color: iconsColor),
                              hintText: 'First Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Needs input';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_lastNameFocusNode);
                          },
                          onSaved: (newValue) {
                            _UserData['firstName'] = newValue!;
                          }),
                    ),
                    SizedBox(height: 15),
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
                          height: 55,
                          child: TextFormField(
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: genericTextColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon:
                                      Icon(Icons.person, color: iconsColor),
                                  hintText: 'Last Name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Needs input';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _lastNameFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              onSaved: (newValue) {
                                _UserData['lastName'] = newValue!;
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
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
                          height: 55,
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: genericTextColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon:
                                      Icon(Icons.email, color: iconsColor),
                                  hintText: 'Email'),
                              textInputAction: TextInputAction.next,
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
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

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
                          height: 55,
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            style: TextStyle(color: genericTextColor),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14),
                                prefixIcon: Icon(Icons.lock, color: iconsColor),
                                hintText: 'Password'),
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFocusNode);
                            },
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
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
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
                          height: 55,
                          child: TextFormField(
                              obscureText: true,
                              style: TextStyle(color: genericTextColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(top: 14),
                                  prefixIcon:
                                      Icon(Icons.lock, color: iconsColor),
                                  hintText: 'Confirm Password'),
                              textInputAction: TextInputAction.next,
                              focusNode: _confirmPasswordFocusNode,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: LogInButtonColor,
                              onPrimary: LogInButtonTextColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _saveForm();
                            },
                            child: const Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    buildLoginButton(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

