import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:unicorndial/unicorndial.dart';


class MyFloatButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyFloatButtonState();
}

class _MyFloatButtonState extends State<MyFloatButton> {
  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption(iconData: Icons.account_balance, onPressed:() {}));
    children.add(_profileOption(iconData: Icons.settings, onPressed: (){}));
    children.add(_profileOption(iconData: Icons.subdirectory_arrow_left, onPressed: () {}));

    return children;
  }

  Widget _profileOption({IconData iconData, Function onPressed}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
          backgroundColor: Colors.grey[500],
          mini: true,
          child: Icon(iconData),
          onPressed: onPressed,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return
      UnicornDialer(
          parentButtonBackground: Colors.grey[700],
          orientation: UnicornOrientation.HORIZONTAL,
          parentButton: Icon(Icons.person),
          childButtons: _getProfileMenu(),
      );
  }
}


class DataTableDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;/*PaginatedDataTable 一个带有分页的table*/
  int _sortColumnIndex;
  bool _sortAscending = true;

  /*数据源*/
  final DessertDataSource _dessertsDataSource = DessertDataSource();


  void _sort<T>(Comparable<T> getField(Dessert d), int columnIndex, bool ascending) {
    _dessertsDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void myTapCallback() {
    Navigator.pushNamed(context, '/projdetails');
  }

  @override
  Widget build(BuildContext context) {
    _dessertsDataSource.myCallback = myTapCallback;
    return ListView(
          children: <Widget>[
            PaginatedDataTable(
                actions: <Widget>[/*跟header 在一条线的action*/
                  MyFloatButton()
                ],
                header: const Text(''),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (int value) { setState(() { _rowsPerPage = value; }); },
                sortColumnIndex: _sortColumnIndex,/*当前主排序的列的index*/
                sortAscending: _sortAscending,
                showCheckboxColumn: false,
                columns: <DataColumn>[
                  DataColumn(
                      label: const Text('Dessert (100g serving)'),
                      onSort: (int columnIndex, bool ascending) => _sort<String>((Dessert d) => d.name, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Calories'),
                      tooltip: 'The total amount of food energy in the given serving size.',
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.calories, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Fat (g)'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.fat, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Carbs (g)'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.carbs, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Protein (g)'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.protein, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Sodium (mg)'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.sodium, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Calcium (%)'),
                      tooltip: 'The amount of calcium as a percentage of the recommended daily amount.',
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.calcium, columnIndex, ascending)
                  ),
                  DataColumn(
                      label: const Text('Iron (%)'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => _sort<num>((Dessert d) => d.iron, columnIndex, ascending)
                  ),
                ],
                source: _dessertsDataSource
            )
          ],
        );
  }
}


class Dessert {
  Dessert(this.name, this.calories, this.fat, this.carbs, this.protein, this.sodium, this.calcium, this.iron);
  final String name;
  final int calories;
  final double fat;
  final int carbs;
  final double protein;
  final int sodium;
  final int calcium;
  final int iron;

  bool selected = false;
}

//typedef void MyCallback(var string);

class  DessertDataSource extends DataTableSource{
  VoidCallback myCallback;
  Dessert selectedDessert;

  /*数据源*/
  final List<Dessert> _desserts = <Dessert>[
    Dessert('Frozen yogurt',                        159,  6.0,  24,  4.0,  87, 14,  1),
    Dessert('Ice cream sandwich',                   237,  9.0,  37,  4.3, 129,  8,  1),
    Dessert('Eclair',                               262, 16.0,  24,  6.0, 337,  6,  7),
    Dessert('Cupcake',                              305,  3.7,  67,  4.3, 413,  3,  8),
    Dessert('Gingerbread',                          356, 16.0,  49,  3.9, 327,  7, 16),
    Dessert('Jelly bean',                           375,  0.0,  94,  0.0,  50,  0,  0),
    Dessert('Lollipop',                             392,  0.2,  98,  0.0,  38,  0,  2),
    Dessert('Honeycomb',                            408,  3.2,  87,  6.5, 562,  0, 45),
    Dessert('Donut',                                452, 25.0,  51,  4.9, 326,  2, 22),
    Dessert('KitKat',                               518, 26.0,  65,  7.0,  54, 12,  6),
  ];


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
    return DataRow.byIndex(
        index: index,
        selected: dessert.selected,
        onSelectChanged: (bool value) {
          if(value) {
            if(selectedDessert != null){
              selectedDessert.selected = false;
            }
            else _selectedCount += 1;
            selectedDessert = dessert;
          }
          else {
            _selectedCount += -1;
            selectedDessert = null;
          }
          assert(_selectedCount >= 0);
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
                '${dessert.name}',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          DataCell(Text('${dessert.calories}')),
          DataCell(Text('${dessert.fat.toStringAsFixed(1)}')),
          DataCell(Text('${dessert.carbs}')),
          DataCell(Text('${dessert.protein.toStringAsFixed(1)}')),
          DataCell(Text('${dessert.sodium}')),
          DataCell(Text('${dessert.calcium}%')),
          DataCell(Text('${dessert.iron}%')),
        ]);
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

