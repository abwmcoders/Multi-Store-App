import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/widgets/alert_dialog.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final Widget? back;
  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            leading: back,
            actions: [
             context.watch<Cart>().getItems.isNotEmpty ? IconButton(
                  onPressed: () {
                    MyAlertDialog.showMyDialog(
                      context,
                      title: "Clear Cart",
                      description: "Are you sure to clear cart",
                      navigate: () {
                        context.read<Cart>().clearCard();
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
                  ),) : SizedBox(),
            ],
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppbarTitle(
              title: 'Cart',
            ),
          ),
          body: Provider.of<Cart>(context, listen: true).getItems.isEmpty
              ?
              //! similar to context.watch
              EmpthyCart()
              : cartItemTile(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Total: \$ ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      //'00.00',
                      context.watch<Cart>().totalPrice.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                YellowButton(
                  width: 0.45,
                  label: 'CHECK OUT',
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Consumer<Cart> cartItemTile() {
    return Consumer<Cart>(
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
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        prod.quantity == 1
                                            ? IconButton(
                                                onPressed: () {
                                                  cart.removItem(prod);
                                                },
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  size: 18,
                                                ),
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  cart.decreement(
                                                      cart.getItems[index]);
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.minus,
                                                  size: 18,
                                                ),
                                              ),
                                        Text(
                                          prod.quantity.toString(),
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: prod.quantity == prod.inStock
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: prod.quantity ==
                                                  prod.inStock
                                              ? null
                                              : () {
                                                  //! SHOWSNACKBAR
                                                  prod.quantity == prod.inStock
                                                      ? null
                                                      : cart.increement(prod);
                                                },
                                          icon: Icon(
                                            FontAwesomeIcons.plus,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
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

class EmpthyCart extends StatelessWidget {
  const EmpthyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Cart Is Empty !',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(25)),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.5,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Contiue Shopping',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
