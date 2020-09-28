import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nee_swarth/Profile.dart';
import 'package:nee_swarth/aarti.dart';
import 'package:nee_swarth/cart.dart';
import 'package:nee_swarth/categories.dart';
import 'package:nee_swarth/components/constants.dart';
import 'package:nee_swarth/components/widgets.dart';
import 'package:nee_swarth/login.dart';
import 'package:nee_swarth/view_all.dart';
import 'package:nee_swarth/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _current = 0;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getHeaderProducts();
    getCrousalImages();
    getProductList();
  }

  // api for header products
  Future getHeaderProducts() async {
    List<GestureDetector> headerProducts = [];
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/productApi.php";
    http.Response response = await http.post(
      url,
      body: {'request': 'showHeaderProducts'},
    );

    var decodedJson = jsonDecode(response.body);

    decodedJson.forEach((element) {
      headerProducts.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewAll(
                        text: element['category'],
                      )));
        },
        child: HeaderListView(
            "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/images/${element['productImage']}",
            element['productName']),
      ));
    });
    return ListView(
      scrollDirection: Axis.horizontal,
      children: headerProducts,
    );
  } // end of api for header products

  // api for crousal Images
  Future getCrousalImages() async {
    List<GestureDetector> imgList = [];
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/productApi.php";
    http.Response response = await http.post(
      url,
      body: {'request': 'showCrousalImages'},
    );

    var decodedJson = jsonDecode(response.body);

    decodedJson.forEach((element) {
//       imgList.add(
//           "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/images/${element['imagePath']}");
// //      print(imgList);
//     });
      imgList.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewAll(
                          text: element['category'],
                        )));
          },
          child: Image.network(
              "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/images/${element['imagePath']}",
              fit: BoxFit.cover,
              width: 1000.0)));
//      print(imgList);
    });
    List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        item,
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
//                            child: Text(
//                              'No. ${imgList.indexOf(item)} image',
//                              style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 20.0,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Container(
      child: Column(children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            int index = imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Colors.white
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  } // end of api for getcrousal images

  // api for Product List

  Future getProductList() async {
    List<Widget> productListColumn = await [];
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/productApi.php";
    http.Response response = await http.post(
      url,
      body: {'request': 'categoryNames'},
    );
    var decodedJson = jsonDecode(response.body);
    // print(decodedJson);
    for (var i in decodedJson) {
      http.Response response = await http.post(
        url,
        body: {
          'request': 'productByCategoryName',
          'categoryName': i['category_name']
        },
      );
      var decodedJsonProduct = jsonDecode(response.body);
      // print(decodedJsonProduct);
      List<ProductDisplay> productList = [];
      // print(productList);
      // productList.length = 0;
      for (var j in decodedJsonProduct) {
        // print(j['name']);
        // print(j['image_path']);
        // print(j['price']);
        productList.add(ProductDisplay(
            "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/images/productImages/" +
                j['image_path'],
            j['name'],
            j['price']));
      }

      productListColumn.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  i['category_name'],
                  style: kSlideListTitle,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAll(
                              text: i['category_name'],
                            ))),
                child: Text(
                  "View all >  ",
                  style: kViewAllStile,
                ),
              ),
            ],
          ),
          Container(
            height: 180.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: productList,
            ),
          ),
        ],
      ));
      // print(productList);
    }
    return Column(
      children: productListColumn,
    );
  } // end of api for Product List

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
                  height: 100.0,
                  color: Colors.transparent,
                  child: FutureBuilder(
                      future: getHeaderProducts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xffc4a07e)),
                            ),
                          );
                        } else {
                          return snapshot.data;
                        }
                      }),
                ),
                FutureBuilder(
                    future: getCrousalImages(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffc4a07e)),
                          ),
                        );
                      } else {
                        return snapshot.data;
                      }
                    }),
                FutureBuilder(
                    future: getProductList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffc4a07e)),
                          ),
                        );
                      } else {
                        return snapshot.data;
                      }
                    }),
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
