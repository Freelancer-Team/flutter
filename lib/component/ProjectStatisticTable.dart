import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancer_flutter/component/MyPaginateDataTable.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'hotel_app_theme.dart';


class ProjectStatisticTable extends StatefulWidget {
  ProjectStatisticTable(this.jobs);

  final List<StatisticJob> jobs;

  @override
  State<StatefulWidget> createState() => _ProjectStatisticTableState();
}

class _ProjectStatisticTableState extends State<ProjectStatisticTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  void myTapCallback(StatisticJob job) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(job.projectId)));
  }

  @override
  Widget build(BuildContext context) {
    final StatisticJobDataSource _statisticJobsDataSource = StatisticJobDataSource(widget.jobs);
    _statisticJobsDataSource.myCallback = myTapCallback;

    void _sort<T>(Comparable<T> getField(StatisticJob d), int columnIndex, bool ascending) {
      _statisticJobsDataSource._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }

    return(
        Expanded(
          child: Container(
            child: ListView(
              children: <Widget>[
                MyPaginatedDataTable(
                    header: const Text(''),
                    headingRowHeight: 50,
                    horizontalMargin: 20,
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
                    sortColumnIndex: _sortColumnIndex,/*当前主排序的列的index*/
                    sortAscending: _sortAscending,
                    showCheckboxColumn: false,
                    columns: <DataColumn>[
                      DataColumn(
                          label: Text("项目名称"),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((StatisticJob d) => d.projectName, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text("状态"),
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticJob d) => d.state, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text("访问次数"),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticJob d) => d.accessTimes, columnIndex, ascending)
                      ),
                      DataColumn(
                        label: Text("竞标人数"),
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticJob d) => d.candidateNumbers, columnIndex, ascending)
                      ),
                    ],
                    source: _statisticJobsDataSource
                )
              ],
            ),
          ),
        )
    );
  }
}

class  StatisticJobDataSource extends DataTableSource{
  Function(StatisticJob) myCallback;

  StatisticJobDataSource(this.statisticJobs);
  /*数据源*/
  final List<StatisticJob> statisticJobs;


/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(StatisticJob d),bool ascending){
    statisticJobs.sort((StatisticJob a, StatisticJob b) {
      if (ascending) {
        final StatisticJob c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    if (index >= statisticJobs.length)
      return null;
    final StatisticJob statisticJob = statisticJobs[index];
      return DataRow.byIndex(
          index: index,
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(statisticJob);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: statisticJob.projectName,
                    child: Text(
                      statisticJob.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ),
            ),
            DataCell(Text(getJobState(statisticJob))),
            DataCell(Text('${statisticJob.accessTimes}')),
            DataCell(Text('${statisticJob.candidateNumbers}')),
          ]
      );
  }

  String getJobState(StatisticJob job) {
    String text;
    switch(job.state){
      case -3: {
        text = '待审阅';
      }
      break;
      case -2: {
        text = '关闭的';
      }
      break;
      case -1: {
        text = '禁用的';
      }
      break;
      case 0: {
        var now = DateTime.now();
        var then = DateTime.parse(job.deadline);
        if(then.isAfter(now)){
          text = '竞标中';
        }
        else{
          text = '已过期';
        }
      }
      break;
      case 1: {
        text = '进行中';
      }
      break;
      case 2: {
        text = '已完成';
      }
      break;
    }
    return text;
  }

  // TODO: implement isRowCountApproximate
  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => statisticJobs.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}

class StatisticJob {
  StatisticJob(
      this.projectId,
      this.projectName,
      this.state,    //分类情况见StateCard.dart
      this.deadline,
      this.accessTimes,
      this.candidateNumbers
      );
  final String projectId;
  final String projectName;
  final int state;
  final String deadline;
  final int accessTimes;
  final int candidateNumbers;
}
