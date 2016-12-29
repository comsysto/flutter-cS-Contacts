import 'package:flutter/material.dart';
import 'package:csContactsExt/contact.dart';

import 'birth_list_element.dart';
import 'contact_list_element.dart';
import 'fav_list_element.dart';

/// StatelessWidget ContactList represents the body of the application
/// responsible for switching between lists and filtering for search pattern
/// returns a new Block widget
class ContactList extends StatelessWidget {
  List<Contact> contactList;
  String searchPattern;
  int currentIndex;

  ContactList(
      List<Contact> contactList, String searchPattern, int currentIndex) {
    this.contactList = contactList;
    this.searchPattern = searchPattern;
    this.currentIndex = currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listElements = [];

    /// sorting of the contactList depending on the currentIndex
    if (currentIndex == 2) {
      contactList.sort((a, b) => a.birthday.compareTo(b.birthday));
    } else {
      contactList.sort((a, b) => a.lastName.compareTo(b.lastName));
    }

    /// Create Elements from ContactList
    for (Contact contact in contactList) {
      /// check, if contacts name contains the searchPattern
      if (contact.name
          .contains(new RegExp(searchPattern, caseSensitive: false))) {
        switch (currentIndex) {
          case 0:
            listElements.add(
              new ContactListElement(contact),
            );
            break;
          case 1:
            if (contact.favourite)
              listElements.add(
                new FavouriteListElement(contact),
              );
            break;
          case 2:
            listElements.add(
              new BirthdayListElement(contact),
            );
            break;
        }
      }
    }

    /// Add new ContactElementList to Block
    return new Block(
      children: listElements,
    );
  }
}
