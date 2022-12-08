import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rank133/Colors/Colors.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/restrauntScreen.dart';

class RestrauntList extends StatefulWidget {
  static const routeName = '/home';
  const RestrauntList({Key? key, User? user}) : super(key: key);
  
  @override
  _RestrauntListState createState() => _RestrauntListState();

}



class _RestrauntListState extends State<RestrauntList> {
  final CollectionReference _cafes = FirebaseFirestore.instance.collection('CafeName');

  @override
  Widget build(BuildContext context) {

  // List <Widget> stars = <Widget>[];

  List<Widget> _getNumberOfStars(int rating){
    List <Widget> stars = <Widget>[];
    for(int i=0;i<rating;i++)
    {
        stars.add(
          Icon(
            Icons.star,
            color: iconsColor,
          ));
    }
    return stars;
  }

    return Scaffold(
      body: StreamBuilder(
        // backgroundColor: screenBackgroundColor,
        // child: _widgetOptions.elementAt(_selectedIndex),
        stream: _cafes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,                    
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RestrauntScreen(documentSnapshot)),
                          );
                        },
                      leading: Image.network(documentSnapshot["Images"][0]),
                      title: Text(documentSnapshot["Name"]),
                      subtitle: Text(documentSnapshot["Address"]),
                      ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _getNumberOfStars(documentSnapshot["Ratings"]),
                      ),
                    ],
                  ),
                );

      //           return Center(
      //             child: Card(
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: <Widget>[
      //               Card(
      //                 margin: const EdgeInsets.all(5),
      //                 child: ListTile(
      //                 leading: Image.network(documentSnapshot["Images"][0]),
      //                 title: Text(documentSnapshot["Name"]),
      //                 subtitle: Text(documentSnapshot["Address"]),
      //                 ),
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.end,
      //                 children: <Widget>[
      //                   Icon(Icons.star)
      //                 ],
      //                ),
      //     ]
      //   ),
      // ),
    // );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

