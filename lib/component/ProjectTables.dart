import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  DataTableDemo({this.columnNames, this.tableKind});

  @override
  State<StatefulWidget> createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  /*数据源*/
//  final EmployerProceedingDataSource _dessertsDataSource = EmployerProceedingDataSource(widget.tableKind);

  /*DataSource状态映射*/
  bool hasSelectedDessert = false;
  Dessert selectedDessert;


  void myTapCallback() {
    Navigator.pushNamed(context, '/projdetails');
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

//  void _sort<T>(Comparable<T> getField(Dessert d), int columnIndex, bool ascending) {
//    _dessertsDataSource._sort<T>(getField, ascending);
//    setState(() {
//      _sortColumnIndex = columnIndex;
//      _sortAscending = ascending;
//    });
//  }

  Widget tableContent(){
    final EmployerProceedingDataSource _dessertsDataSource = EmployerProceedingDataSource(widget.tableKind);
    _dessertsDataSource.myCallback = myTapCallback;
    _dessertsDataSource.selectOneDessert = selectOneDessert;
    _dessertsDataSource.cancelSelectOneDessert = cancelSelectOneDessert;

    void _sort<T>(Comparable<T> getField(Dessert d), int columnIndex, bool ascending) {
      _dessertsDataSource._sort<T>(getField, ascending);
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
                          onSort: (int columnIndex, bool ascending) => _sort<String>((Dessert d) => d.projectName, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[1]),
                          onSort: (int columnIndex, bool ascending) {
                            if(widget.tableKind == "employerProceeding" || widget.tableKind == "employerComplete")
                              _sort<String>((Dessert d) => d.employeeName, columnIndex, ascending);
                            else _sort<String>((Dessert d) => d.employerName, columnIndex, ascending);
                          }
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[2]),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.price, columnIndex, ascending)
                      ),
                      DataColumn(
                        label: Text(widget.columnNames[3]),
//                          onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.carbs, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text(widget.columnNames[4]),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) {
                            if(widget.tableKind == "employerProceeding" || widget.tableKind == "employerComplete")
                              _sort<num>((Dessert d) => d.employeeRate, columnIndex, ascending);
                            else _sort<num>((Dessert d) => d.employerRate, columnIndex, ascending);
                          }
                      ),
                    ],
                    source: _dessertsDataSource
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
          height: 100,
        ),
        tableContent()
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
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
                    onChanged: (String txt) {},
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


class Dessert {
  Dessert(
      this.projectId,
      this.projectName,
      this.employerName,
      this.employerId,
      this.employeeName,
      this.employeeId,
      this.price,
      this.employerRate,
      this.employeeRate,
      this.deadLine,
      this.completeDate
      );
  final int projectId;
  final String projectName;
  final String employerName;
  final int employerId;
  final String employeeName;
  final int employeeId;
  final double price;
  final double employerRate;
  final double employeeRate;
  final String deadLine;
  final String completeDate;

  bool selected = false;
}

/*假数据在这里*/
List<Dessert> data = [
  Dessert(1,'Frozen yogurt',                        "xtc",  6,  "sqy",  3,  87, 14,  1, "7月18日", "7月6日"),
  Dessert(2,'Ice cream sandwich',                   "bb",   9,  "sqy",  3, 129,  8,  1, "7月18日", "7月6日"),
  Dessert(3,'Eclair',                               "gdy",  1,  "sqy",  3, 337,  6,  7, "7月18日", "7月6日"),
  Dessert(4,'Cupcake',                              "sqy",  3,  "sqy",  3, 413,  3,  8, "7月18日", "7月6日"),
  Dessert(5,'Gingerbread',                          "xjq", 16,  "sqy",  3, 327,  7, 16, "7月18日", "7月6日"),
  Dessert(6,'Jelly bean',                           "lyx",  8,  "sqy",  3,  50,  0,  0, "7月18日", "7月6日"),
  Dessert(7,'Lollipop',                             "hlz",  2,  "sqy",  3,  38,  0,  2, "7月18日", "7月6日"),
  Dessert(8,'Honeycomb',                            "zdy",  5,  "sqy",  3, 562,  0, 45, "7月18日", "7月6日"),
  Dessert(9,'Donut',                                "lnr",  7,  "sqy",  3, 326,  2, 22, "7月18日", "7月6日"),
  Dessert(10,'KitKat',                               "ryl", 4,  "sqy",  3,  54, 12,  6, "7月18日", "7月6日"),
];

