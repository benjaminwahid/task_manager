import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testproject/data/service/network_client.dart';
import 'package:testproject/data/utils/urls.dart';
import 'package:testproject/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:testproject/ui/widgets/screen_background.dart';
import 'package:testproject/ui/widgets/snack_bar_message.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _registrationInProgress = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child:Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,

                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      String email=value?.trim() ?? '';
                      if(EmailValidator.validate(email) == false){
                        return 'Enter a valid email';
                      }return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your first name';
                      }return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter your last name';
                      }return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value){
                        String phone = value?.trim() ?? '';
                        RegExp regExp =RegExp(r"^(?:\+?88|0088)?01[35-9]\d{8}$");
                        if(regExp.hasMatch(phone)==false) {
                          return 'Enter your valid phone number';

                      }return null;
                    },
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
                        )
                    ),


                    validator: (String? value){
                      String password = value?.trim() ?? '';
                      RegExp regExp =RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if(regExp.hasMatch(password)==false) {
                        return 'Enter valid password';

                      }return null;
                    },


                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _registrationInProgress==false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(

                      onPressed: _onTabSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white,),
                    ),
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
                              const TextSpan(text: "Already have an account! "),
                              TextSpan(text: 'Sign In',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )

          ),
        )

      ),
    );
  }

  void _onTabSubmitButton(){
    if(_formKey.currentState!.validate()){
      _registerUser();
    }
  }

  Future<void>_registerUser() async{
    _registrationInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody ={
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text
    };
    NetworkResponse response = await NetworkClient.postRequest(
        url:Urls.registerUrl,
        body: requestBody,
    );
    _registrationInProgress =false;
    setState(() {});
    if(response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, 'User registered successfully!');
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }

  }
  void _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTapSignUpButton(){
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

}
