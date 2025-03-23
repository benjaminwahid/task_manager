import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


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
                  onPressed: _onTapSubmitButton,
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
  void _onTapSubmitButton(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
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
