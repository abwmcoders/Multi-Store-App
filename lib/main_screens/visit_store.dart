import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class VisitStores extends StatefulWidget {
  const VisitStores({super.key, required this.supplierId});

  final String supplierId;

  @override
  State<VisitStores> createState() => _VisitStoresState();
}

class _VisitStoresState extends State<VisitStores> {
  @override
  Widget build(BuildContext context) {
    bool following = false;

    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection("products")
        .where("supplier_id", isEqualTo: widget.supplierId)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.supplierId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              leading: AppbarBackButton(color: Colors.amber,),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.network(
                          data['store_logo'],
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * .5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['store_name'].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                       data['supplier_id'] == FirebaseAuth.instance.currentUser!.uid ? Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * .3,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),

                          //Center(child: Text("FOLLOW", style: TextStyle(color: Colors.white, fontSize: 16,),)),

                          child: MaterialButton(
                            onPressed: () {
                              
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("EDIT"),
                                Icon(Icons.edit)
                              ],
                            ),
                          ),
                        ) : Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * .3,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      following = !following;
                                    });
                                  },
                                  child: following == true
                                      ? Text("FOLLOWING")
                                      : Text("FOLLOW"),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              flexibleSpace: Image.asset(
                "images/inapp/coverimage.jpg",
                fit: BoxFit.cover,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _productStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "This Store \n\nHas no items yet!!!",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          return ProductModel(
                            products: snapshot.data!.docs[index],
                          );
                        },
                      ),
                    );
                    // ListView(
                    //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    //     Map<String, dynamic> data =
                    //         document.data()! as Map<String, dynamic>;
                    //     return ListTile(
                    //       leading: Image.network(data['product_images'][0]),
                    //       title: Text(data["product_name"]),
                    //       subtitle: Text(data['price'].toString()),
                    //     );
                    //   }).toList(),
                    // );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          floatingActionButton: FloatingActionButton(onPressed: (){},
          backgroundColor: Colors.green,
          child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 40,),
          ),
          );
        }

        return Text("loading");
      },
    );
  }
}
