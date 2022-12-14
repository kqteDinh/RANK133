import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rank133/Colors/Colors.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/profile.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantList extends StatefulWidget {
  static const routeName = '/restaurants';
  const RestaurantList({Key? key, User? user}) : super(key: key);

  @override
  _RestaurantListState createState() => _RestaurantListState();
}

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
final restaurantDatabase = db.collection("RestaurantName");
String name = "";
String address = "";
int rating = 0;
String imageURL = "";
String hours = "";
String parking = "";
String review = "";
List<dynamic> reviews = [];
String doc_id = "";

List<Widget> _getNumberOfStars(int rating) {
  List<Widget> stars = <Widget>[];
  int numOfEmptyStars = 5 - rating;
  stars.add(
    SizedBox(width: 10),
  );
  for (int i = 0; i < rating; i++) {
    stars.add(Icon(
      Icons.star,
      color: iconsColor,
    ));
  }
  for (int i = 0; i < numOfEmptyStars; i++) {
    stars.add(Icon(
      Icons.star_border,
      color: iconsColor,
    ));
  }
  return stars;
}

List<Widget> _getReviews(List<dynamic> list) {
  List<Widget> reviews = <Widget>[];
  int count = 0;
  for (int i = list.length - 1; i >= 0; i--) {
    count++;
    // if (count < 3) {
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
    // }
  }
  return reviews;
}


Future<DocumentSnapshot> _getUser(String id) {
  return usersDatabase.doc(auth.currentUser!.uid).get();
}

class _RestaurantListState extends State<RestaurantList> {
  // final Stream<QuerySnapshot<Map<String, dynamic>>> _cafes =
  //     FirebaseFirestore.instance.collection('CafeName').snapshots();
  final Stream<QuerySnapshot<Map<String, dynamic>>> _restaurants =
      FirebaseFirestore.instance.collection('RestaurantName').orderBy("Name").snapshots();  // For some reason orderby removes the Bad State: field does not exist error

  // Stream<QuerySnapshot> getData() {
  //   return MergeStream([_cafes, _restaurants]);
  // }

  @override
  Widget build(BuildContext context) {
    // List <Widget> stars = <Widget>[];

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: StreamBuilder(
        stream: _restaurants,
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          // direction: Axis.horizontal,
                          children: [
                            Text(documentSnapshot["FavCount"].toString()),
                            IconButton(
                              icon: FutureBuilder(
                                future: _getUser(auth.currentUser!.uid),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Icon(Icons.favorite_border);
                                  }
                                  if (snapshot.data != null) {
                                    DocumentSnapshot user = snapshot.data as DocumentSnapshot;
                                    List favs = user.get("Favorites");
                                    if(favs.contains(documentSnapshot.id)){
                                      return Icon(Icons.favorite, color: Colors.pink,);
                                    }
                                    else return Icon(Icons.favorite_border);
                                  }
                                  else{
                                    return Icon(Icons.favorite_border);
                                  }
                                },
                              ),
                              onPressed: () async{
                                DocumentSnapshot user = await usersDatabase.doc(auth.currentUser!.uid).get();
                                List favs = user.get("Favorites");
                                int favCount = documentSnapshot.get("FavCount") ?? 0;
                                if(favs.contains(documentSnapshot.id)){
                                  favs.remove(documentSnapshot.id);
                                  favCount--;
                                  if(favCount<0) favCount=0;
                                }
                                else{
                                  favs.add(documentSnapshot.id);
                                  favCount++;
                                }
                                usersDatabase.doc(auth.currentUser!.uid).set({"Favorites": favs});
                                restaurantDatabase.doc(documentSnapshot.id).set({"FavCount": favCount}, SetOptions(merge: true));
                                setState(() {
                                  // Call setState to refresh the page.
                                });
                              }
                            ),
                          ],
                        ),
                        onTap: () {
                          name = documentSnapshot["Name"];
                          address = documentSnapshot["Address"];
                          imageURL = documentSnapshot["Images"][0];
                          rating = documentSnapshot["Ratings"];
                          hours = documentSnapshot["Hours"];
                          parking = documentSnapshot["Parking"];
                          // review = documentSnapshot["Reviews"][0];
                          reviews = documentSnapshot["Reviews"];
                          doc_id = documentSnapshot.id;
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
        actions: [
          IconButton(
            icon: FutureBuilder(
              future: _getUser(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Icon(Icons.favorite_border);
                }
                if (snapshot.data != null) {
                  DocumentSnapshot user = snapshot.data as DocumentSnapshot;
                  List favs = user.get("Favorites");
                  if(favs.contains(doc_id)){
                    return Icon(Icons.favorite, color: Colors.pink,);
                  }
                  else return Icon(Icons.favorite_border);
                }
                else{
                  return Icon(Icons.favorite_border);
                }
              },
            ),
            onPressed: () async{
              DocumentSnapshot user = await usersDatabase.doc(auth.currentUser!.uid).get();
              DocumentSnapshot rest = await restaurantDatabase.doc(doc_id).get();
              List favs = user.get("Favorites");
              int favCount = rest.get("FavCount") ?? 0;
              if(favs.contains(doc_id)){
                favs.remove(doc_id);
                favCount--;
                if(favCount<0) favCount=0;
              }
              else{
                favs.add(doc_id);
                favCount++;
              }
              usersDatabase.doc(auth.currentUser!.uid).set({"Favorites": favs});
              restaurantDatabase.doc(doc_id).set({"FavCount": favCount}, SetOptions(merge: true));
              (context as Element).markNeedsBuild();
            }
          ),
        ],
        backgroundColor: genericAppBarColor,
        iconTheme: IconThemeData(
          color: iconsColor,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    child: Row(
                      children: [
                        Text(
                          "Reviews",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2, backgroundColor: genericButtonColor),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewScreen()),
                            );
                          },
                          child: Text('Add Review'),
                        )
                      ],
                    )),
                Container(
                  color: screenBackgroundColor,
                  child: Wrap(
                    children: _getReviews(reviews),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class ReviewScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
  }

  RegExp digitValidator = RegExp("[0-9]+");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: iconsColor,
        ),
        backgroundColor: genericAppBarColor,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
      body: SizedBox(
          child: Wrap(
        children: [
          SizedBox(
            height: 10,
            width: 100,
          ),
          TextField(
            controller: textController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Enter your Review',
              border: OutlineInputBorder(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2, backgroundColor: genericButtonColor),
              onPressed: () async {
                addReview(textController.text, context);
              },
              child: Text(
                'Done',
              ),
            ),
          )
        ],
      )),
    );
  }
}

Future<void> addReview(String review, dynamic context) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final restaurantDatabase = db.collection("RestaurantName");
  List<String> reviewList = [];
  reviewList.add(review);
  return restaurantDatabase
      .doc(doc_id)
      .update({'Reviews': FieldValue.arrayUnion(reviewList)})
      .then((value) => Navigator.pop(context,
          MaterialPageRoute(builder: (context) => RestaurantDetailScreen())))
      .catchError((error) => print("Failed to add review: $error"));
      
}
