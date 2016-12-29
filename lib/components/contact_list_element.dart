import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:csContactsExt/components/contact_detail.dart';
import 'package:csContactsExt/contact.dart';

/// StatelessWidget ContactListElement is one element of the contact list
/// responsible for selecting background color and content of card
/// returns a new Card widget
class ContactListElement extends StatelessWidget {
  Contact contact;

  ContactListElement(Contact contact) {
    this.contact = contact;
  }

  /// getCardColor is a helper function to determine which color the card has
  /// returns a Color
  Color getCardColor(BuildContext context) {
    Color cardColor;

    if (Theme.of(context).brightness == Brightness.dark) {
      if (contact.birthdayToday)
        cardColor = new Color.fromRGBO(177, 149, 0, 1.0);
      else if (contact.birthdayNextWeek)
        cardColor = new Color.fromRGBO(98, 83, 0, 1.0);
      else
        cardColor = Theme.of(context).cardColor;
    } else {
      if (contact.birthdayToday)
        cardColor = new Color.fromRGBO(255, 215, 0, 1.0);
      else if (contact.birthdayNextWeek)
        cardColor = new Color.fromRGBO(255, 243, 178, 1.0);
      else
        cardColor = Theme.of(context).cardColor;
    }

    return cardColor;
  }

  @override
  Widget build(BuildContext context) {
    String callNumber = contact.mobile != ''
        ? contact.mobile
        : contact.office != '' ? contact.office : contact.private;
    String messageNumber =
        contact.mobile != '' ? contact.mobile : contact.private;

    /// opens the standard mail app with the email address as receiver
    void mailToContact() {
      UrlLauncher.launch('mailto:' + contact.email + '@comsysto.com');
    }

    /// opens the standard call app
    void callContact(String number) {
      /// url scheme tel:// directly calls the number passed to the UrlLauncher
      /// whereas telprompt:// asks the user for confirmation
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        UrlLauncher.launch('telprompt://' + number.replaceAll(' ', ''));
      } else {
        UrlLauncher.launch('tel://' + number.replaceAll(' ', ''));
      }
    }

    /// opens the standard messaging app
    void messageToContact(String number) {
      UrlLauncher.launch('sms://' + number.replaceAll(' ', ''));
    }

    return new Card(
      elevation: 2,
      child: new Container(
        decoration: new BoxDecoration(
          backgroundColor: getCardColor(context),
        ),
        child: new ListItem(
          dense: false,
          leading: contact.avatar,
          title: new Text(contact.name),
          subtitle: contact.birthdayNextWeek
              ? new Text(contact.birthdayToday
                  ? 'Birthday is close'
                  : 'Birthday today')
              : null,
          /// onTap pushes a new route to the Navigator
          /// to display the contactDetails
          onTap: () => Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return new ContactDetail(
                  contact,
                  contact.avatar,
                );
              })),
          trailing: new Row(
            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.email),
                onPressed: contact.email != '' ? mailToContact : null,
              ),
              new IconButton(
                icon: new Icon(Icons.phone_in_talk),
                onPressed:
                    callNumber != '' ? () => callContact(callNumber) : null,
              ),
              new IconButton(
                icon: new Icon(Icons.message),
                onPressed: messageNumber != ''
                    ? () => messageToContact(messageNumber)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
