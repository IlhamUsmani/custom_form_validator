import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:form_validator/form_validator.dart';



Future<void> main() async {
  // Set default locale (so messages are localized properly)
    // Initialize locale data
  await initializeDateFormatting('en', null);
  Intl.defaultLocale = 'en';

  print('--- Email Validation ---');
  final emailValidator = Validators.combine([
    Validators.required(message: 'Email is required'),
    Validators.email(message: 'Invalid email address'),
  ]);

  print(emailValidator(''));               // -> "Email is required"
  print(emailValidator('not-an-email'));   // -> "Invalid email address"
  print(emailValidator('hello@mail.com')); // -> null (valid)
  print(emailValidator('Hello@gmail.com'));
  print('\n--- Password Validation ---');
  final passwordValidator = Validators.password(
    minLength: 8,
    hasUppercase: true,
    hasDigits: true,
    message: 'Weak password',
  );

  print(passwordValidator('abc'));          // -> "Weak password"
  print(passwordValidator('Abc12345'));     // -> null (valid)

  print('\n--- CNIC Validation ---');
  final cnicValidator = Validators.cnic();
  print(cnicValidator('12345-1234567-1')); // -> null (valid format)
  print(cnicValidator('1234567'));         // -> "Invalid CNIC"

print('\n--- Name Validation ---');
final nameValidator = Validators.name();
print(nameValidator(''));           // "Invalid name"
print(nameValidator('A'));          // "Invalid name"
print(nameValidator('John Doe'));   // null (valid)

print('\n--- Credit Card Validation ---');
final ccValidator = Validators.creditCard();
print(ccValidator('1234 5678 9012 3456')); // "Invalid credit card number"
print(ccValidator('4111 1111 1111 1111')); // null (valid Visa test card)

print('\n--- Confirm Password ---');
final confirmValidator = Validators.confirmPassword('MySecret123');
print(confirmValidator('wrongpass')); // "Passwords do not match"
print(confirmValidator('MySecret123')); // null

print('\n--- URL Validation ---');
final urlValidator = Validators.url();
print(urlValidator('google.com'));       // null (valid)
print(urlValidator('https://flutter.dev')); // null (valid)
print(urlValidator('not_a_url'));        // "Invalid URL"

print('\n--- Date Validation ---');

 print('\n--- Date Validation ---');
final dateValidator = Validators.date(
 format: 'yyyy-MM-dd'
 
);

print(dateValidator('2025-09-25')); // -> null (valid, yyyy-MM-dd)
print(dateValidator('25-09-2025')); // -> null (valid, dd-MM-yyyy)
print(dateValidator('09/25/2025')); // -> "Invalid date"


print('\n--- Time Validation ---');
final timeValidator = Validators.time();
print(timeValidator('14:30')); // null (valid)
print(timeValidator('99:99')); // "Invalid time"




}
