import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context,'4','Forum'),
      buildDivider(),
      buildButton(context,'10','Community'),
      buildDivider(),
      buildButton(context,'5','Event'),
      ],
    ),
);

  Widget buildDivider() => Container(
    height : 25,
    width: 0.7,
    child:VerticalDivider(),
    color: Colors.grey,
    
  );

  Widget buildButton(BuildContext context, String value, String text)=> MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed:() {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 15,
            thickness: 2,
            
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold,/*fontSize: 14*/),
          )
        ],
      ),
    );
}