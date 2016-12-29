import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csContactsExt/components/home.dart';

/// StatefulWidget AppContainer creates new AppContainerState
class AppContainer extends StatefulWidget {
  @override
  State createState() => new AppContainerState();
}

/// State AppContainerState holds the state for the AppContainer class
/// Mainly responsible for retrieving the previously saved theme from
/// the local file directory
class AppContainerState extends State<AppContainer> {
  int _themeIndex = 0;

  /// initState() is called only once, when the state is initiated
  /// must call super.initState()
  @override
  void initState() {
    super.initState();
    _readTheme().then((int value) {
      setState(() {
        _themeIndex = value;
      });
    });
  }

  /// _getLocalFile() gets the ApplicationDocumentsDirectories path
  /// asynchronous
  /// returns a file object
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    return new File('$dir/theme.txt');
  }

  /// _readTheme() reads file object as string and parses it to int
  /// asynchronous
  /// returns parsed int or 0, if file does not exist
  Future<int> _readTheme() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  /// switchTheme() updates the state to new theme
  /// Saves new theme to local file
  /// asynchronous
  Future<Null> switchTheme(int index) async {
    setState(() {
      _themeIndex = index;
    });
    // write the variable as a string to the file
    await (await _getLocalFile()).writeAsString('$_themeIndex');
  }

  /// themeList is a list of ThemeData the user can choose from
  final List<ThemeData> themeList = [];
  final _lightBlue = new ThemeData(
    primaryColor: Colors.blue[500],
    brightness: Brightness.light,
  );
  final _darkBlue = new ThemeData(
    primaryColor: Colors.blue[800],
    brightness: Brightness.dark,
  );
  final _lightGreen = new ThemeData(
    primaryColor: Colors.green[500],
    brightness: Brightness.light,
  );
  final _darkGreen = new ThemeData(
    primaryColor: Colors.green[800],
    brightness: Brightness.dark,
  );
  final _lightRed = new ThemeData(
    primaryColor: Colors.red[500],
    brightness: Brightness.light,
  );
  final _darkRed = new ThemeData(
    primaryColor: Colors.red[800],
    brightness: Brightness.dark,
  );

  /// builds the MaterialApp as a container for our app
  @override
  Widget build(BuildContext context) {
    /// add themeData to themeList
    themeList.add(_lightBlue);
    themeList.add(_darkBlue);
    themeList.add(_lightGreen);
    themeList.add(_darkGreen);
    themeList.add(_lightRed);
    themeList.add(_darkRed);

    return new MaterialApp(
      theme: themeList[_themeIndex],
      home: new HomePage(switchTheme),
    );
  }
}
