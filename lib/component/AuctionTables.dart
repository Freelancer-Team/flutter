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


//TODO 后端需增加项目数据域————确定接单人后的'具体佣金'，用于进行中和已完成的项目数据表，否则需前端三次请求
class EmployeeAuctionTable extends StatefulWidget {

  final List<Auction> auctionList;

  EmployeeAuctionTable({this.auctionList});

  @override
  State<StatefulWidget> createState() => _EmployeeAuctionTableState();
}

class _EmployeeAuctionTableState extends State<EmployeeAuctionTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  String searchCondition = "";
  List<Auction> auctionList;
  List<Auction> originAuctionList;

  /*DataSource状态映射*/
  bool hasSelectedDessert = false;
  Auction selectedDessert;

  @override
  void initState() {
    super.initState();
    setState(() {
      auctionList = widget.auctionList;
      originAuctionList = widget.auctionList;
    });
  }

  executeSearch() {
    print("start");
    List<Auction> auctions = [];
    for(int i = 0; i < originAuctionList.length; ++i){
      if(originAuctionList[i].projectName.contains(searchCondition)) {auctions.add(originAuctionList[i]); print(i);}
    }
    setState(() {
      auctionList = auctions;
    });
  }

  void myTapCallback(Auction auction) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(auction.projectId)));
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

  Widget tableContent(){
    final EmployeeAuctionDataSource _employeeAuctionDataSource = EmployeeAuctionDataSource(
        myCallback: myTapCallback,
        selectOneDessert: selectOneDessert,
        cancelSelectOneDessert: cancelSelectOneDessert,
        auctionList: auctionList
    );

    void _sort<T>(Comparable<T> getField(Auction d), int columnIndex, bool ascending) {
      _employeeAuctionDataSource._sort<T>(getField, ascending);
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
                          label: Text('项目名称'),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((Auction d) => d.projectName, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('项目状态'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.projectState, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('竞标状态'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.auctionState, columnIndex, ascending)
                      ),
                      DataColumn(
                        label: Text('我的竞价'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.myPrice, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('平均竞价'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.avgPrice, columnIndex, ascending)
                      ),
                      //TODO 日期的排序
                      DataColumn(
                        label: Text('竞标截止日期'),
//                          onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.carbs, columnIndex, ascending)
                      ),
                    ],
                    source: _employeeAuctionDataSource
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

class Auction {
  Auction({
    this.projectId,
    this.projectName,
    this.projectState,
    this.auctionState,
    this.myPrice,
    this.lowestPrice,
    this.avgPrice,
    this.deadline
  });
  final String projectId;
  final String projectName;
  final int projectState;
  final int auctionState;
  final int myPrice;
  final int lowestPrice;
  final int avgPrice;
  final String deadline;

  bool selected = false;
}

class  EmployeeAuctionDataSource extends DataTableSource{

  EmployeeAuctionDataSource({
    this.auctionList,
    this.selectOneDessert,
    this.cancelSelectOneDessert,
    this.myCallback
  });
  /*数据源*/
  final List<Auction> auctionList;
  Function(Auction) myCallback;
  MyCallback selectOneDessert;
  VoidCallback cancelSelectOneDessert;

/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(Auction d),bool ascending){
    auctionList.sort((Auction a, Auction b) {
      if (ascending) {
        final Auction c = a;
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
    if (index >= auctionList.length)
      return null;
    final Auction dessert = auctionList[index];
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
          DataCell(Text(getProjectState(dessert))),
          DataCell(Text(getAuctionState())),
          DataCell(Text('${dessert.myPrice}')),
          DataCell(Text('${dessert.avgPrice}')),
          DataCell(Text(dessert.deadline.substring(0, 10)))
        ]
    );
  }

  String getProjectState(Auction auction){
    String text;
    switch(auction.projectState){
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
        var then = DateTime.parse(auction.deadline);
        if(then.isAfter(now)){
          text = '竞标中';
        }
        else{
          text = '已过期';
        }
      }
      break;
    }
    return text;
  }

  String getAuctionState(){
    return '等待确认';
  }

  // TODO: implement isRowCountApproximate
  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => auctionList.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}


class EmployerAuctionTable extends StatefulWidget {

  final List<Auction> auctionList;

  EmployerAuctionTable({this.auctionList});

  @override
  State<StatefulWidget> createState() => _EmployerAuctionTableState();
}

class _EmployerAuctionTableState extends State<EmployerAuctionTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  String searchCondition = "";
  List<Auction> auctionList;
  List<Auction> originAuctionList;

  /*DataSource状态映射*/
  bool hasSelectedDessert = false;
  Auction selectedDessert;

  @override
  void initState() {
    super.initState();
    setState(() {
      auctionList = widget.auctionList;
      originAuctionList = widget.auctionList;
    });
  }

  executeSearch() {
    print("start");
    List<Auction> auctions = [];
    for(int i = 0; i < originAuctionList.length; ++i){
      if(originAuctionList[i].projectName.contains(searchCondition)) {auctions.add(originAuctionList[i]); print(i);}
    }
    setState(() {
      auctionList = auctions;
    });
  }

  void myTapCallback(Auction auction) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjDetails(auction.projectId)));
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

  Widget tableContent(){
    final EmployerAuctionDataSource _employerAuctionDataSource = EmployerAuctionDataSource(
        myCallback: myTapCallback,
        selectOneDessert: selectOneDessert,
        cancelSelectOneDessert: cancelSelectOneDessert,
        auctionList: auctionList
    );

    void _sort<T>(Comparable<T> getField(Auction d), int columnIndex, bool ascending) {
      _employerAuctionDataSource._sort<T>(getField, ascending);
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
                          label: Text('项目名称'),
                          onSort: (int columnIndex, bool ascending) => _sort<String>((Auction d) => d.projectName, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('项目状态'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.projectState, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('最低竞价'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.lowestPrice, columnIndex, ascending)
                      ),
                      DataColumn(
                          label: Text('平均竞价'),
                          numeric: true,
                          onSort: (int columnIndex, bool ascending) => _sort<num>((Auction d) => d.avgPrice, columnIndex, ascending)
                      ),
                      //TODO 日期的排序
                      DataColumn(
                        label: Text('竞标截止日期'),
//                          onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.carbs, columnIndex, ascending)
                      ),
                    ],
                    source: _employerAuctionDataSource
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

class  EmployerAuctionDataSource extends DataTableSource{

  EmployerAuctionDataSource({
    this.auctionList,
    this.selectOneDessert,
    this.cancelSelectOneDessert,
    this.myCallback
  });
  /*数据源*/
  final List<Auction> auctionList;
  Function(Auction) myCallback;
  MyCallback selectOneDessert;
  VoidCallback cancelSelectOneDessert;

/*ascending 上升 这里排序 没看懂比较的是个啥*/
  void _sort<T> (Comparable<T> getField(Auction d),bool ascending){
    auctionList.sort((Auction a, Auction b) {
      if (ascending) {
        final Auction c = a;
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
    if (index >= auctionList.length)
      return null;
    final Auction dessert = auctionList[index];
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
          DataCell(Text(getProjectState(dessert))),
          DataCell(Text('${dessert.lowestPrice}')),
          DataCell(Text('${dessert.avgPrice}')),
          DataCell(Text("${dessert.deadline.substring(0, 10)}"))
        ]
    );
  }

  String getProjectState(Auction auction){
    String text = '！！${auction.projectState}';
    switch(auction.projectState){
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
        var then = DateTime.parse(auction.deadline.replaceAll('.', '-'));
        if(then.isAfter(now)){
          text = '竞标中';
        }
        else{
          text = '已过期';
        }
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
  int get rowCount => auctionList.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => _selectedCount;
}