class  EmployerProceedingDataSource extends DataTableSource{
  VoidCallback myCallback;
  MyCallback selectOneDessert;
  VoidCallback cancelSelectOneDessert;
//  Dessert selectedDessert;

  String dataTableType;

  EmployerProceedingDataSource(String type){dataTableType = type;}
  /*数据源*/
  final List<Dessert> _desserts = data;


/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(Dessert d),bool ascending){
    _desserts.sort((Dessert a, Dessert b) {
      if (ascending) {
        final Dessert c = a;
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
    if (index >= _desserts.length)
      return null;
    final Dessert dessert = _desserts[index];
    if(dataTableType == "employerProceeding"){
      return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
//            if(selectedDessert != null){
//              selectedDessert.selected = false;
//              print('${selectedDessert.projectName}');
//            }
//            else _selectedCount += 1;
//            selectedDessert = dessert;
              selectOneDessert(dessert);
            }
            else {
//            _selectedCount += -1;
//            selectedDessert = null;
              cancelSelectOneDessert();
            }
//          assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback();
                },
                child: Text(
                  '${dessert.projectName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.deadLine}')),
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
//            if(selectedDessert != null){
//              selectedDessert.selected = false;
//              print('${selectedDessert.projectName}');
//            }
//            else _selectedCount += 1;
//            selectedDessert = dessert;
              selectOneDessert(dessert);
            }
            else {
//            _selectedCount += -1;
//            selectedDessert = null;
              cancelSelectOneDessert();
            }
//          assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback();
                },
                child: Text(
                  '${dessert.projectName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.completeDate}')),
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
//            if(selectedDessert != null){
//              selectedDessert.selected = false;
//              print('${selectedDessert.projectName}');
//            }
//            else _selectedCount += 1;
//            selectedDessert = dessert;
              selectOneDessert(dessert);
            }
            else {
//            _selectedCount += -1;
//            selectedDessert = null;
              cancelSelectOneDessert();
            }
//          assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback();
                },
                child: Text(
                  '${dessert.projectName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employerName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.deadLine}')),
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
//            if(selectedDessert != null){
//              selectedDessert.selected = false;
//              print('${selectedDessert.projectName}');
//            }
//            else _selectedCount += 1;
//            selectedDessert = dessert;
              selectOneDessert(dessert);
            }
            else {
//            _selectedCount += -1;
//            selectedDessert = null;
              cancelSelectOneDessert();
            }
//          assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback();
                },
                child: Text(
                  '${dessert.projectName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employerName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.completeDate}')),
            DataCell(Text('${(dessert.employerRate).toStringAsFixed(1)}')),
          ]
      );
    }
    else return DataRow.byIndex(
          index: index,
          selected: dessert.selected,
          onSelectChanged: (bool value) {
            if(value) {
//            if(selectedDessert != null){
//              selectedDessert.selected = false;
//              print('${selectedDessert.projectName}');
//            }
//            else _selectedCount += 1;
//            selectedDessert = dessert;
              selectOneDessert(dessert);
            }
            else {
//            _selectedCount += -1;
//            selectedDessert = null;
              cancelSelectOneDessert();
            }
//          assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();
          },
          cells: <DataCell>[
            DataCell(
              GestureDetector(
                onTap: () {
                  myCallback();
                },
                child: Text(
                  '${dessert.projectName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            DataCell(Text('${dessert.employeeName}')),
            DataCell(Text('${dessert.price.toStringAsFixed(1)}')),
            DataCell(Text('${dessert.deadLine}')),
            DataCell(Text('${(dessert.price * 0.2).toStringAsFixed(1)}')),
          ]
      );
  }

  // TODO: implement isRowCountApproximate
  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => _desserts.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}

