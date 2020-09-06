import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'config.dart';
import 'package:flutter_picker/flutter_picker.dart';

class PublishData {
  PublishData(this.year, this.jobCnt);

  final int year;
  final int jobCnt;
}

class ChartView extends StatefulWidget {
  ChartView({Key key}) : super(key: key);

  @override
  _ChartViewState createState() => new _ChartViewState();
}

class _ChartViewState extends State<ChartView> with SingleTickerProviderStateMixin {

  List<PublishData> chartData = [];
  int year = 2020;
  int lowMonth = 1;
  int highMonth = 10;

  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  getStatistics() async {
    List<PublishData> chart = [];
    var response = [];
    String url = "${Url.url_prefix}/getStatistics?year=" + year.toString() +
        '&lowMonth=' + lowMonth.toString() + '&highMonth=' +
        highMonth.toString();
    String token = await StorageUtil.getStringItem('token');
    final res = await http.get(url,
        headers: {"Accept": "application/json", "Authorization": "$token"});
    final data = json.decode(res.body);
    response = data;
    for (int i = 0; i < response.length; ++i) {
      chart.add(PublishData(
          i + lowMonth, response[i]));
    }
    setState(() {
      chartData = chart;
    });
  }

  showPickerNumberY(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 2018, end: 2022, jump: 1),
        ]),
        selecteds: [year - 1],
        hideHeader: false,
        title: Text("选择年龄"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            year = picker.getSelectedValues()[0];
          });
        }
    ).showModal(context);
  }

  showPickerNumberM1(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 12, jump: 1),
        ]),
        selecteds: [lowMonth - 1],
        hideHeader: false,
        title: Text("选择起始月份"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            lowMonth = picker.getSelectedValues()[0];
          });
        }
    ).showModal(context);
  }

  showPickerNumberM2(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: lowMonth + 1, end: 12, jump: 1),
        ]),
        selecteds: [highMonth - 1],
        hideHeader: false,
        title: Text("选择终止月份"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            highMonth = picker.getSelectedValues()[0];
          });
        }
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 10,),
        Row(
          children: [
            Container(width: 30,),
            InkWell(
              onTap: () {},
              child: Text(year.toString() + '年'),
            ),
            Container(width: 15,),
            InkWell(
              onTap: () {
                showPickerNumberM1(context);
              },
              child: Text(lowMonth.toString() + '月', style: TextStyle(fontSize: 20),),
            ),
            Container(width: 10,),
            Text("到"),
            Container(width: 10,),
            InkWell(
              onTap: () {
                showPickerNumberM2(context);
              },
              child: Text(highMonth.toString() + '月', style: TextStyle(fontSize: 20),),
            ),
            Container(width: 100,),
            RaisedButton(
              color: Colors.blue,
              onPressed: getStatistics,
              child: Text("查询"),
            )
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width - 30,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(
                    text: '2020年月发布量折线图'),
                // Enable legend
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <LineSeries<PublishData, int>>[
                  LineSeries<PublishData, int>(
                      dataSource: chartData,
                      xValueMapper: (PublishData sales, _) =>
                      sales.year,
                      yValueMapper: (PublishData sales, _) =>
                      sales.jobCnt,
                      // Enable data label
                      dataLabelSettings:
                      DataLabelSettings(isVisible: true))
                ]
            )
        )
      ],
    );
  }
}
