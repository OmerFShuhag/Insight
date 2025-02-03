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
      return 'Enter a Valid  8 digit ID';
    }
    return null;
  }

  static String? validateField(String? value, String name) {
    if (name == 'GitHub Link') {
      return validateGitHubLink(value, name);
    } else if (name == 'Document Link') {
      return validateGoogleDocLink(value, name);
    } else if (name == 'Project Name' ||
        name == 'Description' ||
        name == 'Supervisor Name' ||
        name == 'Team Member Name') {
      if (value == null || value.trim().isEmpty) {
        return '$name cannot be empty';
      }
      final fieldRegex = RegExp(r'^[a-zA-Z0-9\s]+$');
      if (!fieldRegex.hasMatch(value)) {
        return 'Enter a valid $name';
      }
    } else if (name == 'Team Member ID') {
      if (value == null || value.trim().isEmpty) {
        return 'ID is Required';
      }
      final idRegex = RegExp(r'^[0-9]{16}$');
      if (!idRegex.hasMatch(value)) {
        return 'Enter a Valid 16 digit ID';
      }
    }
    return null;
  }

  static String? validateGitHubLink(String? value, String name) {
    if (value == null || value.trim().isEmpty) {
      return 'GitHub link is Required';
    }
    final githubLinkRegex =
        RegExp(r'^(https?:\/\/)?(www\.)?github\.com\/[A-Za-z0-9_-]+\/?$');
    if (!githubLinkRegex.hasMatch(value)) {
      return 'Enter a Valid GitHub link';
    }
    return null;
  }

  static String? validateGoogleDocLink(String? value, String name) {
    if (value == null || value.trim().isEmpty) {
      return 'Google Doc link is Required';
    }
    final googleDocLinkRegex = RegExp(
        r'^(https?:\/\/)?(docs\.google\.com\/document\/d\/[a-zA-Z0-9_-]+)(\/[^\/\s]*)?(\?[^\s]*)?(#.*)?$');
    if (!googleDocLinkRegex.hasMatch(value)) {
      return 'Enter a Valid Google Doc link';
    }
    return null;
  }
}
