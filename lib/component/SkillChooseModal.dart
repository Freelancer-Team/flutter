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
