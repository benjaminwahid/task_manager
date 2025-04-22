import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testproject/data/models/login_model.dart';
import 'package:testproject/data/service/network_client.dart';
import 'package:testproject/data/utils/urls.dart';
import 'package:testproject/ui/controllers/auth_controller.dart';
import 'package:testproject/ui/screens/sign_up_screen.dart';
import 'package:testproject/ui/screens/verify_email_forget_password_screen.dart';
import 'package:testproject/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:testproject/ui/widgets/screen_background.dart';
import 'package:testproject/ui/widgets/snack_bar_message.dart';
import 'main_bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Get Started With',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(

                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  validator: (String? value){
                    if (value == null || value.isEmpty){
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: _isObscure,
                  controller: _passwordTEController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _loginInProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: _onTapSignInButton,
                    child: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPasswordButton,
                        child: const Text('Forget Password'),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUpButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    _loginInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);

      AuthController.saveUserInformation(loginModel.token, loginModel.user);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainBottomNavScreen(),
        ),
        (protected) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const VerifyEmailForgotPassword(),
        ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SignUpScreen()
        ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
