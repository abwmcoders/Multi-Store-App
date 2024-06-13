import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  double? price;
  int? quantity;
  String? prodName;
  String? prodDescription;
  String? productId;

  final ImagePicker picker = ImagePicker();
  List<XFile> prodImages = [];
  List<String> productUrlList = [];
  dynamic pickedImageError;
  bool precessing = false;

  late String profileImage;

  String? _uid;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('Customers');

  String mainCatValue = "select category";

  String subCatValue = 'subcategory';
  List<String> sunCatList = [];

  void pickProdImages() async {
    try {
      final pickedImages = await picker.pickMultiImage(
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      if (pickedImages != null) {
        setState(() {
          prodImages = pickedImages;
        });
      }
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
      print(pickedImageError.toString());
    }
  }

  Future<void> uploadImages() async {
    if (mainCatValue != "select category" && subCatValue != "subcategory") {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        if (prodImages.isNotEmpty) {
          setState(() {
            precessing = true;
          });
          try {
            for (var image in prodImages) {
              firebaseStorage.Reference ref = firebaseStorage
                  .FirebaseStorage.instance
                  .ref("products/${path.basename(image.path)}");
              await ref.putFile(File(image.path)).whenComplete(() async {
                await ref.getDownloadURL().then((value) {
                  productUrlList.add(value);
                });
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          MyMessage.showSnackBar(scaffoldKey, "Please add product image");
        }
      } else {
        MyMessage.showSnackBar(scaffoldKey, "Please fill all fields");
      }
    } else {
      MyMessage.showSnackBar(scaffoldKey, "Please select product categories");
    }
  }

  void uploadData() async {
    if (productUrlList.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection("products");
      productId = const Uuid().v4();
      await productRef.doc(productId).set({
        "product_id": productId,
        "maincategory": mainCatValue,
        "subcategory": subCatValue,
        "price": price,
        "instock ": quantity,
        "product_name": prodName,
        "product_description": prodDescription,
        "user_id": FirebaseAuth.instance.currentUser!.uid,
        "product_images": productUrlList,
        "discount": 0,
      }).whenComplete(() {
        setState(() {
          precessing = false;
          prodImages = [];
          mainCatValue = "select category";
          // subCatValue = "subcategory";
          sunCatList = [];
          productUrlList = [];
        });
        formKey.currentState!.reset();
      });
    } else {}
  }

  // void uploadProduct() async {
  //   if (mainCatValue != "select category" && subCatValue != "subcategory") {
  //     if (formKey.currentState!.validate()) {
  //       formKey.currentState!.save();
  //       if (prodImages.isNotEmpty) {
  //         try {
  //           for (var image in prodImages) {
  //             firebaseStorage.Reference ref = firebaseStorage
  //                 .FirebaseStorage.instance
  //                 .ref("products/${path.basename(image.path)}");
  //             await ref.putFile(File(image.path)).whenComplete(() async {
  //               await ref.getDownloadURL().then((value) {
  //                 productUrlList.add(value);
  //               }).whenComplete(() async {
  //                 CollectionReference productRef =
  //                     FirebaseFirestore.instance.collection("products");
  //                 await productRef.doc().set({
  //                   "maincategory": mainCatValue,
  //                   "subcategory": subCatValue,
  //                   "price": price,
  //                   "instock ": quantity,
  //                   "product_name": prodName,
  //                   "product_description": prodDescription,
  //                   "user_id": FirebaseAuth.instance.currentUser!.uid,
  //                   "product_images": productUrlList,
  //                   "discount": 0,
  //                 });
  //               });
  //             });
  //           }
  //         } catch (e) {
  //           print(e);
  //         }
  //         setState(() {
  //           prodImages = [];
  //           mainCatValue = "select category";
  //           subCatValue = "subcategory";
  //         });
  //       } else {
  //         MyMessage.showSnackBar(scaffoldKey, "Please add product image");
  //       }
  //     } else {
  //       MyMessage.showSnackBar(scaffoldKey, "Please fill all fields");
  //     }
  //   } else {
  //     MyMessage.showSnackBar(scaffoldKey, "Please select product categories");
  //   }
  // }

  void selectedMainCat(String value) {
    if (value == "select category") {
      sunCatList = [];
    } else if (value == "men") {
      sunCatList = women;
    } else if (value == "men") {
      sunCatList = women;
    } else if (value == 'electronics') {
      sunCatList = electronics;
    } else if (value == 'accessories') {
      sunCatList = accessories;
    } else if (value == 'shoes') {
      sunCatList = shoes;
    } else if (value == 'home & garden') {
      sunCatList = homeandgarden;
    } else if (value == 'beauty') {
      sunCatList = beauty;
    } else if (value == 'kids') {
      sunCatList = beauty;
    } else if (value == 'kids') {
      sunCatList = beauty;
    } else if (value == 'bags') {
      sunCatList = bags;
    }
    setState(() {
      mainCatValue = value!;
      subCatValue = "subcategory";
    });
  }

  Widget previewImages() {
    return ListView.builder(
      itemCount: prodImages.length,
      itemBuilder: (context, index) {
        return Image.file(File(prodImages[index].path));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: Colors.blueGrey.shade200,
                            height: size.width * .5,
                            width: size.width * .5,
                            child: prodImages.isEmpty
                                ? const Center(
                                    child: Text(
                                      "You have not \n\npicked image yet",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : previewImages(),
                          ),
                          prodImages.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      prodImages = [];
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: size.width * .5,
                        width: size.width * .5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "* Select Main Category",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  value: mainCatValue,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor: Colors.amber.shade400,
                                  items: maincateg
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  // [
                                  //   DropdownMenuItem(
                                  //     child: Text("Men"),
                                  //     value: "Men",
                                  //   ),
                                  //   DropdownMenuItem(
                                  //       child: Text("Women"), value: "Women"),
                                  //   DropdownMenuItem(
                                  //     child: Text("Shoes"),
                                  //     value: "Shoes",
                                  //   ),
                                  // ],
                                  onChanged: ((value) {
                                    selectedMainCat(value!);
                                  }),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "* Select Sub Category",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                DropdownButton(
                                  iconSize: 40,
                                  iconEnabledColor: Colors.red,
                                  dropdownColor: Colors.amber.shade400,
                                  iconDisabledColor: Colors.black,
                                  menuMaxHeight: 500,
                                  disabledHint:
                                      const Text("Select main category"),
                                  value: subCatValue,
                                  items: sunCatList
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: ((value) {
                                    setState(() {
                                      subCatValue = value!;
                                    });
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.amber,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .38,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter price for this product";
                          } else if (value.isValidPrice()) {
                            return "Invalid price";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: formDecoration.copyWith(
                          label: const Text("Price"),
                          hintText: "price ...\$",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter quantity for this product";
                          } else if (value.isValidQuantity() == false) {
                            return "Not valid quantity";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        decoration: formDecoration.copyWith(
                          label: const Text("Quantity"),
                          hintText: "Add quantity",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter name for this product";
                          }
                        },
                        onChanged: (value) {
                          prodName = value;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 100,
                        maxLines: 3,
                        decoration: formDecoration.copyWith(
                          label: const Text("Product name"),
                          hintText: "Enter product name",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter description for this product";
                          }
                        },
                        onChanged: (value) {
                          prodDescription = value;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: formDecoration.copyWith(
                          label: const Text("Product Description"),
                          hintText: "Enter product description",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: FloatingActionButton(
                onPressed: prodImages.isEmpty
                    ? () {
                        pickProdImages();
                      }
                    : () {
                        setState(() {
                          prodImages = [];
                        });
                      },
                backgroundColor: Colors.amber,
                child: Icon(
                  prodImages.isEmpty
                      ? Icons.photo_library
                      : Icons.delete_forever,
                  color: Colors.black,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: precessing == true ? (){} : () {
                uploadProduct();
              },
              backgroundColor: Colors.amber,
              child: precessing == true
                  ? const CircularProgressIndicator(color: Colors.black,)
                  : const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadProduct() async {
    await uploadImages().whenComplete(
      () => uploadData(),
    );
  }
}

var formDecoration = InputDecoration(
  label: const Text("Price"),
  hintText: "price ...\$",
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.amber,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.blueAccent,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*    $').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.])||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
