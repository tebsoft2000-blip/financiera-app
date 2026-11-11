import 'package:get/get.dart';

class LoginState {
  final otpId = RxnString();

  bool get otpStep => otpId.value != null;
}
