import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rank133/models/https_exception.dart';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
class User with ChangeNotifier{
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth{
    return token != null;
  }
  String? get token{
    if(_expiryDate !=null && _expiryDate!.isAfter(DateTime.now()) && _token != null ){
      return _token;
    }
    return null;
  }

  Future<void>signup(String? firstName, String? lastName, String? email, String? password) async {
    final url =  Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCfzq3rfEjiD1gY2rfV0ATg1SFknRgv7xw'
    );
    try{
      final response = await http.post(
        url,
        body: json.encode(
          {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'password': password,
            'returnSecureToken': true}
        )
      );
      final responseData = json.decode(response.body);
      print(responseData);
      print("Successfully Signed Up");
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),));
      notifyListeners();
    } catch (error){
        throw error;
      }
  }


  Future<void> logIn(String? email, String? password) async {
    final url =  Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCfzq3rfEjiD1gY2rfV0ATg1SFknRgv7xw'

    );
    try{
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true}
        )
      );
      final responseData = json.decode(response.body);
      print(responseData);
      print("Successfully Logged In");
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
    } catch (error){
        throw error;
      }
  }
}

