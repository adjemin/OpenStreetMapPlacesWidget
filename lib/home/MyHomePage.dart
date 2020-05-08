import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:open_street_map_widget/openstreetmap_places/OpenStreetMapPlacesWidget.dart';
import 'package:open_street_map_widget/openstreetmap_places/model/Place.dart';
import 'package:open_street_map_widget/util/country_picker/country.dart';



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController locationController = new TextEditingController();


  String address = "";

  // Location lastLocation;
  LatLng lastLocation;

  Country _currentCountry;

  @override
  void initState() {

    super.initState();

    _currentCountry = Country.CI;


  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text('OpenStreetMapWidget'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          color: Colors.white,
          padding: EdgeInsets.all(18.0),
          child: new Column(
            children: <Widget>[

              new InkWell(
                  onTap: (){

                    displayOpenStreetMapPlacesUI();
                    // displayGooglePlacesAutocompleteUI();

                  },
                  child: new Container(
                    padding: EdgeInsets.only(left:10.0, top:18.0, right: 10.0, bottom:18.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: new Row(
                      children: <Widget>[
                        Icon(Icons.location_on,color: Colors.pinkAccent ),
                        SizedBox(width: 10.0,),
                        (lastLocation == null)?
                        new Text("Emplacement", style: new TextStyle(color: Colors.black38, fontSize: 18.0),):
                        new Container(
                          width: MediaQuery.of(context).size.width - 100.0,
                          child: new Text(address, style: new TextStyle(color: Colors.black, fontSize: 18.0),),
                        )

                      ],
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  void displayOpenStreetMapPlacesUI() async{
    Place place = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        new OpenStreetMapPlacesWidget()) );

    if(place != null){
      setState(() {
        address = place.title;

        lastLocation = new LatLng(double.parse(place.lat), double.parse(place.lon));
      });
    }
  }


}
