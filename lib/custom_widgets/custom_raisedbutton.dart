
import 'package:flutter/material.dart';
class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({Key key,@required this.text,@required this.onPressed,@required this.color}) : super(key: key);


  final String text;

  final VoidCallback onPressed;

  final Color color;
  


  @override
  Widget build(BuildContext context) {
    return RaisedButton(
                
                onPressed: onPressed,
                //color:Colors.grey[400],
                child: Text('$text',style:TextStyle(color: Colors.white),),
                elevation: 5.0,
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  
                ));
  }
}