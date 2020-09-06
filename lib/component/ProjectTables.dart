import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:freelancer_flutter/pages/ProjDetails.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:freelancer_flutter/component/MyPaginateDataTable.dart';
import 'hotel_app_theme.dart';

class MyFloatButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyFloatButtonState();
}

class _MyFloatButtonState extends State<MyFloatButton> {
  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption(iconData: Icons.event_busy, onPressed:() {}, tag: "关闭"));
    children.add(_profileOption(iconData: Icons.exit_to_app, onPressed: (){}, tag: "打开"));
    children.add(_profileOption(iconData: Icons.delete_outline, onPressed: () {}, tag: "删除"));

    return children;
  }

  Widget _profileOption({IconData iconData, Function onPressed, String tag}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
          backgroundColor: Colors.grey[500],
          mini: true,
          child: Icon(iconData),
          tooltip: tag,
          onPressed: onPressed,
          heroTag: tag,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      UnicornDialer(
        parentButtonBackground: Colors.grey[700],
        orientation: UnicornOrientation.HORIZONTAL,
        parentButton: Icon(Icons.build),
        childButtons: _getProfileMenu(),
      );
  }
}


typedef void MyCallback(var dessert);

class DataTableDemo extends StatefulWidget {
  final List<String> columnNames;
  final String tableKind;
  final List<StatisticProject> jobList;

  DataTableDemo({this.columnNames, this.tableKind, this.jobList});

  @override
  State<StatefulWidget> createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  String searchCondition = "";
  List<StatisticProject> jobList;
  List<StatisticProject> originJobList;

  /*DataSource状态映射*/
  bool hasSelectedDessert = false;
  StatisticProject selectedDessert;

