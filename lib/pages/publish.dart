import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancer_flutter/component/SkillChooseModal.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProjDetails.dart';
import 'package:freelancer_flutter/component/config.dart';

class PublishPage extends StatefulWidget {
  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  double width;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  FlutterToast flutterToast;
  List<String> selSkills = [];

  String _title;
  String _owner;
  int _oid;
  String _address;
//  String _min;
//  String _max;
  String _budget;
  String _description;
  DateTime _ddl;

  void onSubmit() {
    final form = formKey.currentState;
    if (form.validate() && _ddl != null) {
      form.save();
      saveJob();
    }
  }
  saveJob() async {
    try {
      String url = "${Url.url_prefix}/saveJob";
      var res = await http.post(Uri.encodeFull(url), headers: {
        "content-type": "application/json"
      }, body: json.encode({
        "skills":selSkills,
        "title":_title,
        "description":_description,
        "price":_budget,
        "remaining_time":_ddl.toIso8601String(),
        "employeeName":_owner,
        "employeeId":_oid.toString(),
      }));
      var response = json.decode(res.body);
      if (response != null) {
        await _showToast(true);
        Navigator.push(context, MaterialPageRoute(builder: (context) =>ProjDetails(response["id"])));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    flutterToast = FlutterToast(context);
  }
  getUserInfo() async {
    String email = await StorageUtil.getStringItem("email");
    String uname = await StorageUtil.getStringItem("username");
    String add = await StorageUtil.getStringItem("address");
    String phone = await StorageUtil.getStringItem("phone");
    int uid = await StorageUtil.getIntItem("uid");

    if (uid != null) {
      setState(() {
//        _email = email;
        _owner = uname;
        _address = add;
//        _tel = phone;
        _oid=uid;
      });
    }
  }
  _showToast(bool t) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(t?Icons.check:Icons.clear),
          SizedBox(
            width: 12.0,
          ),
          Text(t?"Success":"At Most 5 Skills"),
        ],
      ),
    );

    flutterToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showSimpleDialog() {
    onSkillChange(var skills) {
      if (selSkills.length <= 5) {
        setState(() {
          selSkills = selSkills;
        });
        Navigator.pop(context);
        _showToast(true);
      } else
        _showToast(false);
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(title: Text('Edit'),
                // 这里传入一个选择器列表即可
                children: [
                  SkillDialog(
                    skillChoose: this.selSkills,
                    onSkillChanged: onSkillChange,
                  ),
                ]));
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

    List<Widget> skillManageList = selSkills
        .map((skill) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.black12,
              ),
              child: Text(skill, style: TextStyle(height: 1)),
            ))
        .toList();
    skillManageList.add(Container(
      child: SizedOverflowBox(
        size: Size(32, 32),
        alignment: Alignment.center,
        child: IconButton(
          // action button
          icon: new Icon(Icons.add_circle),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            _showSimpleDialog();
          },
        ),
      ),
    ));

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
                        val.length < 2 ? 'Please input your name' : null,
                    onSaved: (val) => _owner = val,
                        controller: _owner==null?null:new TextEditingController(text: '$_owner'),
                  ))
                ]),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Address"),
                  validator: (val) =>
                      val.length < 4 ? 'Please enter work location' : null,
                  onSaved: (val) => _address = val,
                  controller: _address==null?null:new TextEditingController(text: '$_address'),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Budget"),
                  validator: (val) =>
                  val.length < 1 ? 'Please enter your budget' : null,
                  onSaved: (val) => _budget = val,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: new Text('Choose Needed Skills')),
                new Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: Wrap(
                      children: skillManageList,
                    )),

//                new Align(
//                    alignment: new FractionalOffset(0.0, 0.0),
//                    child:
//                        new Text('Budget：若不填写max，则默认无上限，不填写min，则默认下限为0，均不填则为面议')),
//                Row(children: <Widget>[
//                  new Expanded(
//                      child: TextFormField(
//                    decoration: new InputDecoration(labelText: "Min"),
//                    onSaved: (val) => _min = val,
//                  )),
//                  new Text('  '),
//                  new Expanded(
//                      child: TextFormField(
//                    decoration: new InputDecoration(labelText: "Max"),
//                    onSaved: (val) => _max = val,
//                  ))
//                ]),
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
                      'Choose',
//                      style: new TextStyle(color: Colors.white),
                    ),
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      // 调用函数打开
                      showDatePicker(
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
                  maxLines: null,
                  //不限制行数
                  validator: (val) =>
                      val.length < 20 ? 'Description too short' : null,
                  onSaved: (val) => _description = val,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    "Submit",
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
