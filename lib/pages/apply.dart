import 'package:flutter/material.dart';
import 'package:freelancer_flutter/utilities/StorageUtil.dart';
import 'package:freelancer_flutter/utilities/Account.dart';
class Skill{
  String skill;
  bool isSelected;
}
class ApplyPage extends StatefulWidget {
  @override
  _ApplyState createState() => _ApplyState();
}

class _ApplyState extends State<ApplyPage> {
  double width;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  //若有用户信息则自动填写
  String _email;
  String _name;
  int _age;
  String _gender;
  String _personalAddress;
  String _tel;
  List<String> _personalSkills;

  //从父组件传来
  String _title = 'KILL BILL';
  String _owner;
  String _budget;
  List<Skill> skills =new List();

  //必填项
  List<Skill> selSkills=new List();
  String _offer;
  String _application;

  void onSubmit() {
    final form = formKey.currentState;
    if (form.validate()&&selSkills != null) {
      form.save();
      performLogin();
    }
  }

  void performLogin() {
    final snackbar = new SnackBar(
      content: new Text("Title: $_title, desc : $_application"),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    addSkills();
  }

    getUserInfo() async {
      String email = await StorageUtil.getStringItem("email");
      String uname = await StorageUtil.getStringItem("username");
      String add = await StorageUtil.getStringItem("address");
      String g = await StorageUtil.getStringItem("gender");
      String phone = await StorageUtil.getStringItem("phone");
      int age = await StorageUtil.getIntItem("age");
      List<String> skills = await StorageUtil.getStringListItem("skills");

      if (email != null) {
        setState(() {
          _email = email;
          _name = uname;
          _personalAddress = add;
          _tel = phone;
          _gender = g;
          _age = age;
          print(skills);
          if (skills != null) _personalSkills = skills;
        });
      }
  }
  void addSkills(){
    //用于测试
    Skill a= new Skill();
    a.isSelected=true;a.skill='好吃懒做';
    Skill b= new Skill();
    b.isSelected=false;b.skill='混吃等死';
    skills.add(a);skills.add(b);
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Apply for $_title',
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
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Name"),
                  validator: (val) =>
                  val.length < 2 ? 'Please input your name' : null,
                  onSaved: (val) => _name= val,
                  controller:  new TextEditingController(text: '$_name'),
                ),
                Row(children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Age"),
                    validator: (val) =>
                        val.length < 1 ? 'Please input your age' : null,
                    onSaved: (val) => _age = int.parse(val),
                        controller:  new TextEditingController(text: '$_age'),
                  )),
                  new Text('  '),
                  new Expanded(
                      child: new TextFormField(
                    decoration: new InputDecoration(labelText: "Gender(F/M)"),
                    validator: (val) =>
                    val.length < 1 ? 'Please input your gender' :((val.trim()=='F'||val.trim()=='M')?'invalid gender': null),
                    onSaved: (val) => _gender = val.trim(),
                        controller:  new TextEditingController(text: '$_gender'),
                  ))
                ]),
                Row(children: <Widget>[
                  new Expanded(
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "Phone"),
                        validator: (val) =>
                        val.trim().length != 11 ? 'Please input your telephone number' : null,
                        onSaved: (val) => _tel = val.trim(),
                        controller:  new TextEditingController(text: '$_tel'),
                      )),
                  new Text('  '),
                  new Expanded(
                      child: new TextFormField(
                        decoration: new InputDecoration(labelText: "Email"),
                        validator: (val) =>
                        !val.contains('@') ? 'Invalid Email' : null,
                        onSaved: (val) => _email = val,
                        controller:  new TextEditingController(text: '$_email'),
                      ))
                ]),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Address"),
                  validator: (val) =>
                      val.length < 6 ? 'Please input your address' : null,
                  onSaved: (val) => _personalAddress = val,
                  controller:  new TextEditingController(text: '$_personalAddress'),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new Align(
                    alignment: new FractionalOffset(0.0, 0.0),
                    child: new Text('Needed Skills')),
                new Column(children: <Widget>[
                  Column(
                      children: skills.map((f) {
                    return Column(
                      children: <Widget>[
                        Container(
                          child: CheckboxListTile(
                            value: f.isSelected,
                            onChanged: (bool) {
                              setState(() {
                                f.isSelected = !f.isSelected;
                                //保存已选中的
                                if (f.isSelected) {
                                  if (!selSkills.contains(f))
                                    selSkills.add(f);
                                } //删除
                                else {
                                  if (selSkills != null &&
                                      selSkills.contains(f))
                                    selSkills.remove(f);
                                }
                              });
                            },
                            title: Text(f.skill),
                            controlAffinity: ListTileControlAffinity.platform,
                            activeColor: Colors.blue,
                          ),
                        ),
                      ],
                    );
                  }).toList())
                ]),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Offer (Expected to be paid $_budget)"),
                  validator: (val) =>
                      val.length < 6 ? 'Please enter your target salary' : null,
                  onSaved: (val) => _offer = val,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (val) =>
                      val.length < 20 ? 'Description too short' : null,
                  onSaved: (val) => _application = val,
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
