import 'package:flutter_driver/flutter_driver.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter_test/flutter_test.dart';
import 'package:test/test.dart';

void main() {
  group('Test one', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final title = find.byValueKey('title');
    final hiretext = find.byValueKey('hiretext');
    final worktext = find.byValueKey('worktext');
    final workbutton = find.byValueKey('workbutton');
    final hirebutton = find.byValueKey('hirebutton');
    final signin = find.byValueKey('signin');
    final email = find.byValueKey('email');
    final password = find.byValueKey('password');
    final loginbutton = find.byValueKey('login');
    final joblist = find.byValueKey('joblist');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });


    test('测试入口为home页面', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(title), "Freelancer");
      expect(await driver.getText(hiretext), "我要雇人");
      expect(await driver.getText(worktext), "我要工作");
    });

    //点击我要雇人进入登录页面，输入正确信息点击登录按钮，进入home页面。
    test('登录测试，并返回home页面', () async {
      // First, tap the button.
      await driver.tap(hirebutton);
      expect(await driver.getText(signin), 'Sign In');
      await driver.tap(email);
      await driver.enterText('dkfyfvgu@163.com');
//      await driver.waitFor(find.text('dkfyfvgu@163.com'));
      await driver.tap(password);
      await driver.enterText('536');
//      await driver.waitFor(find.text('536'));
      final emailtext = await driver.getText(email);
      print(emailtext);
      final passwordtext = await driver.getText(password);
      print(passwordtext);
      await driver.tap(loginbutton);
      expect(await driver.getText(title), "Freelancer");
      expect(await driver.getText(hiretext), "我要雇人");
      expect(await driver.getText(worktext), "我要工作");
    });


    //检测跳转到项目详情,并申请项目
    test("检测推荐列表以及项目详情跳转,并申请项目", () async{
      await driver.waitFor(find.text('Need content writer for educational website pages.'));
      await driver.tap(find.byValueKey("suggestOne"));
      expect(await driver.getText(find.byValueKey("detailTitle")), '项目详情');
      await driver.tap(find.byValueKey('apply'));
      print(await driver.getText(find.byValueKey('applyTitle')));
      await driver.tap(find.byValueKey('offer'));
      await driver.enterText('\$12');
      await driver.tap(find.byValueKey('applyDes'));
      await driver.enterText('I want it,and I am sure that I can do it perfectly!');
      await driver.tap(find.byValueKey('applySubmit'));
      expect(await driver.getText(find.byValueKey("detailTitle")), '项目详情');
    }
    );
    test('返回主页，点击我要工作,并进入工作列表', () async {
      // First, tap the button.
      await driver.tap(find.pageBack());
      await driver.tap(find.pageBack());
      await driver.tap(find.pageBack());

      expect(await driver.getText(title), "Freelancer");
      expect(await driver.getText(hiretext), "我要雇人");
      expect(await driver.getText(worktext), "我要工作");
      await driver.tap(workbutton);
      expect(await driver.getText(joblist),"项目列表");
    });

    test('返回主页，点击我要雇人,并发布项目', () async {
//      // First, tap the button.
      driver.tap(find.byValueKey('back'));
      expect(await driver.getText(title), "Freelancer");
      expect(await driver.getText(hiretext), "我要雇人");
      expect(await driver.getText(worktext), "我要工作");
      await driver.tap(hirebutton);
      expect(await driver.getText(find.byValueKey('publishTitle')),"Publish A Project");
      await driver.tap(find.byValueKey('newJobTitle'));
      await driver.enterText('newJob');
      await driver.tap(find.byValueKey('newJobBudget'));
      await driver.enterText('\$100');
      await driver.tap(find.byValueKey('newJobDescription'));
      await driver.enterText('this is new job description');
      await driver.tap(find.byValueKey('publish'));
      expect(await driver.getText(find.byValueKey("detailTitle")), '项目详情');
    });
  });
}
