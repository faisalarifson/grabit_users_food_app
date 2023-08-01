import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_food_app/models/address.dart';
import 'package:users_food_app/screens/order_tacking.dart';
import 'package:users_food_app/splash_screen/splash_screen.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
String orderId;
  bool isFromHistory;

   ShipmentAddressDesign({Key? key, this.model,required this.orderId, this.isFromHistory=false,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping Details: ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "-Name",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "-Phone Number",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        isFromHistory?SizedBox.shrink():   Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()async {


                var data= await FirebaseFirestore.instance
                    .collection("orders")
                    .doc(orderId)
                    .get();

                double lat=0;
double lng=0;
 String riderId='';
//try{
  lat=data['lat'];
  lng=data['lng'];
  riderId=data['riderUID'];
// }catch(e){
//   print("error: ${e.toString()}");
// }

                if(lat==0){

                }else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => OrderTracking(riderId: riderId,lat: lat,lng: lng,)),
                    ),
                  );
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(3.0, -1.0),
                    colors: [
                      Color(0xFF004B8D),
                      Color(0xFFffffff),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child:  Center(
                    child: Text(
                      "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
              ),
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: ((context) => const SplashScreen()),
                //   ),
                // );
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(3.0, -1.0),
                    colors: [
                      Color(0xFF004B8D),
                      Color(0xFFffffff),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                    child: Text(
                  "Go back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
