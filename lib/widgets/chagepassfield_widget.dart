import 'package:flutter/material.dart';

class ChangePassTextFiledWidget extends StatefulWidget{
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const ChangePassTextFiledWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ChangePassTextFiledWidgetState createState() => _ChangePassTextFiledWidgetState();
}

class _ChangePassTextFiledWidgetState extends State<ChangePassTextFiledWidget>{
  late final TextEditingController controller;
  bool _isObscure = true;
  @override
  void initState(){
    super.initState();
    controller = TextEditingController(text: widget.text); 
  }

  @override 
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override 
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: _isObscure,
        controller: controller ,
        decoration: InputDecoration(
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          ),
        suffixIcon:IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
              });
            },
          ),   
        ),
        maxLines: widget.maxLines,
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}