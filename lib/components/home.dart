import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csContactsExt/contact.dart';

import 'contact_list.dart';

/// StatefulWidget HomePage creates new HomePageState
/// receives method switchTheme() from parent
class HomePage extends StatefulWidget {
  var switchTheme;

  HomePage(switchTheme) {
    this.switchTheme = switchTheme;
  }

  @override
  State createState() => new HomePageState();
}

/// State HomePageState holds the state for the HomePage class
/// Responsible for displaying the splash screen on boot and
/// loading the contact list from the local file system
/// Additionally AppBar and BottomNavigationBar are build here
class HomePageState extends State<HomePage> {
  bool _displaySplash = true;
  List<Contact> _contactList = [];
  bool inSearchMode = false;
  InputValue _searchPattern = new InputValue();
  int _currentIndex = 0;

  /// colorChooseCard is an Element of the theme selection dialog
  /// Called by showThemeDialog
  /// returns a Card widget
  Card colorChooseCard(Color background, Color primaryColor, Color textColor,
      String title, int index) {
    return new Card(
      elevation: 1,
      color: background,
      child: new ListItem(
          leading: new CircleAvatar(backgroundColor: primaryColor),
          title: new Text(
            title,
            style: new TextStyle(color: textColor),
          ),
          onTap: () => Navigator.pop(context, () {
                config.switchTheme(index);
              }),
          trailing: primaryColor == Theme.of(context).primaryColor
              ? new Icon(Icons.check)
              : null),
    );
  }

  /// showThemeDialog builds the theme selection dialog
  /// called by the onTap method of the bottomNavigationBar
  void showThemeDialog({BuildContext context}) {
    showDialog(
      context: context,
      child: new SimpleDialog(
        title: new Text('Which color do you like?'),
        children: <Widget>[
          colorChooseCard(
              Colors.white, Colors.blue[500], Colors.black, 'Blue', 0),
          colorChooseCard(
              Colors.white, Colors.green[500], Colors.black, 'Green', 2),
          colorChooseCard(
              Colors.white, Colors.red[500], Colors.black, 'Red', 4),
          colorChooseCard(
              Colors.grey[800], Colors.blue[800], Colors.white, 'Dark Blue', 1),
          colorChooseCard(Colors.grey[800], Colors.green[800], Colors.white,
              'Dark Green', 3),
          colorChooseCard(
              Colors.grey[800], Colors.red[800], Colors.white, 'Dark Red', 5),
        ],
      ),
    ).then((dynamic value) {
      if (value != null) {
        value();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// _loadFavourites gets the list of favourites from the local file directory
    /// asynchronous
    /// returns a file object
    Future<File> _loadFavourites() async {
      String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
      File file = new File('$dir/favourites.txt');

      /// if favourites.txt doesn't exist, create it
      if (!await file.exists()) {
        await file.create();
      }

      return file;
    }

    /// _convert parses contacts, given in a string and ads them to the state
    /// asynchronous
    Future<Null> _convert(dataAsString) async {
      List<Object> objectList = JSON.decode(dataAsString);
      List<Contact> contactList = [];
      _loadFavourites().then((File favourites) {
        objectList.forEach((object) => contactList
            .add(new Contact(object, favourites))); //todo error-checking?

        setState(() {
          _contactList = contactList;
        });

        /// create timer to remove splash screen
        new Timer(const Duration(milliseconds: 2000), () {
          setState(() {
            _displaySplash = false;
          });
        });
      });
    }

    /// _loadContactlist loads data from contact file and calls _convert on the response
    void _loadContactList() {
      rootBundle
          .loadString('assets/contacts.json')
          .then((data) => _convert(data));
    }

    /// returns an AppBar widget depending on inSearchMode
    AppBar _appBar() {
      /// standard AppBar without input as title
      AppBar normalAppBar = new AppBar(
        title: new Text('comSysto Contacts'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () => setState(() {
                    inSearchMode = true;
                  })),
        ],
      );

      /// AppBar for searching through list of contacts
      AppBar searchAppBar = new AppBar(
        leading: new Icon(Icons.search),
        title: new Input(
            hintText: 'Search',
            value: _searchPattern,
            onChanged: (input) => setState(() {
                  _searchPattern = input;
                })),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            tooltip: 'Cancel',
            onPressed: () => setState(() {
                  inSearchMode = false;
                  _searchPattern = new InputValue();
                }),
          ),
        ],
      );

      return inSearchMode ? searchAppBar : normalAppBar;
    }

    /// returns BottomNavigationBar for navigating to other pages
    BottomNavigationBar _botNavBar = new BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: Theme.of(context).primaryColor,
      labels: <DestinationLabel>[
        new DestinationLabel(
          icon: new Icon(Icons.person),
          title: new Text('Contacts'),
        ),
        new DestinationLabel(
          icon: new Icon(Icons.star),
          title: new Text('Favourites'),
        ),
        new DestinationLabel(
          icon: new Icon(Icons.cake),
          title: new Text('Birthdays'),
        ),
        new DestinationLabel(
          icon: new Icon(Icons.format_paint),
          title: new Text('Themes'),
        )
      ],

      /// onTap is responsible for switching the displayed
      /// body between Contacts/Favourites/Birthdays
      /// also responsible to call showThemeDialog
      onTap: (int index) {
        if (index != 3) {
          setState(() {
            _currentIndex = index;
          });
        } else
          showThemeDialog(context: context);
      },
    );

    /// Either calls _loadFile and returns splash screen or
    /// instantiates and returns the body with the loaded contactList
    if (_displaySplash) {
      _loadContactList();
      return new Container(
        decoration: new BoxDecoration(
          backgroundColor: new Color.fromRGBO(31, 155, 206, 1.0),
        ),
        child: new Center(
          child: new Padding(
            padding: new EdgeInsets.all(50.0),
            child: new Image.asset('assets/logo-name.png'),
          ),
        ),
      );
    } else {
      return new Scaffold(
        appBar: _appBar(),
        body: new ContactList(_contactList, _searchPattern.text, _currentIndex),
        bottomNavigationBar: _botNavBar,
      );
    }
  }
}
