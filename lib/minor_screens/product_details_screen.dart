import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screens/cart.dart';
import 'package:multi_store_app/main_screens/visit_store.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'full_images.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({super.key, required this.productDet});

  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final dynamic productDet;

  late List<dynamic> images = productDet['product_images'];

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection("products")
        .where("maincategory", isEqualTo: "${productDet["maincategory"]}")
        .where("subcategory", isEqualTo: "${productDet["subcategory"]}")
        .snapshots();
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: scaffoldKey,
          child: Scaffold(
            
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .45,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImagesScreen(
                                  imagesList: images,
                                ),
                              ),
                            );
                          },
                          child: Swiper(
                            itemCount: images.length,
                            pagination: SwiperPagination(
                              builder: SwiperPagination.fraction,
                            ),
                            itemBuilder: (context, index) {
                              return Image(
                                image: NetworkImage("${images[index]}"),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDet["product_name"],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "USD",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  productDet["price"].toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<Wish>().getItems.firstWhere(
                                              (element) =>
                                                  element.documentId ==
                                                  productDet['product_id'],
                                            ) !=
                                        null
                                    ? MyMessage.showSnackBar(scaffoldKey,
                                        "Item Already exist in wishlist")
                                    : context.read<Wish>().addWishItem(
                                          productDet["product_name"],
                                          productDet['price'],
                                          1,
                                          productDet['instack'],
                                          productDet['image_url'],
                                          productDet['document_id'],
                                          productDet['supplier_id'],
                                        );
                              },
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${productDet["instock"]} Pieces available in the stock",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ProductDetailsLabel(
                          label: "   Item Description    ",
                        ),
                        Text(
                          productDet["product_description"],
                          textScaleFactor: 1.1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueGrey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ProductDetailsLabel(
                          label: "   Similar Items    ",
                        ),
                        SizedBox(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _productStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                    staggeredTileBuilder: (context) =>
                                        const StaggeredTile.fit(1),
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
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisitStores(
                                  supplierId: productDet['supplier_id'],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.store)),
                      SizedBox(width: 20),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.shopping_cart)),
                    ],
                  ),
                  YellowButton(
                      label: "ADD TO CART",
                      onPressed: () {
                        context.read<Cart>().getItems.firstWhere(
                              (element) =>
                                  element.documentId == productDet['product_id'],
                            ) != null ? MyMessage.showSnackBar(scaffoldKey, "Item Already exist in cart") :
                        context.read<Cart>().addItem(
                              productDet["product_name"],
                              productDet['price'],
                              1,
                              productDet['instack'],
                              productDet['image_url'],
                              productDet['document_id'],
                              productDet['supplier_id'],
                            );
                      },
                      width: .55)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsLabel extends StatelessWidget {
  const ProductDetailsLabel({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                color: Colors.yellow.shade900,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
