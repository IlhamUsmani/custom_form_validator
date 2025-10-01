// Flutter/Dart Form Validator Package
// File: lib/form_validator.dart

library form_validator;

import 'package:intl/intl.dart';




/// Simple localization wrapper using `intl` package.
/// Consumers should initialize locale (Intl.defaultLocale) and provide
/// ARB/intl messages when publishing.
class FVMessages {
  static String required() => Intl.message('This field is required', name: 'required');
  static String invalidEmail() => Intl.message('Invalid email address', name: 'invalidEmail');
  static String invalidPhone() => Intl.message('Invalid phone number', name: 'invalidPhone');
  static String weakPassword() => Intl.message('Password is too weak', name: 'weakPassword');
  static String invalidCnic() => Intl.message('Invalid CNIC', name: 'invalidCnic');
  static String tooShort(int min) => Intl.message('Should be at least $min characters', name: 'tooShort', args: [min]);
  static String tooLong(int max) => Intl.message('Should be at most $max characters', name: 'tooLong', args: [max]);
   static String passwordTooShort(int minLength) =>
      'Password must be at least $minLength characters long';

  static String passwordNeedsUppercase() =>
      'Password must contain at least one uppercase letter';

  static String passwordNeedsLowercase() =>
      'Password must contain at least one lowercase letter';

  static String passwordNeedsDigit() =>
      'Password must contain at least one number';

  static String passwordNeedsSpecialChar() =>
      'Password must contain at least one special character';

        static String invalidDate() => 'Invalid date';
          static String invalidTime() => 'Invalid time';

}

typedef Validator = String? Function(String? value);

class Validators {
  /// Required field
  static Validator required({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return message ?? FVMessages.required();
      return null;
    };
  }

  /// Min length
  static Validator minLength(int min, {String? message}) {
    return (String? value) {
      if (value == null || value.length < min) return message ?? FVMessages.tooShort(min);
      return null;
    };
  }

  /// Max length
  static Validator maxLength(int max, {String? message}) {
    return (String? value) {
      if (value != null && value.length > max) return message ?? FVMessages.tooLong(max);
      return null;
    };
  }

  /// Regex validator
  static Validator pattern(String pattern, {String? message, bool caseSensitive = true}) {
    final reg = RegExp(pattern, caseSensitive: caseSensitive);
    return (String? value) {
      if (value == null || !reg.hasMatch(value)) return message ?? FVMessages.invalidCnic();
      return null;
    };
  }
  

/// Name validator (letters and spaces only, at least 2 chars)
static Validator name({String? message}) {
  return pattern(
    r"^[a-zA-Z\s]{2,}$",
    message: message ?? 'Invalid name',
  );
}


  /// Email validator (case-insensitive)
static Validator email({String? message}) {
  final reg = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
  return (String? value) {
    if (value == null || value.isEmpty) return null; // let required handle emptiness

    final normalized = value.toLowerCase().trim();

    if (!reg.hasMatch(normalized)) return message ?? FVMessages.invalidEmail();
    return null;
  };
}


 static Validator phoneSync({String? message, int minDigits = 7, int maxDigits = 15}) {
  return (String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final cleaned = value.replaceAll(RegExp(r'[\\s\\-\\(\\)\\+]'), '');
    if (!RegExp(r'^\\d+\$').hasMatch(cleaned)) return message ?? FVMessages.invalidPhone();
    if (cleaned.length < minDigits || cleaned.length > maxDigits) {
      return message ?? FVMessages.invalidPhone();
    }
    return null;
  };
}



