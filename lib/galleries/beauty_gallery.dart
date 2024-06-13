import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class BeautyGallery extends StatefulWidget {
  const BeautyGallery({super.key});

  @override
  State<BeautyGallery> createState() => _BeautyGalleryState();
}

class _BeautyGalleryState extends State<BeautyGallery> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection("products")
      .where("maincategory", isEqualTo: "beauty")
      .snapshots();
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<QuerySnapshot>(
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
              "This category \n\nHas no items yet!!!",
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
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
              itemBuilder: (context, index) {
                return ProductModel(
                  products: snapshot.data!.docs[index],
                );
              },
            ),
          );

        }
        return const CircularProgressIndicator();
      },
    );
  
  }
}
