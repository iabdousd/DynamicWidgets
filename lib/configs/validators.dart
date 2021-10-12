import 'package:get/get.dart';

class InputValidators {
  static String? Function(String?) get isNumberValdiator => (val) {
        final parsed = double.tryParse(val ?? '');

        if (val != null && val.isNotEmpty && parsed != null) return null;

        if (val != null && parsed == null) return 'Not a number';

        return 'Required';
      };

  static String? Function(String?) get isDimensionValdiator => (val) {
        final parsed = double.tryParse(val ?? '');

        if (val != null && (val.isEmpty || parsed != null)) {
          // val.contains('%') ||
          return null;
        }

        return 'Not a number';
      };

  static String? Function(String?) get textValdiator => (val) {
        if (val != null && !(val.isBlank ?? true)) return null;

        return 'Required';
      };

  static String? Function(String?) get imageURLValdiator => (val) {
        if (val != null && val.isURL) return null;

        if (val != null && !val.isURL) return 'Invalid';

        return 'Required';
      };
}
