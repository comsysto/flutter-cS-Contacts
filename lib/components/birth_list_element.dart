import 'package:flutter/material.dart';
import 'package:csContactsExt/components/contact_detail.dart';
import 'package:csContactsExt/contact.dart';

/// StatelessWidget BirthdayListElement is one element of the birthday list
/// responsible for selecting background color and content of card
/// returns a new Card widget
class BirthdayListElement extends StatelessWidget {
  Contact contact;

  BirthdayListElement(Contact contact) {
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
          onTap: () => Navigator.push(
                context,
                new MaterialPageRoute(builder: (BuildContext context) {
                  return new ContactDetail(
                    contact,
                    contact.avatar,
                  );
                }),
              ),
          trailing: new Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(right: 8.0),
                child: new Text(contact.birthday.day.toString() +
                    '.' +
                    contact.birthday.month.toString() +
                    '.'),
              ),
              new Icon(Icons.cake),
            ],
          ),
        ),
      ),
    );
  }
}
