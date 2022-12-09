import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rank133/Colors/appColors.dart';
import 'package:rank133/widgets/restaurantList.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({Key? key, User? user}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;
final restaurantDatabase = db.collection("RestaurantName");
final usersDatabase = db.collection("users");

class _ProfileScreenState extends State<ProfileScreen> {

  String name = auth.currentUser!.displayName ?? "No Name";
  String email = auth.currentUser!.email ?? "No email";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: screenBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 120,
                // backgroundImage: AssetImage("assets/Image/Paspotr.jpg"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 18,
            ),
            Text(email),
            SizedBox(
              height: 20,
            ),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 24.0,
                    ),
                    title: Text("Favorites"),
                    onTap: () async {
                      DocumentSnapshot userDoc = await usersDatabase.doc(auth.currentUser!.uid).get();
                      final favs = userDoc.get("Favorites");
                      if(favs.length == 0){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("You have not added any favorites"),
                        ));
                      }
                      else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FavoritesList(favs)),
                        );
                      }  
                    },
                  )
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    title: Text("Logout"),
                    onTap: () async {
                      auth.signOut();
                    },
                  )
                ),
                
              ],
            )
          ],
        ),

      ) 
    );
  }
}

class FavoritesList extends StatelessWidget{
  
  var _favs;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _favorites;
      
  FavoritesList(favs){
    _favs = favs;
    _favorites = FirebaseFirestore.instance.collection('RestaurantName').where("__name__", whereIn: _favs).snapshots();
    print(_favorites);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: genericAppBarColor,
        iconTheme: IconThemeData(
          color: iconsColor,
        ),
        title: Text(
          "Favorites",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: screenBackgroundColor,
      body: StreamBuilder(
        stream: _favorites,
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoriteDetailScreen(documentSnapshot['Name'], documentSnapshot['Images'][0], documentSnapshot['Address'], documentSnapshot['Parking'], documentSnapshot['Hours'], documentSnapshot['Reviews'], documentSnapshot['Ratings'])),
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


class FavoriteDetailScreen extends StatelessWidget {

  var name, imageURL, address, parking, hours, reviews, rating;

  FavoriteDetailScreen(name, imageURL, address, parking, hours, reviews, rating){
    this.name = name;
    this.imageURL = imageURL;
    this.address = address;
    this.parking = parking;
    this.hours = hours;
    this.reviews = reviews;
    this.rating = rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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