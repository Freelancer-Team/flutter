import 'package:freelancer_flutter/utilities/StorageUtil.dart';

class Account {
  static saveUserInfo(response) {
    StorageUtil.setStringItem("email", response["email"]);
    StorageUtil.setStringItem("telephone", response["phone"]);
    StorageUtil.setStringItem("username", response["name"]);
    StorageUtil.setStringItem("uid", response["id"]);
    StorageUtil.setStringItem("address", response["id"]);
  }

  static delUserInfo() {
    StorageUtil.clear();
  }
  static getUserInfo() {
  }
}
