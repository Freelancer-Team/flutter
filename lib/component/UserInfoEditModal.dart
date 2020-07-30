import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freelancer_flutter/component/LiteSwitch.dart';
import 'hotel_app_theme.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoEditModal extends StatefulWidget {
  const UserInfoEditModal(
      {Key key,
        this.userInfo,
        this.onApplyClick,
        this.onCancelClick,
      })
      : super(key: key);

  final FoundationInfo userInfo;
  final Function(FoundationInfo) onApplyClick;

  final Function onCancelClick;
  @override
  _UserInfoEditModalState createState() => _UserInfoEditModalState();
}

class _UserInfoEditModalState extends State<UserInfoEditModal>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final ValueNotifier<bool> switchState = new ValueNotifier<bool>(true);

  FoundationInfo userInfo = FoundationInfo(
    name: '',
    gender: 'M',
    age: 0,
    phone: '',
    address: '',
    description: ''
  );
  final picker = ImagePicker();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController.forward();
    super.initState();
    setState(() {
      userInfo = widget.userInfo;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      userInfo.image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: animationController.value,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: SizedBox(
                    width: 400,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: InkWell(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      '编辑资料',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 24, bottom: 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      userInfo.image == null
                                          ? CircleAvatar(
                                        backgroundImage: AssetImage('assets/ProfileImage/userIcon.jpg'),
                                        radius: 50,
                                      )
                                          : CircleAvatar(
                                        backgroundImage: FileImage(userInfo.image),
                                        radius: 50,
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    bottom: 11,
                                    right: 140,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Icon(Icons.camera, size: 30, color: Colors.orangeAccent,),
                                        onPressed: getImage,
                                        tooltip: '选择头像',
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      '昵称',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.35),
                                              offset: const Offset(2, 2),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: TextField(
                                          controller: TextEditingController()
                                            ..text = userInfo.name,
                                          onChanged: (String txt) {
                                            userInfo.name = txt;
                                          },
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          cursorColor: HexColor('#54D3C2'),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'User Name',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 - 5,
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                          child: SizedBox(
                                            width: 65,
                                            child: Text(
                                              '性别',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black54
                                              ),
                                            ),
                                          )
                                      ),
                                      LiteSwitch(
                                        switchState: switchState,
                                        initValue: userInfo.gender == 'M'? true : false,
                                        textSize: 14.0,
                                        iWidth: 80,
                                        iHeight: 30,
                                        textOn: '男性',
                                        textOff: '女性',
                                        colorOn: Colors.blueAccent,
                                        colorOff: Colors.pinkAccent,
                                        iconOn: FontAwesomeIcons.mars,
                                        iconOff: FontAwesomeIcons.venus,
                                        onChanged: (bool state) {
                                          setState(() {
                                            if(userInfo.gender == 'M') userInfo.gender = 'F';
                                            else userInfo.gender = 'M';
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 8, bottom: 8),
                                          child: SizedBox(
                                            width: 65,
                                            child: Text(
                                              '年龄',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black54
                                              ),
                                            ),
                                          )
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                                          child: InkWell(
                                            onTap: (){
                                              showPickerNumber(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFFFFF),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: Colors.grey.withOpacity(0.35),
                                                      offset: const Offset(2, 2),
                                                      blurRadius: 8.0),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(userInfo.age.toString(), style: TextStyle(fontSize: 18)),
                                                        Text(" 岁", style: TextStyle(fontSize: 17),)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      '电话',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.35),
                                              offset: const Offset(2, 2),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: TextField(
                                          controller: TextEditingController()
                                            ..text = userInfo.phone,
                                          onChanged: (String txt) {
                                            userInfo.phone = txt;
                                          },
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          cursorColor: HexColor('#54D3C2'),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Phone Number',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                  child: SizedBox(
                                    width: 80,
                                    child: Text(
                                      '地址',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.35),
                                              offset: const Offset(2, 2),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: TextField(
                                          controller: TextEditingController()
                                            ..text = userInfo.address,
                                          onChanged: (String txt) {
                                            userInfo.address = txt;
                                          },
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          cursorColor: HexColor('#54D3C2'),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Address',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, top: 8),
                                  child: Text(
                                    '个人描述',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.withOpacity(0.35),
                                              offset: const Offset(2, 2),
                                              blurRadius: 8.0),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: TextField(
                                          controller: TextEditingController()
                                            ..text = userInfo.description,
                                          onChanged: (String txt) {
                                            userInfo.description = txt;
                                          },
                                          maxLines: 5,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                          cursorColor: HexColor('#54D3C2'),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Description',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 8),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      blurRadius: 8,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      widget.onApplyClick(userInfo);
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 100, jump: 1),
        ]),
        selecteds: [userInfo.age - 1],
        hideHeader: false,
        title: Text("选择年龄"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          setState(() {
            userInfo.age = picker.getSelectedValues()[0];
          });
        }
    ).showModal(context);
  }
}

class FoundationInfo{
  FoundationInfo({
    this.name,
    this.gender,
    this.age,
    this.address,
    this.phone,
    this.description
  });

  var image;
  String name;
  String gender;
  int age;
  String phone;
  String address;
  String description;
}
