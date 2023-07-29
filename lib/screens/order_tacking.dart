import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../global/global.dart';

class OrderTracking extends StatefulWidget {
  OrderTracking({super.key, required this.riderId,required this.lat,required this.lng});

  String riderId;
  double lat;
  double lng;

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {



   Set<Marker> _markers ={};
   var isLoading=true;

   Future<Uint8List?> getBytesFromAsset(String path, int width) async {
     ByteData data = await rootBundle.load(path);
     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
     ui.FrameInfo fi = await codec.getNextFrame();
     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
   }
  addMarker()async{
    Uint8List? markerIcon = await getBytesFromAsset('images/foodPin.png', 100);
    Uint8List? markerIcon2 = await getBytesFromAsset('images/locationPin.png', 100);
_markers = {
      Marker(
        position: LatLng(widget.lat,widget.lng),
        markerId: MarkerId('marker_1'),
        icon: BitmapDescriptor.fromBytes(markerIcon!),
        infoWindow: InfoWindow(
          title: 'My Location',
          snippet: 'This is  my location marker.',
        ),
      ), Marker(
        position: LatLng(widget.lat+0.000100,widget.lng+0.000100),
        markerId: MarkerId('marker_2'),
        icon:BitmapDescriptor.fromBytes(markerIcon2!),
        infoWindow: InfoWindow(
          title: 'Driver Location',
          snippet: 'This is driver location marker.',
        ),
      ),
    };

isLoading=false;
setState(() {

});
  }
  @override
  void initState() {
    // TODO: implement initState
    addMarker();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("riders")
                .doc(widget.riderId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData&&!isLoading) {

                return GoogleMap(
                  markers: _markers,
                  onMapCreated: (controller) {},
                  initialCameraPosition:
                  CameraPosition(target: LatLng(widget.lat,widget.lng,),zoom: 14),
                );
              }
              else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
