part of 'extensions.dart';

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);

  ThemeData get theme => Theme.of(this);

  EdgeInsets get safeAreaPadding => MediaQuery.of(this).viewPadding;

  bool get hasActiveParentRoute => ModalRoute.of(this)?.canPop ?? false;

  void get hideKeyboard => FocusScope.of(this).unfocus();

  void showSnackbarMessage(String message) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  void showSnackbarCustom({required Widget content}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: content));
  }

  T? readOrNull<T>() {
    try {
      return read<T>();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
