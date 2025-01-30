class Validators {
  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Name is Required';
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a Valid Email';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is Required';
    }
    // final passwordRegex = RegExp(
    //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    final passwordRegex = RegExp(r'^.{8}$');

    if (!passwordRegex.hasMatch(value)) {
      return 'Enter a Valid Password';
    }
    return null;
  }

  static String? validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateID(String value) {
    if (value.isEmpty) {
      return 'ID is Required';
    }
    final idRegex = RegExp(r'^[0-9]{8}$');
    if (!idRegex.hasMatch(value)) {
      return 'Enter a Valid ID';
    }
    return null;
  }
}
