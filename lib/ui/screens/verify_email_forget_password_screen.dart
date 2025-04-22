import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../data/models/login_model.dart';
import '../../data/service/email_verify_and_otp_client.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import 'login_screen.dart';
import 'main_bottom_nav_screen.dart';
import 'verify_pin_forget_password_screen.dart';

class VerifyEmailForgotPassword extends StatefulWidget {
  const VerifyEmailForgotPassword({super.key});

  @override
  State<VerifyEmailForgotPassword> createState() => _VerifyEmailForgotPasswordState();
}

class _VerifyEmailForgotPasswordState extends State<VerifyEmailForgotPassword> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Map<String, String> FormValues = {"email":""};

  InputOnChange(MapKey, Textvalue){
    setState(() {
      FormValues.update(MapKey, (value) => Textvalue);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Your email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin will send to your '
                      'email address',

                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                TextFormField(
                  onChanged: (Textvalue){
                  InputOnChange("email",Textvalue);},
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,

                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    FormOnSubmit();
                    },
                  child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white,),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "have an account? "),
                            TextSpan(text: 'Sign In',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
                            ),
                          ],
                        ),
                      ),
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


  FormOnSubmit() async{
    if(FormValues['email']!.length==0){
      ErrorToast('Email Required !');
    }
    else{
      setState((){_isLoading=true;});
      bool res=await VerifyEmailRequest(FormValues['email']);
      if(res==true){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const VerifyPinForgotPassword() ));
      }
      else{
        setState(() {_isLoading=false;});
      }
    }
  }


  void _onTapSignInButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
