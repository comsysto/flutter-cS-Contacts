import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Contact {
  String firstName;
  String lastName;
  String name;
  String office;
  String mobile;
  String private;
  String email;
  DateTime birthday;
  bool birthdayNextWeek;
  bool birthdayToday;
  bool avatarInAssets;
  CircleAvatar avatar;
  File favourites;
  bool favourite = false;

  Contact(Map<String, dynamic> object, File favourites) {
    this.firstName = object['first-name'];
    this.lastName = object['last-name'];
    this.name = object['last-name'] + ' ' + object['first-name'];
    this.office = object['office'];
    this.mobile = object['mobile'];
    this.private = object['private'];
    this.email = object['e-mail'];
    this.birthday = createDateObject(object['birthday']);
    this.birthdayNextWeek =
        new DateTime.now().difference(this.birthday).inDays > -8;
    this.birthdayToday =
        new DateTime.now().difference(this.birthday).inDays > -1;
    this.avatarInAssets = object['avatar'];
    this.avatar = createAvatar(birthdayNextWeek);
    this.favourites = favourites;
    checkFavourite(this.favourites);
  }

  /// checks, if contacts name is in the favourites file
  Future<Null> checkFavourite(File favourites) async {
    String favouriteList = await favourites.readAsString();
    this.favourite = favouriteList.contains(this.name);
  }

  /// allows to add and remove names from the favourite list
  /// insert == true: name is added to favourite list
  /// insert == false: name is removed
  Future<Null> setFavourite(bool insert) async {
    this.favourite = insert;
    if (insert) {
      String contents = await favourites.readAsString();
      String newContents = contents + this.name + ',';
      await favourites.writeAsString(newContents);
    } else {
      String contents = await favourites.readAsString();
      String newContents = contents.replaceAll(name, '');
      await favourites.writeAsString(newContents);
    }
  }

  /// creates circleAvatar with either mixee, person icon or cake icon
  CircleAvatar createAvatar(bool birthdayNextWeek) {
    var avatarImage;
    if (avatarInAssets) {
      avatarImage = new Image.asset('assets/mixees/$email.png');
    } else {
      avatarImage = new Icon(Icons.person);
    }

    CircleAvatar avatar = new CircleAvatar(
      child: new Padding(
          padding: new EdgeInsets.all(4.0),
          child: birthdayNextWeek ? new Icon(Icons.cake) : avatarImage
      ),
    );

    return avatar;
  }

  /// reads the birthday from the contacts and turns it into a DateTime object
  /// the year depends on the current date which allows easy ordering for birthday list
  DateTime createDateObject(String dateString) {
    DateTime now = new DateTime.now();
    DateTime birthday;
    int year = 2016;
    List<String> parsedBirthday = dateString.split('.');
    parsedBirthday.removeLast();
    bool dateCorrect = false;
    while (!dateCorrect) {
      birthday = new DateTime(year, int.parse(parsedBirthday.last),
          int.parse(parsedBirthday.first), 23, 59, 59, 999);
      if (now.isBefore(birthday))
        dateCorrect = true;
      else
        year++;
    }
    return birthday;
  }
}