  /// Password strength validator
  static Validator password({
    int minLength = 8,
    bool hasUppercase = false,
    bool hasLowercase = false,
    bool hasDigits = false,
    bool hasSpecialChars = false,
    String? message,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null; // let "required" handle empty case
      }

      final password = value.trim();

      if (password.length < minLength) {
        return message ?? FVMessages.passwordTooShort(minLength);
      }
      if (hasUppercase && !RegExp(r'[A-Z]').hasMatch(password)) {
        return message ?? FVMessages.passwordNeedsUppercase();
      }
      if (hasLowercase && !RegExp(r'[a-z]').hasMatch(password)) {
        return message ?? FVMessages.passwordNeedsLowercase();
      }
      if (hasDigits && !RegExp(r'[0-9]').hasMatch(password)) {
        return message ?? FVMessages.passwordNeedsDigit();
      }
      if (hasSpecialChars && !RegExp(r'[!@#\$&*~.,;:?_\-]').hasMatch(password)) {
        return message ?? FVMessages.passwordNeedsSpecialChar();
      }

      return null; // valid
    };
  }

  /// Password strength validator
  /// Options: requireUpper, requireDigits, requireSpecial, minLength
  static Validator passwordStrength({
    int minLength = 8,
    bool requireUpper = true,
    bool requireDigits = true,
    bool requireSpecial = true,
    String? message,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null; // let required handle emptiness
      if (value.length < minLength) return message ?? FVMessages.weakPassword();
      if (requireUpper && !RegExp(r'[A-Z]').hasMatch(value)) return message ?? FVMessages.weakPassword();
      if (requireDigits && !RegExp(r'\d').hasMatch(value)) return message ?? FVMessages.weakPassword();
      if (requireSpecial && !RegExp(r'[!@#\$%\^&*(),.?":{}|<>]').hasMatch(value)) return message ?? FVMessages.weakPassword();
      return null;
    };
  }

  /// Pakistan CNIC validator (simple): 13 digits OR formatted 5-7-1 (xxxxx-xxxxxxx-x)
 /// CNIC validator (Pakistan specific: 5-7-1 format)
static Validator cnic({String message = 'Invalid CNIC'}) {
  // Allows formats: 12345-1234567-1 OR 1234512345671
  final cnicRegex = RegExp(r'^\d{5}-?\d{7}-?\d{1}$');
  return (String? value) {
    if (value == null || !cnicRegex.hasMatch(value)) {
      return message;
    }
    return null;
  };
}

/// Credit card validator (Luhn algorithm)
static Validator creditCard({String? message}) {
  return (String? value) {
    if (value == null) return message ?? 'Invalid credit card number';
    final sanitized = value.replaceAll(RegExp(r'\s+|-'), '');
    if (sanitized.isEmpty || !RegExp(r'^\d{13,19}$').hasMatch(sanitized)) {
      return message ?? 'Invalid credit card number';
    }

    if (!_luhnCheck(sanitized)) {
      return message ?? 'Invalid credit card number';
    }
    return null;
  };
}

/// Internal: Luhn algorithm
static bool _luhnCheck(String number) {
  int sum = 0;
  bool alternate = false;

  for (int i = number.length - 1; i >= 0; i--) {
    int digit = int.parse(number[i]);

    if (alternate) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }

    sum += digit;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}


/// Confirm password validator
static Validator confirmPassword(String originalPassword, {String? message}) {
  return (String? value) {
    if (value == null || value.isEmpty) return null; // let "required" handle emptiness
    if (value != originalPassword) {
      return message ?? 'Passwords do not match';
    }
    return null;
  };
}

/// URL / Website validator
static Validator url({String? message}) {
  final reg = RegExp(
    r'^(https?:\/\/)?' // protocol
    r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain
    r'(\/[^\s]*)?$', // path
    caseSensitive: false,
  );
  return (String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!reg.hasMatch(value.trim())) {
      return message ?? 'Invalid URL';
    }
    return null;
  };
}


/// Date validator with multi-format support
static Validator date({String format = 'yyyy-MM-dd', String? message}) {
  return (String? value) {
    if (value == null || value.isEmpty) return message ?? FVMessages.invalidDate();
    try {
      final formatter = DateFormat(format);
      formatter.parseStrict(value); // just validate
      return null; // ✅ return null if valid
    } catch (_) {
      return message ?? FVMessages.invalidDate();
    }
  };
}



/// Time validator (expects HH:mm in 24h format by default)
/// Time validator
static Validator time({String format = 'HH:mm', String? message}) {
  return (String? value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? FVMessages.invalidTime();
    }
    try {
      DateFormat(format).parseStrict(value.trim()); // throws if invalid
      return null; // ✅ valid
    } catch (_) {
      return message ?? FVMessages.invalidTime();
    }
  };
}



  /// Composite: combine multiple validators; returns first non-null error message.
  static Validator combine(List<Validator> validators) {
    return (String? value) {
      for (final v in validators) {
        final res = v(value);
        if (res != null) return res;
      }
      return null;
    };
  }
}


/// Convenience extension to apply validators to form fields (string inputs)
extension ValidateString on String? {
  String? validate(Validator validator) => validator(this);
}

