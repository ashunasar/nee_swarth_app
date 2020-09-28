import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nee_swarth/Profile.dart';
import 'package:nee_swarth/aarti.dart';
import 'package:nee_swarth/cart.dart';
import 'package:nee_swarth/categories.dart';
import 'package:nee_swarth/components/widgets.dart';
import 'package:nee_swarth/home.dart';
import 'package:nee_swarth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          body: Container(
            color: Color(0xfff9f9f9),
            child: Center(child: Image.asset('assets/wishlist.png')),
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
