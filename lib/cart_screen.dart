
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:thecartapp/db_helper.dart';
import 'cart_model.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("My Products"),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.getCounter().toString(),
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
              badgeAnimation: badges.BadgeAnimation.scale(
                animationDuration: Duration(milliseconds: 300),
              ),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        height:100,
                                        width: 100,
                                        child: Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(
                                              snapshot.data![index].image
                                                  .toString(),
                                            ),),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data![index].productName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      dbHelper!.delete(snapshot
                                                          .data![index].id!);
                                                      cart.removeCounter();
                                                      cart.removeTotalPrice(
                                                          double.parse(snapshot.data![index]
                                                              .productPrice!
                                                              .toString()));
                                                    },
                                                    child: Icon(Icons.delete)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${snapshot.data![index].unitTag.toString()} ₹ ${snapshot.data![index].productPrice.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child:Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                            onTap:(){

                                                  },
                                                            child:
                                                            Icon(Icons.remove,color: Colors.white,)),
                                                        Text(
                                                      snapshot.data![index].quantity.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),

                                                        InkWell(
                                                            onTap: (){
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price =  snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice = price*quantity;
                                                            dbHelper!.updateQuantity(


                                                              Cart(id: snapshot.data![index].id!,
                                                                  productId: snapshot.data![index].id!.toString(),
                                                                  productName: snapshot.data![index].productName!,
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag.toString(),
                                                                  image: snapshot.data![index].image.toString())
                                                            ).then((value){
                                                                  newPrice = 0;
                                                                  quantity = 0;
                                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace) {
                                                              print(error);
                                                            });
                                                            },
                                                            child:
                                                        Icon(Icons.add,color: Colors.white,)),
                                                      ],
                                                    ),

                                                ),
                                              ),
                                            )
                                            )],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }));
              } else {
                return Text('');
              }
            },
          ),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"?false:true,
              child: Column(
                children: [
                  ReusableWidget(
                      title: 'Sub Total',
                      value: r'₹' + value.getTotalPrice().toStringAsFixed(2)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
