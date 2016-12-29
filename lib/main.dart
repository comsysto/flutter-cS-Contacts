import 'package:flutter/material.dart';
import 'package:csContactsExt/components/app_container.dart';

/// Entry point for the application
void main() {
  /// runApp() renders the passed Widget
  /// can also be called twice, if need be
  runApp(new ContactApp());
}

/// StatelessWidget Contact App calls the build method
/// returns a new instance of the AppContainer class
class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AppContainer();
  }
}
