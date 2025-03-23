import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';
import 'set_new_password_screen.dart';

class VarifyPinForgotPassword extends StatefulWidget {
  const VarifyPinForgotPassword({super.key});

  @override
  State<VarifyPinForgotPassword> createState() => _VarifyPinForgotPasswordState();
}

class _VarifyPinForgotPasswordState extends State<VarifyPinForgotPassword> {
  final TextEditingController _pinCodeTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                   controller: _pinCodeTEController,
                   appContext: context
               ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmitButton,
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

  void _onTapSubmitButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SetNewPassword()));
  }
  void _onTapSignInButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
  }

  @override
  void dispose() {
    _pinCodeTEController.dispose();
    super.dispose();
  }
}
