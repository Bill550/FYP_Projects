import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myecommerce/Services/BlogServices.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class BlogScreen extends StatefulWidget {
  static const String id = 'myFavourite-screen';

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
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _blogServices.getBlogList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RefreshIndicator(
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
                          itemBuilder: (index, context, document) => Padding(
                              padding: EdgeInsets.all(4),
                              child: Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   color: Color.fromRGBO(64, 75, 96, .9),
                                  // ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 10.0),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12.0),
                                      decoration: new BoxDecoration(
                                        border: new Border(
                                          right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                      child: Image(
                                        image: NetworkImage(
                                          document['image'],
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "Introduction to Driving",
                                      style: TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.linear_scale,
                                          color: Colors.yellowAccent,
                                        ),
                                        Text(
                                          " Intermediate",
                                          style: TextStyle(
                                            color: Colors.black26,
                                          ),
                                        )
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.black26,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              )),
                          query: _blogServices.getBlogPagination(),
                          listeners: [refreshedChangeListener],
                        ),
                        onRefresh: () async {
                          refreshedChangeListener.refreshed = true;
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
