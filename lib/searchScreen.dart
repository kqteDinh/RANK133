import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/RegisterScreen.dart';
import 'package:rank133/widgets/restaurantList.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/profile';
  const SearchScreen({Key? key, User? user}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String searchName = "";
String name = "";
String address = "";
int rating = 0;
String imageURL = "";
String hours = "";
String parking = "";
String review = "";
String doc_id = "";
List<dynamic> reviews = [];

class _SearchScreenState extends State<SearchScreen> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _restaurants =
      FirebaseFirestore.instance.collection('RestaurantName').orderBy("Name").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: iconsColor,
          ),
          backgroundColor: genericAppBarColor,
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  searchName = val;
                  address = val;
                });
              },
            ),
          )),
      body: StreamBuilder(
        stream: _restaurants,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                if (searchName == "") {
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
                            doc_id = documentSnapshot.id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantDetailScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                if (documentSnapshot['Name']
                    .toString()
                    .toLowerCase()
                    .startsWith(searchName.toLowerCase())) {
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
                            doc_id = documentSnapshot.id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantDetailScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
                return Column();
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

Future<DocumentSnapshot> _getUser(String id) {
  return usersDatabase.doc(auth.currentUser!.uid).get();
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
            child: 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 2, backgroundColor: genericButtonColor),
                onPressed: () {
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
      .then((value) => Navigator.pop(context))
      .catchError((error) => print("Failed to add review: $error"));
}
