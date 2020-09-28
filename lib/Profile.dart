import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nee_swarth/aarti.dart';
import 'package:nee_swarth/categories.dart';
import 'package:nee_swarth/components/constants.dart';
import 'package:nee_swarth/components/widgets.dart';
import 'package:nee_swarth/home.dart';
import 'package:nee_swarth/login.dart';
import 'package:nee_swarth/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    getEmail();
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
//                  height: 250.0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Color(0xffc4a07e),
                          size: 40.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      FutureBuilder(
                        future: getEmail(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Text(
                            snapshot.data,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(30.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.tasks),
                            SizedBox(height: 5.0),
                            Text(
                              "My Orders",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.heart),
                            SizedBox(height: 5.0),
                            Text(
                              "Wishlist",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.bell),
                            SizedBox(height: 5.0),
                            Text(
                              "Notification",
                              style: TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Wishlist())),
                  child: Container(
                    margin: EdgeInsets.only(left: 35.0, right: 100.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "My Shipping Address",
                          style: kViewAllStile,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Wishlist())),
                  child: Container(
                    margin: EdgeInsets.only(left: 35.0, right: 100.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.userAlt,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "Profile Details ",
                          style: kViewAllStile,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Wishlist())),
                  child: Container(
                    margin: EdgeInsets.only(left: 35.0, right: 100.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.tags,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "Coupons",
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
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Wishlist())),
                  child: Container(
                    margin: EdgeInsets.only(left: 35.0, right: 100.0),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.powerOff,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "Logout",
                          style: kViewAllStile,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
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
