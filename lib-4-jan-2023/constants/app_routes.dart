import 'package:get/get.dart';
import 'package:pickupjob/ui/ui.dart';
import 'package:pickupjob/ui/auth/auth.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    //GetPage(name: '/', page: () => MapScreen()),
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup-user', page: () => SignUpUserUI()),
    GetPage(name: '/signup-driver', page: () => SignUpDriverUI()),
    // GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
  ];
}
