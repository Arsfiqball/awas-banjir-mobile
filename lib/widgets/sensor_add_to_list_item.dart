import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SensorAddToListItem extends StatelessWidget {
  final String name;
  final String description;
  final String id;
  final bool addable;
  final Function() onPressed;
  final Function() onTap;

  SensorAddToListItem({
    Key key,
    this.name,
    this.description,
    this.id,
    this.addable = true,
    this.onPressed,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              addable == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FlatButton(
                        onPressed: onPressed,
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Tambah'),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.blue,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
