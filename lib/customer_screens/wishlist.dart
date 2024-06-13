import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: AppbarBackButton(),
            actions: [
              context.watch<Wish>().getItems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(
                          context,
                          title: "Clear Wishlist",
                          description: "Are you sure to clear Wishlist",
                          navigate: () {
                            context.read<Wish>().clearWish();
                            Navigator.pop(context);
                          },
                          goBack: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
                    )
                  : SizedBox(),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppbarTitle(
              title: 'Wishlist',
            ),
          ),
          body: Provider.of<Wish>(context, listen: true).getItems.isEmpty
              ?
              //! similar to context.watch
              EmpthyWish()
              : wishItemTile(),
        ),
      ),
    );
  }

  Consumer<Wish> wishItemTile() {
    return Consumer<Wish>(
      builder: (context, cart, child) {
        return ListView.builder(
          itemCount: cart.count,
          itemBuilder: (context, index) {
            final prod = cart.getItems[index];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: Image.network(
                          cart.getItems[index].imageUrl[0].toString(),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cart.getItems[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cart.getItems[index].price
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<Wish>()
                                              .removItem(prod);
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EmpthyWish extends StatelessWidget {
  const EmpthyWish({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 50,
          ),

          // Container(
          //   height: 45,
          //   width: MediaQuery.of(context).size.width * 0.6,
          //   decoration: BoxDecoration(
          //       color: Colors.lightBlueAccent,
          //       borderRadius: BorderRadius.circular(25)),
          //   child: MaterialButton(
          //     minWidth: MediaQuery.of(context).size.width * 0.5,
          //     onPressed: () {
          //       Navigator.canPop(context)
          //           ? Navigator.pop(context)
          //           : Navigator.pushReplacementNamed(context, '/customer_home');
          //     },
          //     child: const Text(
          //       'Contiue Shopping',
          //       style: TextStyle(fontSize: 18, color: Colors.white),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
