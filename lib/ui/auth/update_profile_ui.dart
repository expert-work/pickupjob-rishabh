import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pickupjob/models/models.dart';
import 'package:pickupjob/ui/components/components.dart';
import 'package:pickupjob/helpers/helpers.dart';
import 'package:pickupjob/controllers/controllers.dart';
import 'package:pickupjob/ui/auth/auth.dart';

class UpdateProfileUI extends StatelessWidget {
  UpdateProfileUI({Key? key}) : super(key: key);

  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    //print('user.name: ' + user?.value?.name);
    authController.firstNameController.text =
        authController.firestoreUser.value!.firstName;
    authController.lastNameController.text =
        authController.firestoreUser.value!.lastName;

    authController.emailController.text =
        authController.firestoreUser.value!.email;
    return Scaffold(
      appBar: AppBar(title: Text('auth.updateProfileTitle'.tr)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LogoGraphicHeader(),
                  const SizedBox(height: 48.0),
                  FormInputFieldWithIcon(
                    controller: authController.firstNameController,
                    iconPrefix: Icons.person,
                    labelText: 'First Name',
                    validator: Validator().name,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.firstNameController.text = value!,
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: authController.lastNameController,
                    iconPrefix: Icons.person,
                    labelText: 'Last Name',
                    validator: Validator().name,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.lastNameController.text = value!,
                  ),
                  FormVerticalSpace(),
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    labelText: 'auth.emailFormField'.tr,
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                  ),
                  FormVerticalSpace(),
                  PrimaryButton(
                      labelText: 'auth.updateUser'.tr,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          // UserModel _updatedUser = UserModel(
                          //     uid: authController.firestoreUser.value!.uid,
                          //     name: authController.nameController.text,
                          //     email: authController.emailController.text,
                          //     photoUrl:
                          //         authController.firestoreUser.value!.photoUrl,
                          //     isProfileCompleted: authController
                          //         .firestoreUser.value!.isProfileCompleted,
                          //     userType:
                          //         authController.firestoreUser.value!.userType);
                          // _updateUserConfirm(context, _updatedUser,
                          //     authController.firestoreUser.value!.email,
                          //     userType:
                          //         authController.firestoreUser.value!.userType,
                          //     isProfileCompleted: authController
                          //         .firestoreUser.value!.isProfileCompleted);
                        }
                      }),
                  FormVerticalSpace(),
                  LabelButton(
                    labelText: 'auth.resetPasswordLabelButton'.tr,
                    onPressed: () => Get.to(ResetPasswordUI()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserConfirm(
      BuildContext context, UserModel updatedUser, String oldEmail,
      {required bool isProfileCompleted, required String userType}) async {
    final AuthController authController = AuthController.to;
    final TextEditingController _password = new TextEditingController();
    return Get.dialog(
      AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          'auth.enterPassword'.tr,
        ),
        content: FormInputFieldWithIcon(
          controller: _password,
          iconPrefix: Icons.lock,
          labelText: 'auth.passwordFormField'.tr,
          validator: (value) {
            String pattern = r'^.{6,}$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(value!))
              return 'validator.password'.tr;
            else
              return null;
          },
          obscureText: true,
          onChanged: (value) => null,
          onSaved: (value) => _password.text = value!,
          maxLines: 1,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('auth.cancel'.tr.toUpperCase()),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('auth.submit'.tr.toUpperCase()),
            onPressed: () async {
              Get.back();
              await authController.updateUser(
                  context, updatedUser, oldEmail, _password.text);
            },
          )
        ],
      ),
    );
  }
}
