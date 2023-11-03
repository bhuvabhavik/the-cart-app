import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:thecartapp/cart_model.dart';
import 'package:thecartapp/cart_provider.dart';
import 'package:thecartapp/cart_screen.dart';
import 'package:thecartapp/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {


  DBHelper dbHelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Oranges',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [100, 50, 60, 30, 65, 75, 200];
  List<String> productImage = [
    'https://www.shutterstock.com/image-photo/ripe-mango-isolated-on-white-260nw-1297537549.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://www.shutterstock.com/image-photo/cherry-isolated-on-white-cherries-260nw-1392023051.jpg',
    'https://media.istockphoto.com/photos/jingle-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612'
  ];
  @override
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Product List"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context,value,child){
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
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  height:100,
                                    width: 100,
                                    image: NetworkImage(
                                  productImage[index].toString(),
                                )),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(productName[index].toString(),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                      const SizedBox(height: 10,),
                                      Text("${productUnit[index]} ₹ ${productPrice[index]}",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                                      const SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: (){
                                                dbHelper!.insert(
                                                  Cart(id: index,
                                                      productId: index.toString(),
                                                      productName: productName[index].toString(),
                                                      initialPrice: productPrice[index] ,
                                                      productPrice: productPrice[index],
                                                      quantity: 1,
                                                      unitTag: productUnit[index].toString(),
                                                      image: productImage.toString())
                                                ).then((value){
                                                  cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                  cart.addCounter();

                                                    print('product is added to cart');
                                                }).onError((error, stackTrace) {
                                                          print(error.toString());
                                                });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: const Center(child: Text("Add to Cart",style: TextStyle(color: Colors.white),)),
                                          ),
                                        ),
                                      )
                                    ],

                                  ),
                                ),



                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),),


        ],
      ),
    );
  }
}





