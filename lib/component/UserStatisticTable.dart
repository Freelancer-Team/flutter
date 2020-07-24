import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelancer_flutter/component/MyPaginateDataTable.dart';


class UserStatisticTable extends StatefulWidget {
  UserStatisticTable(this.jobs);

  final List<StatisticUser> jobs;

  @override
  State<StatefulWidget> createState() => _UserStatisticTableState();
}

class _UserStatisticTableState extends State<UserStatisticTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  void myTapCallback(StatisticUser job) {

  }

  @override
  Widget build(BuildContext context) {
    final StatisticUserDataSource _statisticUsersDataSource = StatisticUserDataSource(widget.jobs);
    _statisticUsersDataSource.myCallback = myTapCallback;

    void _sort<T>(Comparable<T> getField(StatisticUser d), int columnIndex, bool ascending) {
      _statisticUsersDataSource._sort<T>(getField, ascending);
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
                          label: Text("用户名"),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((StatisticUser d) => d.name, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text("状态"),
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticUser d) => d.role, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text("工作量"),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticUser d) => d.workNumber, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text("发布数目"),
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticUser d) => d.publishNumber, columnIndex, ascending)
                      ),
                    ],
                    source: _statisticUsersDataSource
                )
              ],
            ),
          ),
        )
    );
  }
}

class  StatisticUserDataSource extends DataTableSource{
  Function(StatisticUser) myCallback;

  StatisticUserDataSource(this.statisticUsers);
  /*数据源*/
  final List<StatisticUser> statisticUsers;


/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(StatisticUser d),bool ascending){
    statisticUsers.sort((StatisticUser a, StatisticUser b) {
      if (ascending) {
        final StatisticUser c = a;
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
    if (index >= statisticUsers.length)
      return null;
    final StatisticUser statisticUser = statisticUsers[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(
            GestureDetector(
                onTap: () {
                  myCallback(statisticUser);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: statisticUser.name,
                    child: Text(
                      statisticUser.name,
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
          DataCell(Text(getUserRole(statisticUser))),
          DataCell(Text('${statisticUser.workNumber}')),
          DataCell(Text('${statisticUser.publishNumber}')),
        ]
    );
  }

  String getUserRole(StatisticUser user) {
    String text;
    switch (user.role) {
      case -2:
        {
          text = '待核验';
        }
        break;
      case -1:
        {
          text = '已封禁';
        }
        break;
      case 0:
        {
          text = '已核验';
        }
        break;
      case 1:
        {
          text = '管理员';
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
  int get rowCount => statisticUsers.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}

class StatisticUser {
  StatisticUser(
      this.userId,
      this.name,
      this.role,
      this.workNumber,
      this.publishNumber
      );
  final int userId;
  final String name;
  final int role;
  final int workNumber;
  final int publishNumber;
}
