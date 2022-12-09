import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';

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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('CafeName').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      if (searchName == "") {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Image.network(
                                  data['Images'][0],
                                ),
                                title: Text(data['Name']),
                                subtitle: Text(data['Address']),
                                onTap: () {
                                  name = data['Name'];
                                  address = data['Address'];
                                  imageURL = data['Images'][0];
                                  rating = data['Ratings'];
                                  hours = data['Hours'];
                                  parking = data['Parking'];
                                  reviews = data['Reviews'];
                                  // doc_id = data.id;
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
                      if (data['Name']
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
                                  data['Images'][0],
                                ),
                                title: Text(data['Name']),
                                subtitle: Text(data['Address']),
                                onTap: () {
                                  name = data['Name'];
                                  address = data['Address'];
                                  imageURL = data['Images'][0];
                                  rating = data['Ratings'];
                                  hours = data['Hours'];
                                  parking = data['Parking'];
                                  reviews = data['Reviews'];
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
                      return Container();
                    });
          },
        ));
  }
}

class RestaurantDetailScreen extends StatelessWidget {
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
  for (int i = list.length - 1; i > 0; i--) {
    count++;
    if (count < 3) {
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
        ],
      )),
      floatingActionButton: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 2, backgroundColor: genericButtonColor),
          onPressed: () {
            addReview(textController.text);
          },
          child: Text('Done'),
        ),
      ),
    );
  }
}

Future<void> addReview(String review) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final cafes = db.collection("CafeName");

  List<String> reviews = [];
  reviews.add(review);
  return cafes
      .doc(doc_id)
      .update({'Reviews': FieldValue.arrayUnion(reviews)})
      .then((value) => print("Review has been added"))
      .catchError((error) => print("Failed to add review: $error"));
}
