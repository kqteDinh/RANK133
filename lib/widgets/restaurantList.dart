import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rank133/Colors/Colors.dart';
import 'package:rank133/Colors/appColors.dart';


class RestaurantList extends StatefulWidget {
  static const routeName = '/restaurants';
  const RestaurantList({Key? key, User? user}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}
FirebaseFirestore db = FirebaseFirestore.instance;
final cafes = db.collection("CafeName");


String name = "";
String address = "";
int rating = 0;
String imageURL = "";
String hours = "";
String parking = "";
String review = "";
List<dynamic> reviews = [];

List<Widget> _getNumberOfStars(int rating) {
  List<Widget> stars = <Widget>[];
  stars.add(
    SizedBox(width: 10),
  );
  for (int i = 0; i < rating; i++) {
    stars.add(Icon(
      Icons.star,
      color: iconsColor,
    ));
  }
  return stars;
}

List<Widget> _getReviews(List<dynamic> list) {
  List<Widget> reviews = <Widget>[];

  for (int i = 0; i < list.length; i++) {
    reviews.add(Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              list[i],
              maxLines: 3,
            ),
          ],
        )));
  }
  return reviews;
}



class _RestaurantListState extends State<RestaurantList> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _cafes =
      FirebaseFirestore.instance.collection('CafeName').snapshots();
  final  Stream<QuerySnapshot<Map<String, dynamic>>> _restaurants =
      FirebaseFirestore.instance.collection('RestaurantName').snapshots();

      
// final Stream<DocumentSnapshot> user = Firestore.instance
//         .collection("users")
//         .snapshots();

//     final Stream<QuerySnapshot> cards =
//         Firestore.instance.collection("cards").snapshots();

    // CombineLatestStream.list([user, cards]).listen((data) {
    //   add(LoadedHomeEvent(
    //     data.elementAt(0),
    //     data.elementAt(1),
    //   ));
    // });

  @override
  Widget build(BuildContext context) {
    // List <Widget> stars = <Widget>[];

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: StreamBuilder(
        stream: _cafes,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image.network(
                          documentSnapshot["Images"][0],
                        ),
                        title: Text(documentSnapshot["Name"]),
                        subtitle: Text(documentSnapshot["Address"]),
                        onTap: () {
                          name = documentSnapshot["Name"];
                          address = documentSnapshot["Address"];
                          imageURL = documentSnapshot["Images"][0];
                          rating = documentSnapshot["Ratings"];
                          hours = documentSnapshot["Hours"];
                          parking = documentSnapshot["Parking"];
                          review = documentSnapshot["Reviews"][0];
                          reviews = documentSnapshot["Reviews"];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestaurantDetailScreen()),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:
                            _getNumberOfStars(documentSnapshot["Ratings"]),
                      ),
                    ],
                  ),
                );
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

class RestaurantDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: genericAppBarColor,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Image.network(
            imageURL,
            height: 350,
            width: 400,
            // width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _getNumberOfStars(rating),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  address,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Opening Hours: " + hours,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Parking Type: " + parking,
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
              ),

              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Reviews",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                color: screenBackgroundColor,
                child: Column(
                  children: _getReviews(reviews),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
