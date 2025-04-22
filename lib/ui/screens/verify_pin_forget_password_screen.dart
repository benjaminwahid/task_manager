import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../data/service/email_verify_and_otp_client.dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';
import 'set_new_password_screen.dart';

class VerifyPinForgotPassword extends StatefulWidget {
  const VerifyPinForgotPassword({super.key});

  @override
  State<VerifyPinForgotPassword> createState() => _VerifyPinForgotPasswordState();
}

class _VerifyPinForgotPasswordState extends State<VerifyPinForgotPassword> {
  final TextEditingController _pinCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> FormValues = {'otp':''};
  bool _isLoading = false;

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
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin will send to your email address',

                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
               PinCodeTextField(
                   length: 6,
                   obscureText: false,
                   animationType: AnimationType.fade,
                   keyboardType: TextInputType.number,
                   pinTheme: PinTheme(
                     shape: PinCodeFieldShape.box,
                     borderRadius: BorderRadius.circular(8),
                     fieldHeight: 50,
                     fieldWidth: 50,
                     activeFillColor: Colors.white,
                     selectedFillColor: Colors.white,
                     inactiveFillColor: Colors.white,
                     inactiveColor: Colors.grey,
                   ),
                   animationDuration: const Duration(milliseconds: 300),
                   backgroundColor: Colors.transparent,
                   enableActiveFill: true,
                   // controller: _pinCodeTEController,
                   appContext: context,
                   onCompleted: (v){

                   },
                 onChanged: (value){
                     InputOnChange("otp", value);
                 },
               ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    FormOnSubmit();
                  },
                  child: const Text('Verify'),
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


  void _onTapSignInButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }

   InputOnChange(MapKey, TextValues) async {
    setState(() {
      FormValues.update(MapKey, (value) => TextValues);
    });
  }

  FormOnSubmit() async{
    if(FormValues['otp']!.length!=6){
      ErrorToast('PIN Required !');
    }
    else{
      setState(() {_isLoading=true;});
      String? emailAddress=await ReadUserData('EmailVerification');
      bool res=await VerifyOTPRequest(emailAddress,FormValues['otp']);
      if(res==true){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SetNewPassword()));
      }
      else{
        setState(() {_isLoading=false;});
      }
    }
  }

  @override
  void dispose() {
    _pinCodeTEController.dispose();
    super.dispose();
  }


}
