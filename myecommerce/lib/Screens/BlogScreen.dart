import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Screens/BlogDetails.dart';
import 'package:myecommerce/Services/BlogServices.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogScreen extends StatefulWidget {
  static const String id = 'blogScreen-screen';

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();
  BlogServices _blogServices = BlogServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Blog',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _blogServices.getBlogList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return RefreshIndicator(
                        child: PaginateFirestore(
                          bottomLoader: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilderType: PaginateBuilderType.listView,
                          itemBuilder: (index, context, document) =>
                              GestureDetector(
                            onTap: () {
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: BlogDetails.id),
                                screen: BlogDetails(
                                  document: document,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => NewsDetails(
                              //         article: articles[index]),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey[200], width: 1.0),
                                ),
                                color: Colors.white,
                              ),
                              height: 150.0,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width *
                                        3 /
                                        5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  timeAgo(
                                                    DateTime.parse(
                                                        document['date']),
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.black26,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        5,
                                    height: 130.0,
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/placeholder.jpg',
                                      image: document['title'] == null
                                          ? 'https://i.stack.imgur.com/y9DpT.jpg'
                                          : document['image'],
                                      fit: BoxFit.fitHeight,
                                      width: double.maxFinite,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              3,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          query: _blogServices.getBlogPagination(),
                          listeners: [refreshedChangeListener],
                        ),
                        onRefresh: () async {
                          refreshedChangeListener.refreshed = true;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          ///////////////////////////////////////////////////////////////////////////
          // Container(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: _blogServices.getBlogList(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       return Padding(
          //         padding: const EdgeInsets.all(8),
          //         child: SingleChildScrollView(
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               RefreshIndicator(
          //                 child: PaginateFirestore(
          //                   bottomLoader: SizedBox(
          //                     height: 30,
          //                     width: 30,
          //                     child: CircularProgressIndicator(
          //                       valueColor: AlwaysStoppedAnimation<Color>(
          //                           Theme.of(context).primaryColor),
          //                     ),
          //                   ),
          //                   shrinkWrap: true,
          //                   physics: NeverScrollableScrollPhysics(),
          //                   itemBuilderType: PaginateBuilderType.listView,
          //                   itemBuilder: (index, context, document) => Padding(
          //                       padding: EdgeInsets.all(4),
          //                       child: Card(
          //                         elevation: 8.0,
          //                         margin: new EdgeInsets.symmetric(
          //                             horizontal: 10.0, vertical: 6.0),
          //                         child: Container(
          //                           // decoration: BoxDecoration(
          //                           //   color: Color.fromRGBO(64, 75, 96, .9),
          //                           // ),
          //                           child: ListTile(
          //                             contentPadding: EdgeInsets.symmetric(
          //                                 horizontal: 30.0, vertical: 10.0),
          //                             leading: Container(
          //                               padding: EdgeInsets.only(right: 12.0),
          //                               decoration: new BoxDecoration(
          //                                 border: new Border(
          //                                   right: new BorderSide(
          //                                     width: 1.0,
          //                                     color: Colors.black26,
          //                                   ),
          //                                 ),
          //                               ),
          //                               child: Image(
          //                                 image: NetworkImage(
          //                                   document['image'],
          //                                 ),
          //                               ),
          //                             ),
          //                             title: Text(
          //                               "Introduction to Driving",
          //                               style: TextStyle(
          //                                 color: Colors.black26,
          //                                 fontWeight: FontWeight.bold,
          //                               ),
          //                             ),
          //                             // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          //                             subtitle: Row(
          //                               children: <Widget>[
          //                                 Icon(
          //                                   Icons.linear_scale,
          //                                   color: Colors.yellowAccent,
          //                                 ),
          //                                 Text(
          //                                   " Intermediate",
          //                                   style: TextStyle(
          //                                     color: Colors.black26,
          //                                   ),
          //                                 )
          //                               ],
          //                             ),
          //                             trailing: Icon(
          //                               Icons.keyboard_arrow_right,
          //                               color: Colors.black26,
          //                               size: 30.0,
          //                             ),
          //                           ),
          //                         ),
          //                       )),
          //                   query: _blogServices.getBlogPagination(),
          //                   listeners: [refreshedChangeListener],
          //                 ),
          //                 onRefresh: () async {
          //                   refreshedChangeListener.refreshed = true;
          //                 },
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
