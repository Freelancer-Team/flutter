import 'package:flutter/material.dart';

class PublishPage extends StatefulWidget {
  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  double width;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

//  String _email;
  String _title;
  String _owner;
  String _address;
  String _min;
  String _max;
  String _description;
  DateTime _ddl;

  void onSubmit() {
    final form = formKey.currentState;
    if (form.validate() && _ddl != null) {
      form.save();
      performLogin();
    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Title: $_title, desc : $_description"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget chosenTime(BuildContext context) {
    if (_ddl == null)
      return Text('请选择    ');
    else
      return new Text(_ddl.toString().substring(0, 16));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Publish A Project',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
          ),
          brightness: Brightness.light,
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                Row(children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Title"),
                    validator: (val) =>
                        val.length < 2 ? 'Title too short' : null,
                    onSaved: (val) => _title = val,
                  )),
                  new Text('  '),
                  new Expanded(
                      child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Owner"),
                    validator: (val) =>
                        val.length < 1 ? 'Please input your name' : null,
                    onSaved: (val) => _owner = val,
                  ))
                ]),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Address"),
                  validator: (val) =>
                      val.length < 6 ? 'Please enter work location' : null,
                  onSaved: (val) => _address = val,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child:
                        new Text('预算：若不填写max，则默认无上限，不填写min，则默认下限为0，均不填则为面议')),
                Row(children: <Widget>[
                  new Expanded(
                      child: TextFormField(
                    decoration: new InputDecoration(labelText: "Min"),
//                    validator: (val) =>
//                        val.length < 6 ? 'Please enter salary' : null,
                    onSaved: (val) => _min = val,
                  )),
                  new Text('  '),
                  new Expanded(
                      child: TextFormField(
                    decoration: new InputDecoration(labelText: "Max"),
//                    validator: (val) =>
//                        val.length < 6 ? 'Please enter salary' : null,
                    onSaved: (val) => _max = val,
                  ))
                ]),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: new Text('接单截止日期')),
                Row(children: <Widget>[
                  chosenTime(context),
                  new MaterialButton(
                    child: new Text(
                      '选择',
                      style: new TextStyle(color: Colors.white),
                    ),
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () async {
                      // 调用函数打开
                      final DateTime date = await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate:
                            new DateTime.now().subtract(new Duration(days: 30)),
                        // 减 30 天
                        lastDate: new DateTime.now()
                            .add(new Duration(days: 30)), // 加 30 天
                      ).then((DateTime val) {
                        print(val); // 2018-07-12 00:00:00.000
                        setState(() {
                          _ddl = val;
                        });
                      }).catchError((err) {
                        print(err);
                      });
                    },
                  )
                ]),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, //不限制行数
                  validator: (val) =>
                      val.length < 20 ? 'Description too short' : null,
                  onSaved: (val) => _description = val,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    "submit",
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: onSubmit,
                )
              ],
            ),
          ),
        ));
  }
}
