import 'package:flutter/material.dart';


class StateCard extends StatelessWidget{
  const StateCard({Key key, this.state, this.date})
      : super(key: key);

  final int state;
  final String date;

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    switch(state){
      case -3: {
        text = '待审阅';
        color = Colors.orange.withOpacity(0.6);
      }
      break;
      case -2: {
        text = '关闭的';
        color = Colors.grey.withOpacity(0.6);
      }
      break;
      case -1: {
        text = '禁用的';
        color = Colors.red.withOpacity(0.6);
      }
      break;
      case 0: {
        var now = DateTime.now();
        var then = DateTime.parse(date.replaceAll('.', '-'));
        if(then.isAfter(now)){
          text = '竞标中';
          color = Colors.green.withOpacity(0.6);
        }
        else{
          text = '已过期';
          color = Colors.blueGrey.withOpacity(0.6);
        }
      }
      break;
      case 1: {
        text = '进行中';
        color = Colors.cyan.withOpacity(0.6);
      }
      break;
      case 2: {
        text = '已完成';
        color = Colors.indigoAccent.withOpacity(0.6);
      }
      break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: color,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 14,
            color: Colors.white
        ),
      ),
    );
  }
}
