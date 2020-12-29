
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SensorListItem extends StatelessWidget {
  final String name;
  final String description;
  final double ultrasonic;
  final int waterlevel;
  final double power;
  final String recordedAt;

  SensorListItem({
    Key key,
    this.name,
    this.description,
    this.ultrasonic,
    this.waterlevel,
    this.power,
    this.recordedAt,
  }) : super(key: key);

  static String timeAgoSinceDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} tahun';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return 'Tahun lalu';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} bulan';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return 'Bulan lalu';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} minggu';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return 'Minggu lalu';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} hari';
    } else if (difference.inDays >= 1) {
      return 'Kemarin';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} jam';
    } else if (difference.inHours >= 1) {
      return 'Sejam lalu';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} menit';
    } else if (difference.inMinutes >= 1) {
      return 'Semenit lalu';
    } else if (difference.inSeconds > 15) {
      return '${difference.inSeconds} detik';
    } else {
      return 'Baru saja';
    }
  }

  static Color waterlevelColor(int w) {
    switch (w) {
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.deepOrange;
        break;
      case 4:
        return Colors.red;
        break;
      default:
        return Colors.black12;
        break;
    }
  }

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    top: 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: waterlevelColor(waterlevel),
                        ),
                        child: Container(
                          width: 14,
                          height: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.rulerHorizontal,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: Text("$ultrasonic cm"),
                            ),
                            FaIcon(
                              FontAwesomeIcons.batteryFull,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 8),
                              child: Text("$power watt"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(recordedAt != '' ? timeAgoSinceDate(recordedAt) : 'Offline'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
