import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';
import 'verify_pin_forget_password_screen.dart';

class VarifyEmailForgotPassword extends StatefulWidget {
  const VarifyEmailForgotPassword({super.key});

  @override
  State<VarifyEmailForgotPassword> createState() => _VarifyEmailForgotPasswordState();
}

class _VarifyEmailForgotPasswordState extends State<VarifyEmailForgotPassword> {
  final TextEditingController _emailTEController = TextEditingController();
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
                  'A 6 digit verification pin will send to your '
                      'email address',

                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmitButton,
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


  void _onTapSubmitButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const VarifyPinForgotPassword()));
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
