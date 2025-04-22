import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testproject/data/service/email_verify_and_otp_client.dart';


import '../widgets/screen_background.dart';
import 'login_screen.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final TextEditingController _newPasswordTEController = TextEditingController();
  final TextEditingController _confirmNewPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  Map<String, String>FormValues={'email':'', 'OTP':'','password':'', 'cpassword':''};
  bool _isLoading = false;
  
  @override
  void initState() {
    getStoreData();
    super.initState();
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
                  'Set New Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: _isObscure,
                  controller: _newPasswordTEController,
                  onChanged: (Textvalue){
                    InputOnChange('password', Textvalue);
                  },
                  decoration: InputDecoration(
                      hintText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed:(){
                          setState(() {
                            _isObscure =!_isObscure;
                          });
                        },
                      )
                  ),
                ),TextFormField(
                  obscureText: _isObscure,
                  controller: _confirmNewPasswordTEController,
                  onChanged: (Textvalue){
                    InputOnChange('cpassword', Textvalue);
                  },
                  decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                        onPressed:(){
                          setState(() {
                            _isObscure =!_isObscure;
                          });
                        },
                      )
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:() {
                    FormOnSubmit();
                    },
                  child: const Text('Confirm'),
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

  getStoreData() async{
    String? OTP = await ReadUserData("OTPVerification");
    String? Email = await ReadUserData("EmailVerification");
    InputOnChange('email', Email);
    InputOnChange('OTP', OTP);
  }

  InputOnChange(MapKey, Textvalue){
    setState(() {
      FormValues.update(MapKey, (value) => Textvalue);
    });
  }

  FormOnSubmit() async{
    if (FormValues['password']!.length==0){
      ErrorToast('Password Required!');
    }else if(FormValues['password'] != FormValues['cpassword']){
     ErrorToast('Confirm password should be same');
    }else{
      setState(() {
        _isLoading = true;
      });
      bool _reset = await SetPasswordRequest(FormValues);
      if(_reset == true){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
      }else{
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void _onTapSignInButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmNewPasswordTEController.dispose();
    super.dispose();
  }
}
