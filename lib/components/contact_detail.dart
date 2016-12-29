import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:csContactsExt/contact.dart';

/// StatelessWidget ContactDetail is a new Route pushed to the Navigator
/// instantiates new ContactDetailPage as body
/// returns a new Scaffold
class ContactDetail extends StatelessWidget {
  Contact contact;
  CircleAvatar avatar;

  ContactDetail(Contact contact, CircleAvatar avatar) {
    this.contact = contact;
    this.avatar = avatar;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(''),
      ),
      body: new Card(
        elevation: 0,
        child: new ContactDetailPage(contact),
      ),
    );
  }
}

/// StatefulWidget ContactDetailPage creates new ContactDetailState
/// receives Contact from parent
class ContactDetailPage extends StatefulWidget {
  Contact contact;

  ContactDetailPage(Contact contact) {
    this.contact = contact;
  }

  @override
  ContactDetailState createState() => new ContactDetailState(this.contact);
}

/// State ContactDetailState holds the state for the ContactDetailPage class
/// responsible for color and content of the ContactDetailPage
class ContactDetailState extends State<ContactDetailPage> {
  Contact contact;

  ContactDetailState(Contact contact) {
    this.contact = contact;
  }

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

  /// opens a simpleDialogWidget with the provided child
  /// calls the provided callback after clicking on one option
  void showCallDialog({BuildContext context, Widget child}) {
    showDialog(context: context, child: child).then((dynamic value) {
      if (value != null) {
        value();
      }
    });
  }

  /// Pastes given String to the clipboard and shows Popup-Snackbar
  void copyToClipboard(String toClipboard) {
    ClipboardData data = new ClipboardData(text: toClipboard);
    Clipboard.setData(data);
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(toClipboard + ' copied to clipboard.'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        /// Avatar
        new Container(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new CircleAvatar(radius: 64.0, child: contact.avatar.child),
        ),

        /// name
        new Container(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          child: new Text(
            contact.name,
            textScaleFactor: 1.5,
          ),
        ),

        /// favourite row
        new ListItem(
          dense: true,
          leading: new Icon(Icons.star,
              color: contact.favourite ? Colors.yellow[500] : Colors.black),
          title: new Text(
            contact.favourite ? 'Remove from Favourites' : 'Add to Favourites',
            textScaleFactor: 1.2,
          ),
          onTap: () {
            contact.setFavourite(!contact.favourite);
            Navigator.pop(context);
          },
        ),

        /// mobile phone row
        contact.mobile != ''
            ? new ListItem(
                dense: true,
                leading: new Icon(Icons.stay_primary_portrait),
                title: new Text(
                  contact.mobile,
                  textScaleFactor: 1.2,
                ),
                onTap: () => showCallDialog(
                      context: context,
                      child: new SimpleDialog(
                        title: new Text('Call or Text?'),
                        children: <Widget>[
                          new IconButton(
                              icon: new Icon(Icons.phone_in_talk),
                              onPressed: () => Navigator.pop(
                                  context, () => callContact(contact.mobile))),
                          new IconButton(
                              icon: new Icon(Icons.chat),
                              onPressed: () => Navigator.pop(context,
                                  () => messageToContact(contact.mobile))),
                        ],
                      ),
                    ),
                onLongPress: () => copyToClipboard(contact.mobile),
              )
            : new Row(),

        /// private phone row
        contact.private != ''
            ? new ListItem(
                dense: true,
                leading: new Icon(Icons.phonelink_lock),
                title: new Text(contact.private + ' (private)',
                    textScaleFactor: 1.2),
                onTap: () => showCallDialog(
                      context: context,
                      child: new SimpleDialog(
                        title: new Text('Call or Text?'),
                        children: <Widget>[
                          new IconButton(
                              icon: new Icon(Icons.phone_in_talk),
                              onPressed: () => Navigator.pop(
                                  context, () => callContact(contact.private))),
                          new IconButton(
                              icon: new Icon(Icons.message),
                              onPressed: () => Navigator.pop(context,
                                  () => messageToContact(contact.private))),
                        ],
                      ),
                    ),
                onLongPress: () => copyToClipboard(contact.private),
              )
            : new Row(),

        /// office phone row
        contact.office != ''
            ? new ListItem(
                dense: true,
                leading: new Icon(Icons.phone),
                title: new Text(contact.office, textScaleFactor: 1.2),
                onTap: () => callContact(contact.office),
                onLongPress: () => copyToClipboard(contact.office),
              )
            : new Row(),

        /// email row
        contact.email != ''
            ? new ListItem(
                dense: true,
                leading: new Icon(Icons.mail),
                title: new Text(contact.email, textScaleFactor: 1.2),
                onTap: () => mailToContact(),
                onLongPress: () => copyToClipboard(contact.email),
              )
            : new Row(),

        /// birthday row
        contact.birthday != ''
            ? new ListItem(
                dense: true,
                leading: new Icon(Icons.cake),
                title: new Text(
                    contact.birthday.day.toString() +
                        '.' +
                        contact.birthday.month.toString() +
                        '.' +
                        (contact.birthdayToday
                            ? ' (today)'
                            : contact.birthdayNextWeek ? ' (this week)' : ''),
                    textScaleFactor: 1.2),
              )
            : new Row(),
      ],
    );
  }
}
