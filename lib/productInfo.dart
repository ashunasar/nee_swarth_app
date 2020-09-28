import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nee_swarth/cart.dart';
import 'package:nee_swarth/components/widgets.dart';
import 'package:nee_swarth/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfo extends StatefulWidget {
  final String name;
  final String imagePath;
  final String price;
  ProductInfo({
    @required this.name,
    @required this.imagePath,
    @required this.price,
  });
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<String> getEmail() async {
    SharedPreferences storedData = await SharedPreferences.getInstance();
    return storedData.getString('email');
  }

  Future getProductDescription() async {
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/panel/productApi.php";
    http.Response response = await http.post(
      url,
      body: {
        'request': 'showProductDescription',
        'name': widget.name,
        'image_path': widget.imagePath.substring(87),
        'price': widget.price,
      },
    );
    var decodedJson = jsonDecode(response.body);
    // print(decodedJson[0]['description']);
    // return decodedJson[0]['description'];
    return Text(
      decodedJson[0]['description'],
      softWrap: true,
      style: TextStyle(fontSize: 16.0),
    );
  }

  Future addToCart() async {
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/usersApi.php";
    http.Response response = await http.post(
      url,
      body: {
        'request': 'addToCart',
        'product_image': widget.imagePath.substring(87),
        'product_quantity': itemCount.toString(),
        'product_price': widget.price,
        'user_email': await getEmail(),
      },
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            message: Text(
              "${widget.name} added to your Cart",
              style: TextStyle(color: Colors.pinkAccent, fontSize: 20.0),
            ),
            actions: [
              CupertinoActionSheetAction(
                child: Text("Go To Cart"),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Cart()));
                },
              ),
              CupertinoActionSheetAction(
                child: Text("Continue Shopping"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductDescription();
    updateWishlist();
  }

  int itemCount = 1;

  void incrementItemCount() {
    setState(() {
      itemCount += 1;
    });
  }

  void decrementItemCount() {
    setState(() {
      if (!(itemCount <= 1)) {
        itemCount -= 1;
      }
    });
  }

  IconData wishlistIcon = FontAwesomeIcons.heart;

  void updateWishlist() async {
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/usersApi.php";
    http.Response response = await http.post(
      url,
      body: {
        'request': 'lookOverProductWishlist',
        'product_image': widget.imagePath.substring(87),
        'user_email': await getEmail(),
      },
    );

    var decodedJson = jsonDecode(response.body);
    // print(decodedJson);
    var count = decodedJson['data'][0]['count'];
    // print(count);
    if (count == 1) {
      setState(() {
        wishlistIcon = FontAwesomeIcons.solidHeart;
      });
    } else {
      setState(() {
        wishlistIcon = FontAwesomeIcons.heart;
      });
    }
  }

  void addToWishlist() async {
    String url =
        "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/usersApi.php";
    http.Response response = await http.post(
      url,
      body: {
        'request': 'addToWishlist',
        'product_image': widget.imagePath.substring(87),
        'product_quantity': "1",
        'product_price': widget.price,
        'user_email': await getEmail(),
      },
    );
    if (wishlistIcon == FontAwesomeIcons.heart) {
      setState(() {
        wishlistIcon = FontAwesomeIcons.solidHeart;
      });
    } else {
      setState(() {
        wishlistIcon = FontAwesomeIcons.heart;
      });
    }
  }

  // void deleteWishlist() async {
  //   String url =
  //       "http://phpstack-310033-1361759.cloudwaysapps.com/nee_swarth/usersApi.php";
  //   http.Response response = await http.post(
  //     url,
  //     body: {
  //       'request': 'deleteWishlist',
  //       'product_image': widget.imagePath.substring(87),
  //       'user_email': await getEmail(),
  //     },
  //   );
  //   setState(() {
  //     wishlistIcon = FontAwesomeIcons.heart;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                      widget.imagePath,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                    // color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: Text(
                              widget.name,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 20.0,
                                      wordSpacing: 2.0,
                                      color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.0),
                        GestureDetector(
                          onTap: () {
                            addToWishlist();
                          },
                          child: Icon(
                            wishlistIcon,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20.0),
                Container(
                    // color: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      FontAwesomeIcons.rupeeSign,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.price,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.0),
                        // Icon(
                        //   FontAwesomeIcons.heart,
                        //   color: Colors.white,
                        // ),
                      ],
                    )),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        "Quantity : ",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(width: 20.0),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => decrementItemCount(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  FontAwesomeIcons.minus,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 30,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                itemCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => incrementItemCount(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 1.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandablePanel(
                        header: Container(
                            child: Text(
                          "Product Description",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 18.0,
                            wordSpacing: 2.0,
                          )),
                        )),
                        expanded: FutureBuilder(
                          future: getProductDescription(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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
                          },
                        ),

                        // tapHeaderToExpand: true,
                        // hasIcon: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpandablePanel(
                        header: Container(
                            child: Text(
                          "Shipping & Returns",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 18.0,
                            wordSpacing: 2.0,
                          )),
                        )),

                        expanded: Text(
                          "shipping Policy",
                          softWrap: true,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        // tapHeaderToExpand: true,
                        // hasIcon: true,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          child: FlatButton(
                            onPressed: () {
                              addToCart();
                              showActionSheet(context);
                            },
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(color: Color(0xffc4a07e)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: FlatButton(
                            onPressed: () {
                              addToCart();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Cart()));
                            },
                            child: Text("BUY NOW",
                                style: TextStyle(color: Colors.pink)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
