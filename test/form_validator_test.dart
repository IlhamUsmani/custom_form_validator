import 'package:custom_form_validator/custom_form_validator.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('email validator', () {
    final validator = Validators.email();
    expect(validator('not-an-email'), isNotNull);
    expect(validator('test@mail.com'), isNull);
  });

  test('password validator', () {
    final validator = Validators.password(
      minLength: 8,
      hasUppercase: true,
      hasDigits: true,
    );
    expect(validator('abc'), isNotNull);
    expect(validator('Abc12345'), isNull);
  });
}
