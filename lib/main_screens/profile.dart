import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customer_screens/customer_orders.dart';
import 'package:multi_store_app/customer_screens/wishlist.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

import '../widgets/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  final String documentId;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

      CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseAuth.instance.currentUser!.isAnonymous ? anonymous.doc(widget.documentId).get() : customers.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("An unknown error occured");
          }
          else if (snapshot.hasData && !snapshot.data!.exists) {
            print("snapshot 0-----> ${snapshot.data!.data()}");
            return const Text("Document does not exists");
          }
         else if (snapshot.hasError) {
            return const Text("An unknown error occured");
          } 
          else if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            //print("Fullname: ${data['name']}, Fullname: ${data['name']}, Fullname: ${data['name']},");
            return Scaffold(
              backgroundColor: Colors.grey.shade300,
              body: Stack(
                children: [
                  Container(
                    height: 230,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.brown])),
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        centerTitle: true,
                        pinned: true,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        expandedHeight: 140,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {
                            return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity:
                                    constraints.biggest.height <= 120 ? 1 : 0,
                                child: const Text(
                                  'Account',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              background: Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Colors.yellow, Colors.brown])),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, left: 30),
                                  child: Row(
                                    children: [
                                      data['profile_image'] == "" ?
                                      const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'images/inapp/guest.jpg'),
                                      ) : 
                                      CircleAvatar(
                                        radius: 50,
                                         backgroundImage: NetworkImage(data['profile_image'].toString()),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: Text(
                                          data['name'] != ""
                                              ? data['name']
                                                  .toString()
                                                  .toUpperCase()
                                              : 'guest'.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30))),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Cart',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CartScreen(
                                                      back: AppbarBackButton(),
                                                    )));
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Colors.yellow,
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Orders',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CustomerOrders()));
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                    child: TextButton(
                                      child: SizedBox(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const Center(
                                          child: Text(
                                            'Wishlist',
                                            style: TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Wishlist()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade300,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 150,
                                    child: Image(
                                        image: AssetImage(
                                            'images/inapp/logo.jpg')),
                                  ),
                                  const ProfileHeaderLabel(
                                    headerLabel: '  Account Info.  ',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 260,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          RepeatedListTile(
                                              icon: Icons.email,
                                              subTitle: data['email'] == "" ? "example@gmail.com" : data['email']
                                                      .toString(),
                                              title: 'Email Address'),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                              icon: Icons.phone,
                                              subTitle: data['phon_number'] == "" ? "example: +234 777...": data['phon_number'].toString(),
                                              title: 'Phone No.'),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                              icon: Icons.location_pin,
                                              subTitle:
                                                  data['address'] == "" ? "example: lagos ketu" : data['address'].toString(),
                                              title: 'Address'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const ProfileHeaderLabel(
                                      headerLabel: '  Account Settings  '),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 260,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          RepeatedListTile(
                                            title: 'Edit Profile',
                                            subTitle: '',
                                            icon: Icons.edit,
                                            onPressed: () {},
                                          ),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            title: 'Change Password',
                                            icon: Icons.lock,
                                            onPressed: () {},
                                          ),
                                          const YellowDivider(),
                                          RepeatedListTile(
                                            title: 'Log Out',
                                            icon: Icons.logout,
                                            onPressed: () async {
                                              MyAlertDialog.showMyDialog(
                                                  context,
                                                  title: "Log Out",
                                                  description:
                                                      "Are you sure you want to log out",
                                                  navigate: () async {
                                                await FirebaseAuth.instance
                                                    .signOut();
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                    context, '/welcome_screen');
                                              }, goBack: () {
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.purpleAccent,),
                Text("Loading ..."),
              ],
            ),
          );
        });
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
      required this.icon,
      this.onPressed,
      this.subTitle = '',
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
                color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  
  }
}