  void myTapCallback(StatisticProject project) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(project.projectId)));
  }

  void selectOneDessert(var dessert){
    if(selectedDessert != null){
      selectedDessert.selected = false;
      print('${selectedDessert.projectName}');
    }
    setState(() {
      selectedDessert = dessert;
      hasSelectedDessert = true;
    });
  }

  void cancelSelectOneDessert(){
    setState(() {
      selectedDessert = null;
      hasSelectedDessert = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      jobList = widget.jobList;
      originJobList = widget.jobList;
    });
  }

  executeSearch() {
    List<StatisticProject> jobs = [];
    for(int i = 0; i < originJobList.length; ++i){
      if(originJobList[i].projectName.contains(searchCondition)) jobs.add(originJobList[i]);
    }
    setState(() {
      jobList = jobs;
    });
  }

  Widget tableContent(){
    final EmployerProceedingDataSource _statisticJobDataSource = EmployerProceedingDataSource(
      dataTableType: widget.tableKind,
      myCallback: myTapCallback,
      selectOneDessert: selectOneDessert,
      cancelSelectOneDessert: cancelSelectOneDessert,
      statisticProject: jobList
    );

    void _sort<T>(Comparable<T> getField(StatisticProject d), int columnIndex, bool ascending) {
      _statisticJobDataSource._sort<T>(getField, ascending);
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
                          label: Text(widget.columnNames[0]),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((StatisticProject d) => d.projectName, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[1]),
                          onSort: (int columnIndex, bool ascending) {
                            if(widget.tableKind == "employerProceeding" || widget.tableKind == "employerComplete")
                              _sort<String>((StatisticProject d) => d.employeeName, columnIndex, ascending);
                            else _sort<String>((StatisticProject d) => d.employerName, columnIndex, ascending);
                          }
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[2]),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((StatisticProject d) => d.price, columnIndex, ascending)
                      ),
                      //TODO 日期的排序
                      DataColumn(
                        label: Text(widget.columnNames[3]),
//                          onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.carbs, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[4]),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) {
                            if(widget.tableKind == "employerProceeding" || widget.tableKind == "employerComplete")
                              _sort<num>((StatisticProject d) => d.employeeRate, columnIndex, ascending);
                            else _sort<num>((StatisticProject d) => d.employerRate, columnIndex, ascending);
                          }
                      ),
                    ],
                    source: _statisticJobDataSource
                )
              ],
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: getSearchBarUI(),
                ),
              ),
              new Offstage(
                offstage: !hasSelectedDessert,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 8),
                  child: SizedBox(
                    height: 52,
                    width: 52,
                    child: MyFloatButton(),
                  ),
                ),
              )
            ],
          ),
          height: 90,
        ),
        tableContent()
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {searchCondition = txt;},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HexColor('#54D3C2'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HexColor('#54D3C2'),
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  executeSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,
                      size: 20,
                      color: const Color(0xFFFFFFFF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class StatisticProject {
  StatisticProject({
    this.projectId,
    this.projectName,
    this.employerName,
    this.employerId,
    this.employeeName,
    this.employeeId,
    this.price,
    this.employerRate,
    this.employeeRate,
    this.startTime,
    this.finishTime,
    this.avgPrice,
    this.lowestPrice,
    this.deadline
  });
  final String projectId;
  final String projectName;
  final String employerName;
  final int employerId;
  final String employeeName;
  final int employeeId;
  final int price;
  final double employerRate;
  final double employeeRate;
  final String startTime;
  final String finishTime;
  final int avgPrice;
  final int lowestPrice;
  final String deadline;

  bool selected = false;
}

class  EmployerProceedingDataSource extends DataTableSource{

  EmployerProceedingDataSource({
    this.dataTableType,
    this.statisticProject,
    this.selectOneDessert,
    this.cancelSelectOneDessert,
    this.myCallback
  });
  /*数据源*/
  final List<StatisticProject> statisticProject;
  Function(StatisticProject) myCallback;
  MyCallback selectOneDessert;
  VoidCallback cancelSelectOneDessert;
  String dataTableType;

/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(StatisticProject d),bool ascending){
    statisticProject.sort((StatisticProject a, StatisticProject b) {
      if (ascending) {
        final StatisticProject c = a;
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
    if (index >= statisticProject.length)
      return null;
    final StatisticProject dessert = statisticProject[index];
    if(dataTableType == "employerProceeding"){
      return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
              selectOneDessert(dessert);
            }
            else {
              cancelSelectOneDessert();
            }
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(dessert);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: dessert.projectName,
                    child: Text(
                      dessert.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.startTime}')),
            DataCell(Text('${(dessert.price * 0.2).toStringAsFixed(1)}')),
          ]
      );
    }
    else if(dataTableType == "employerComplete"){
      return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
              selectOneDessert(dessert);
            }
            else {
              cancelSelectOneDessert();
            }
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(dessert);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: dessert.projectName,
                    child: Text(
                      dessert.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.finishTime}')),
            DataCell(Text('${(dessert.employeeRate).toStringAsFixed(1)}')),
          ]
      );
    }
    else if(dataTableType == "employeeProceeding"){
      return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
              selectOneDessert(dessert);
            }
            else {
              cancelSelectOneDessert();
            }
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(dessert);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: dessert.projectName,
                    child: Text(
                      dessert.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employerName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.startTime}')),
            DataCell(Text('${(dessert.price * 0.2).toStringAsFixed(1)}')),
          ]
      );
    }
    else if(dataTableType == "employeeComplete"){
      return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
              selectOneDessert(dessert);
            }
            else {
              cancelSelectOneDessert();
            }
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(dessert);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: dessert.projectName,
                    child: Text(
                      dessert.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employerName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.finishTime}')),
            DataCell(Text('${(dessert.employerRate).toStringAsFixed(1)}')),
          ]
      );
    }
    else return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
              selectOneDessert(dessert);
            }
            else {
              cancelSelectOneDessert();
            }
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback(dessert);
                },
                child: Container(
                  width: 200,
                  child: Tooltip(
                    message: dessert.projectName,
                    child: Text(
                      dessert.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.startTime}')),
            DataCell(Text('${(dessert.price * 0.2).toStringAsFixed(1)}')),
          ]
      );
  }

  // TODO: implement isRowCountApproximate
  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => statisticProject.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}

