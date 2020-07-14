import 'package:flutter/material.dart';


// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  new Entry('Chapter A',
    <Entry>[
      new Entry('Section A0'),
      new Entry('Section A1'),
      new Entry('Section A2'),
    ],
  ),
  new Entry('Chapter B',
    <Entry>[
      new Entry('Section B0'),
      new Entry('Section B1'),
    ],
  ),
  new Entry('Chapter C',
    <Entry>[
      new Entry('Section C0'),
      new Entry('Section C1'),
      new Entry('Section C2',),
    ],
  ),
];


typedef void AddSkillCallback(var skill);

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  final Entry entry;

  final AddSkillCallback onAddSkill;

  final List<String> skills;

  const EntryItem(this.entry, this.onAddSkill, this.skills);

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new ListTile(title: new Text(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.children.map((child){
        return CheckboxListTile(
          title: Text(child.title),
          value: this.skills.contains(child.title),
          onChanged: (bool value) {onAddSkill(child.title);},
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

class SkillDialog extends StatefulWidget{
  final List<String> skillChoose;

  final SkillChangedCallback onSkillChanged;

  SkillDialog({Key key, this.skillChoose, this.onSkillChanged}) : super(key: key);

  @override
  _SkillDialogState createState() => new _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  List<String> skillChoose = [];

  @override
  void initState() {
    super.initState();
    skillChoose = widget.skillChoose;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.dispose();
  }

  void addOrDeleteSkill(skill){
    setState(() {
      if (skillChoose.contains(skill)) {
        skillChoose.remove(skill);
      } else {
        skillChoose.add(skill);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: data.map((e) => EntryItem(e, addOrDeleteSkill, skillChoose)).toList(),
            ),
          ),
        ),
        Wrap(
          children: skillChoose.map((skill) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.lightGreenAccent,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(skill,
                  style: TextStyle(height: 1),
                ),
                SizedBox(
                  width: 6.0,
                ),
                SizedOverflowBox(
                  size: Size(14,14),
                  alignment: Alignment.center,
                  child: IconButton( // action button
                    icon: new Icon(Icons.close),
                    iconSize: 14,
                    padding: const EdgeInsets.all(0),
                    onPressed: () { addOrDeleteSkill(skill); },
                  ),
                ),
              ],
            ),
          )).toList(),
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
