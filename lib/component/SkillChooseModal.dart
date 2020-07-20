//import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_flutter/utilities/Skill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// The entire multilevel list displayed by this app.

typedef void AddSkillCallback(var skill);

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  final Entry entry;

  final AddSkillCallback onAddSkill;

  final List<String> skills;

  const EntryItem(this.entry, this.onAddSkill, this.skills);

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return new ListTile(title: new Text(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.children.map((child) {
        return CheckboxListTile(
          title: Text(child),
          value: this.skills.contains(child),
          onChanged: (bool value) {
            onAddSkill(child);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

typedef void SkillChangedCallback(var skills);

class SkillDialog extends StatefulWidget {
  final List<String> skillChoose;
  final SkillChangedCallback onSkillChanged;

  SkillDialog({Key key, this.skillChoose, this.onSkillChanged})
      : super(key: key);

  @override
  _SkillDialogState createState() => new _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  List<String> skillChoose = [];
  List<Entry> data = <Entry>[
    new Entry(" ", <String>[" "])
  ];

  @override
  void initState() {
    super.initState();
    getData();
    skillChoose = widget.skillChoose;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.dispose();
  }

  void addOrDeleteSkill(skill) {
    setState(() {
      if (skillChoose.contains(skill)) {
        skillChoose.remove(skill);
      } else {
        skillChoose.add(skill);
      }
    });
  }

  getData() async {
    try {
      String url = "http://localhost:8080/getSkills";
      var res = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      var response = json.decode(res.body);
      int l = response.length;
      int i = 0;
      data.clear();
      String cname = response[0]["category"]["name"];
      List<String> newchild;
      int k=0;
      bool flag=false;
      while (i < l) {
        flag=false;
        cname = response[i]["category"]["name"];
        for(k=0;k<data.length;k++){
          if(data[k].title==cname)
            {flag=true;break;}
        }
        if(!flag){
        while (i < l && response[i]["category"]["name"] == cname) {
          newchild = new List();
          newchild.add(response[i]["name"]);
          i++;
        }
        Entry newc = new Entry(cname, newchild);
        data.add(newc);}
        else{
          while (i < l && response[i]["category"]["name"] == cname) {
            data[k].children.add(response[i]["name"]);
            i++;
          }
        }
      }
      setState(() {
        data = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: data
                  .map((e) => EntryItem(e, addOrDeleteSkill, skillChoose))
                  .toList(),
            ),
          ),
        ),
        Wrap(
          children: skillChoose
              .map((skill) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.black12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          skill,
                          style: TextStyle(height: 1),
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        SizedOverflowBox(
                          size: Size(14, 14),
                          alignment: Alignment.center,
                          child: IconButton(
                            // action button
                            icon: new Icon(Icons.close),
                            iconSize: 14,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              addOrDeleteSkill(skill);
                            },
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        FlatButton(
          onPressed: () {
            widget.onSkillChanged(skillChoose);
          },
          child: Text("确认"),
        ),
      ],
    );
  }
}
