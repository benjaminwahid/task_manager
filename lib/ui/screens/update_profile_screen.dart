import 'dart:convert';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testproject/data/models/user_model.dart';
import 'package:testproject/data/service/network_client.dart';
import 'package:testproject/ui/controllers/auth_controller.dart';
import 'package:testproject/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:testproject/ui/widgets/snack_bar_message.dart';
import 'package:testproject/ui/widgets/tm_app_bar.dart';
import 'package:testproject/ui/widgets/screen_background.dart';

import '../../data/utils/urls.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel userModel =AuthController.userModel!;
    _emailTEController.text = userModel.email;
    _firstNameTEController.text = userModel.firstName;
    _lastNameTEController.text = userModel.lastName;
    _mobileTEController.text = userModel.mobile;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TmAppBar(
        fromProfileScreen: true,
      ),
      body: ScreenBackground(
          child: SingleChildScrollView(

        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildPhotoPickerWidget(),



                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
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
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    controller: _passwordTEController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
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
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      )),
    );
  }

  void _onTapSubmitButton(){
    if (_formKey.currentState!.validate()){
      _updateProfile();

    }
  }
  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody={
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty){
      requestBody['password']= _passwordTEController.text;
    }
    if (_pickedImage != null){
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody['photo'] = encodedImage;
    }
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.updateProfileUrl,
        body: requestBody,
    );
    _updateProfileInProgress = false;
    setState(() {});
    if(response.isSuccess){
      _passwordTEController.clear();
      showSnackBarMessage(context, 'User data updated successfully');
      AuthController.saveUserInformation(
        AuthController.token.toString(),
        UserModel.fromJson(response.data ?? requestBody),
      );
setState(() {

});
      if (mounted) {
        Navigator.pop(context); // Close the current UpdateProfileScreen
        Navigator.pushReplacement(
          context,
          //jj
          MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
        );
        showSnackBarMessage(context, 'User data updated successfully');
      }

    }else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,

      child: Container(

        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Row(
          children: [

            Container(
              height: 50,
              width: 80,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: const Center(
                  child: Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _pickedImage?.name ?? 'Select your photo',
                style:  const TextStyle(
                   overflow: TextOverflow.ellipsis,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapPhotoPicker() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }


}
