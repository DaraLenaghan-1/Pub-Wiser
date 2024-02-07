import 'package:flutter/material.dart';

class PubItemTrait extends StatelessWidget {
  const PubItemTrait({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label; //shown next to the icon

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.white,),
        SizedBox(width: 6),
        Text(label, style: const TextStyle(
          color: Colors.white,
          //fontSize: 17,
          //fontWeight: FontWeight.w500,	
        ),),
      ],
    );
  }
}
