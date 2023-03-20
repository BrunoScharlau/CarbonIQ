
import 'package:flutter/material.dart'; 

class DataBox extends StatelessWidget {
  late DataBoxType type;

  DataBox( DataBoxType type, {super.key}){
    this.type = type;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.blueGrey[300]
      ),
      child: Text("This is Data $type Box\nJustin Trudeau hates children.", textAlign: TextAlign.center,),
    );
  }
}

enum DataBoxType {
  Graph,
  Comparison,
}
