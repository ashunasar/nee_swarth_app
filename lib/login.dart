import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nee_swarth/Profile.dart';
import 'package:nee_swarth/aarti.dart';
import 'package:nee_swarth/cart.dart';
import 'package:nee_swarth/categories.dart';
import 'package:nee_swarth/components/constants.dart';
import 'package:nee_swarth/components/widgets.dart';
import 'package:nee_swarth/home.dart';
import 'package:nee_swarth/signUp.dart';
import 'package:nee_swarth/wishlist.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _current = 0;

  // Initially password is obscure
  bool _obscureText = true;

  String _passwordTxt = "show";

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _passwordTxt = (_obscureText) ? "Show" : "Hide";
    });
  }

  String _radioValue; //Initial definition of radio button value
  String choice;

  // ------ [add the next block] ------

  // ------ end: [add the next block] ------

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice); //Debug the choice in console
    });
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  ProgressDialog pr;

  void showtoast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void loginUser({
    String request,
  }) async {
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/usersApi.php";
    http.Response response = await http.post(
      url,
      body: {
        'request': request,
        'email': email.text,
        'password': password.text,
      },
    );
    print(response.body);
    var decodedJson = jsonDecode(response.body);
    var msg = decodedJson['data'][0]['message'];

    if (msg == "success") {
      await pr.hide();

      SharedPreferences storedData = await SharedPreferences.getInstance();
      storedData.setString('email', email.text);
      showtoast("Signup successfully", Colors.green);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Home()));
    } else {
      showtoast(msg, Colors.red);
    }
  }

  Future<String> getEmail() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    return storedData.getString('email');
  }

  void check() async {
    if (await getEmail() != null) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => Profile()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
        message: "Please Wait.....",
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color(0xff0a601f),
              Color(0xff835d0a),
              Color(0xffd15716),
              Color(0xffc64679),
              Color(0xff90245e),
              Color(0xff3e2254),
              Color(0xff13324f),
              Color(0xff87c9de),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          drawer: DrawerMenu(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Container(
              width: 100.0,
              margin: EdgeInsets.only(left: 30.0),
              child: Image(
                image: AssetImage('assets/new_mpb_logo.png'),
              ),
            ),
            leading: GestureDetector(
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 5.0, top: 20.0, bottom: 20.0),
                child: Image(
                  image: AssetImage('assets/new_menu.png'),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Color(0xffc4a07e),
                  size: 28.0,
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.heart, color: Color(0xffc4a07e)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wishlist())),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.shoppingBag,
                    color: Color(0xffc4a07e)),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart())),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 150.0,
                  child: Center(
                    child: Text(
                      "Sign In to your Account",
                      style: kSlideListTitle,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: email,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Color(0xffc4a07e),
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.only(bottom: -20),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffc4a07e), width: 3.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextField(
                    controller: password,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Color(0xffc4a07e),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.only(bottom: -20),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 3.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffc4a07e), width: 3.0),
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.brown, width: 3.0)),
                      suffix: GestureDetector(
                        onTap: () {
                          _toggle();
                        },
                        child: Text(
                          _passwordTxt,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 18.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 'one',
                            groupValue: _radioValue,
                            onChanged: radioButtonChanges,
                            activeColor: Color(0xffc4a07e),
                          ),
                          Text(
                            "Remember Me",
                            style: kViewAllStile,
                          ),
                        ],
                      ),
                      Text(
                        "Forgot Password ? ",
                        style: kViewAllStile,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () async {
//                      await pr.show();
                      loginUser(request: 'login');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      child: Card(
                        color: Color(0xffc4a07e),
                        child: Center(
                            child: Text(
                          "SIGN IN",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              letterSpacing: 1.5),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Wishlist())),
                  child: Container(
//                  color: Colors.red,
                    margin: EdgeInsets.only(left: 35.0, right: 100.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.heart,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "Product Wishlist ",
                          style: kViewAllStile,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.questionCircle,
                        size: 18.0,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        "Help",
                        style: kViewAllStile,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  margin: EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: kViewAllStile,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp())),
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xffffcea1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
//      backgroundColor: Color(0xffc4a07e),
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.music,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Aarti",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.calendarAlt,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Calendar",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.home,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.thLarge,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Categories",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Aarti()));
              }
              if (index == 1) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }
              if (index == 2) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }
              if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Categories()));
              }
              if (index == 4) {
                check();
              }
            },
          ),
        ),
      ),
    );
  }
}
