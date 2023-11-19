import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          callCard('Stefanus Anthony', Icons.call_made, Colors.green,
              "July 18, 18:35"),
          callCard('Valeroy Sientika Putra', Icons.call_made, Colors.green,
              "July 18, 18:35"),
          callCard(
              'Benaya Juanda', Icons.call_made, Colors.green, "July 18, 18:35"),
          callCard('Hans Nathanael', Icons.call_missed, Colors.red,
              "July 19, 18:35"),
          callCard('Arethusa Reyhan', Icons.call_received, Colors.green,
              "July 20, 18:35"),
          callCard('Jason Sunaryo', Icons.call_received, Colors.green,
              "July 20, 18:35"),
          callCard('Yosihana Sirait', Icons.call_received, Colors.green,
              "July 20, 18:35"),
          callCard('Esther Laksmi', Icons.call_received, Colors.green,
              "July 20, 18:35"),
        ],
      ),
    );
  }

  Widget callCard(
      String name, IconData iconData, Color iconColor, String time) {
    return Card(
      margin: EdgeInsets.only(bottom: 0.5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              time,
              style: TextStyle(fontSize: 12.8),
            ),
          ],
        ),
        trailing: Icon(
          Icons.call,
          size: 28,
          color: Colors.teal,
        ),
      ),
    );
  }
}
