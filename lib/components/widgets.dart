import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nee_swarth/home.dart';
import 'package:nee_swarth/productInfo.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//          SizedBox(
//            height: 50.0,
//          ),
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              accountName: Text("Asim Siddiqui"),
              accountEmail: Text("asimsiddiqui@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0, color: Color(0xffc4a07e)),
                ),
              ),
            ),
//          DrawerItems(icon:Icons.queue_music, 'Home', Home()),
            DrawerItems(
                icon: Icons.queue_music, title: 'Aarti', createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.calendarAlt,
                title: 'Festive Calendar',
                createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.facebook,
                title: 'Visit Our Facebook Page',
                createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.instagram,
                title: 'Visit Our Instagram Page',
                createPage: Home()),
            Container(
              margin: EdgeInsets.all(20.0),
              height: 1.0,
              color: Color(0xffced4da),
            ),
//          DrawerItems(
//              icon: IconData(0xe900, fontFamily: 'track_order'),
//              title: 'Track Order',
//              createPage: Home()),
            DrawerItems(
                icon: Icons.location_on,
                title: 'Track Order',
                createPage: Home()),
            DrawerItems(
                icon: Icons.info_outline,
                title: 'About Us',
                createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.thumbsUp,
                title: 'Rate This App',
                createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.phoneVolume,
                title: 'Rate This App',
                createPage: Home()),
            DrawerItems(
                icon: FontAwesomeIcons.gift,
                title: 'Gift Cards',
                createPage: Home()),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.transparent,
                  width: double.infinity,
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Country',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          Container(
                              height: 20.0,
                              child: Image.asset('assets/india.png')),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'India',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  DrawerItems({this.title, this.createPage, this.icon});
  final String title;
  final IconData icon;
//  final Function onTap;
  final Widget createPage;
//  final String ClassName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return createPage;
        }));
      },
      child: Container(
        margin: EdgeInsets.only(top: 2.0),
        padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: Colors.white,
            ),
            SizedBox(width: 20.0),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderListView extends StatelessWidget {
  HeaderListView(this.imagePath, this.title);
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
//          Container(height: 40.0, child: Image.asset(imagePath)),
          Container(
              height: 40.0,
              child: Image(
                image: NetworkImage(imagePath),
              )),
          SizedBox(height: 10.0),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProductDisplay extends StatelessWidget {
  ProductDisplay(this.imagePath, this.productName, this.price);
  final String imagePath;
  final String productName;
  final String price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductInfo(
                  name: productName,
                  imagePath: imagePath,
                  price: price,
                )));
      },
      child: Container(
        width: 160,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, top: 20.0),
          child: Column(
            children: [
              Container(
                  child: Image(
                image: NetworkImage('$imagePath'),
              )),
              Row(
                children: [
                  Container(
                    child: Text(
                      productName,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(FontAwesomeIcons.plusSquare, color: Color(0xffc4a07e)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(FontAwesomeIcons.rupeeSign,
                      size: 12.0, color: Color(0xffc4a07e)),
                  Text(
                    price,
                    style: TextStyle(color: Color(0xffc4a07e)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//class BottomNav extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return BottomNavigationBar(
////      backgroundColor: Color(0xffc4a07e),
//      backgroundColor: Colors.transparent,
//      type: BottomNavigationBarType.fixed,
//      items: [
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(
//              FontAwesomeIcons.music,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
//          title: Text(
//            "Aarti",
//            style: TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        ),
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(
//              FontAwesomeIcons.calendarAlt,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
//          title: Text(
//            "Calendar",
//            style: TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        ),
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(
//              FontAwesomeIcons.home,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
//          title: Text(
//            "Home",
//            style: TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        ),
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(
//              FontAwesomeIcons.thLarge,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
//          title: Text(
//            "Categories",
//            style: TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        ),
//        BottomNavigationBarItem(
//          icon: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Icon(
//              FontAwesomeIcons.user,
//              color: Colors.white,
//              size: 20.0,
//            ),
//          ),
//          title: Text(
//            "Profile",
//            style: TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        ),
//      ],
//      onTap: (index) {
//        if (index == 0) {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Aarti()));
//        }
//        if (index == 1) {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Home()));
//        }
//        if (index == 2) {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Home()));
//        }
//        if (index == 3) {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Categories()));
//        }
//        if (index == 4) {
//          Navigator.push(
//              context, MaterialPageRoute(builder: (context) => Profile()));
//        }
//      },
//    );
//  }
//}

class PlaySoundCard extends StatelessWidget {
  PlaySoundCard(this.imagePath);
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(20.0),
        height: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(
              imagePath,
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            color: Color(0xffc4a07e),
            width: double.infinity,
            height: 30.0,
            child: Center(
              child: Text(
                "Play Sound",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard({this.title, this.imagePath});
  final String imagePath;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      height: 160.0,
      width: 160.0,
      decoration: BoxDecoration(
        // boxShadow: [
        //   const BoxShadow(
        //     color: Colors.black,
        //   ),
        //   const BoxShadow(
        //     color: Colors.white,
        //     spreadRadius: -2.0,
        //     blurRadius: 12.0,
        //   ),
        // ],
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.only(left: 5.0, bottom: 5.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
