import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

var BaseURL = "http://35.73.30.144:2005/api/v1";
var RequestHeader = {"Content-Type": "application/json"};

const colorRed = Color.fromRGBO(231, 28, 36, 1);
const colorDark = Color.fromRGBO(136, 28, 32, 1);
const colorGreen = Color.fromRGBO(33, 191, 115, 1);
const colorBlue = Color.fromRGBO(52, 152, 219, 1.0);
const colorOrange = Color.fromRGBO(230, 126, 34, 1.0);
const colorWhite = Color.fromRGBO(255, 255, 255, 1.0);
const colorDarkBlue = Color.fromRGBO(44, 62, 80, 1.0);
const colorLightGray = Color.fromRGBO(135, 142, 150, 1.0);
const colorLight = Color.fromRGBO(211, 211, 211, 1.0);

Future<void> WriteUserData(UserData) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', UserData['token']);
  await prefs.setString('email', UserData['data']['email']);
  await prefs.setString('firstName', UserData['data']['firstName']);
  await prefs.setString('lastName', UserData['data']['lastName']);
  await prefs.setString('mobile', UserData['data']['mobile']);
  await prefs.setString('photo', UserData['data']['photo']);
}

Future<void> WriteEmailVerification(email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('EmailVerification', email);
}

Future<void> WriteOTPVerification(OTP) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('OTPVerification', OTP);
}

Future<String?> ReadUserData(Key) async {
  final prefs = await SharedPreferences.getInstance();
  String? mydata = await prefs.getString(Key);
  return mydata;
}

Future<bool> VerifyEmailRequest(email) async {
  var URL = Uri.parse("$BaseURL/RecoverVerifyEmail/$email");
  var response = await http.get(URL, headers: RequestHeader);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    await WriteEmailVerification(email);
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> VerifyOTPRequest(email, otp) async {
  var URL = Uri.parse("$BaseURL/RecoverVerifyOtp/$email/$otp");
  var response = await http.get(URL, headers: RequestHeader);
  var ResultCode = response.statusCode;
  var ResultBody = json.decode(response.body);
  if (ResultCode == 200 && ResultBody['status'] == "success") {
    await WriteOTPVerification(otp);
    SuccessToast("Request Success");
    return true;
  } else {
    ErrorToast("Request fail ! try again");
    return false;
  }
}

Future<bool> SetPasswordRequest(FormValues) async {
  var URL = Uri.parse("$BaseURL/RecoverResetPassword");
  var PostBody = jsonEncode(FormValues);

  var response= await http.post(URL, headers: RequestHeader, body:  PostBody);

  var ResultCode = response.statusCode;
  var ResultBody = jsonDecode(response.body);

  if (ResultCode == 200 && ResultBody['status'] == "success"){
    SuccessToast('Request Success');
    return true;
  }else{
    ErrorToast("Request fail! Please try again" );
    return false;
  }

}

void SuccessToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: colorGreen,
      textColor: colorWhite,
      fontSize: 16.0);
}

void ErrorToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: colorRed,
      textColor: colorWhite,
      fontSize: 16.0);
}
