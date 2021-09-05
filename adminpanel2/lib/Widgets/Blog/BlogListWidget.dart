import 'dart:ui';
import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/Widgets/Blog/EditBlogScreen.dart';
import 'package:adminpanel2/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    var totalDataCount = 0;
    List<DocumentSnapshot> data;

    return StreamBuilder<QuerySnapshot>(
      stream: _services.blog.orderBy('date', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          data = snapshot.data.docs;
          totalDataCount = data.length;
        }

        print(totalDataCount);

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
          ),
          itemCount: totalDataCount,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(data[index]['title']),
                      subtitle: Text(
                        '${DateFormat.yMMMd().format(DateTime.parse(data[index]['date']))}',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 6,
                      child: Image.network(
                        data[index]['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        data[index]['description'],
                        maxLines: 5,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            _services.confirmDeleteBlog(
                              context: context,
                              title: 'Delete Blog',
                              message: 'Are you sure you want to delete?',
                              id: data[index].id,
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            primary: Colors.white,
                          ),
                          child: Text('Delete'),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditBlogScreen(
                                  blogId: data[index].id,
                                );
                              },
                            );
                          },
                          child: Text('Edit'),
                          style: TextButton.styleFrom(
                            backgroundColor: blackColor,
                            primary: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              ///////////////////////////////////////////////////////////////////////////
              // child: GFCard(
              //   boxFit: BoxFit.cover,
              //   image: Image(image: NetworkImage(data[index]['image'])),
              //   title: GFListTile(
              //     // avatar: GFAvatar(
              //     //   backgroundImage: NetworkImage(data[index]['image']),
              //     //   shape: GFAvatarShape.standard,
              //     // ),
              //     title: Text(data[index]['title']),
              //     subTitle: Text(
              //       data[index]['date'],
              //       maxLines: 2,
              //     ),
              //   ),
              //   content: Text(
              //     data[index]['description'],
              //     maxLines: 4,
              //   ),
              //   buttonBar: GFButtonBar(
              //     children: <Widget>[
              //       GFButton(
              //         color: Colors.redAccent,
              //         onPressed: () {
              //           _services.confirmDeleteBlog(
              //             context: context,
              //             title: 'Delete Blog',
              //             message: 'Are you sure you want to delete?',
              //             id: data[index].id,
              //           );
              //         },
              //         text: 'Delete',
              //       ),
              //       GFButton(
              //         color: Colors.greenAccent,
              //         onPressed: () {},
              //         text: 'Edit',
              //       ),
              //     ],
              //   ),
              // ),
              /////////////////////////////////////////////////////////////////////////////////
              // child: Stack(
              //   children: [
              //     SizedBox(
              //       height: 200,
              //       child: Card(
              //         elevation: 10,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(4),
              //           child: Image.network(
              //             data[index]['image'],
              //             width: 400,
              //             fit: BoxFit.fill,
              //           ),
              //           // child: Text(document['image']),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //       child: CircleAvatar(
              //         backgroundColor: Colors.white,
              //         child: IconButton(
              //           icon: Icon(
              //             Icons.delete,
              //             color: Colors.red,
              //           ),
              //           onPressed: () {
              //             print(data[index].id);
              //             _services.confirmDeleteBlog(
              //               context: context,
              //               title: 'Delete Blog',
              //               message: 'Are you sure you want to delete?',
              //               id: data[index].id,
              //             );
              //           },
              //         ),
              //       ),
              //       top: 10,
              //       right: 10,
              //     )
              //   ],
              // ),
            );
          },
        );
      },
    );
  }
}


// import 'package:adminpanel2/Services/Firebase_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class BlogListWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     FirebaseServices _services = FirebaseServices();

//     return StreamBuilder<QuerySnapshot>(
//       stream: _services.blog.snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return Container(
//           width: MediaQuery.of(context).size.width,
//           height: 700,
//           child: ListView(
//             scrollDirection: Axis.vertical,
//             children: snapshot.data.docs.map(
//               (DocumentSnapshot document) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: Stack(
//                       children: [
//                         SizedBox(
//                           height: 500,
//                           child: Card(
//                             elevation: 10,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: Image.network(
//                                 document['image'],
//                                 width: MediaQuery.of(context).size.width - 20,
//                                 fit: BoxFit.fill,
//                               ),
//                               // child: Text(document['image']),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           child: CircleAvatar(
//                             backgroundColor: Colors.white,
//                             child: IconButton(
//                               icon: Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () {
//                                 _services.confirmDeleteBlog(
//                                   context: context,
//                                   title: 'Delete Blog',
//                                   message: 'Are you sure you want to delete?',
//                                   id: document.id,
//                                 );
//                               },
//                             ),
//                           ),
//                           top: 10,
//                           right: 10,
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ).toList(),
//           ),
//         );
//       },
//     );
//   }
// }
